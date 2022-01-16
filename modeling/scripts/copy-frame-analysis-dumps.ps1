param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]
  $FrameAnalysisDirectory,
  [Parameter(Mandatory = $true, Position = 1)]
  [string]
  $IBHash,
  [Parameter(Mandatory = $true, Position = 2)]
  [string]
  $OutputDirectory
)

# Get all *.txt files in the frame analysis directory
$txtFiles = Get-ChildItem -Path $FrameAnalysisDirectory -File -Filter *.txt

# A map of IDs ('ib', 'vb0', 'vb2') with their hashes
$hashMap = @{}

# Find all ib files with a matching IBHash, extracts their prefixes, gets all
# ib, vb0, and vb2 files with those prefixes, and puts them into $hashMap
$txtFiles
| Select-Object -ExpandProperty Name
| Select-String "^(\d{6})-ib=$IBHash-"
| ForEach-Object { $_.Matches[0].Groups[1].Value }
| Select-Object -Unique
| ForEach-Object { $prefix = $_; $txtFiles
  | Where-Object { $_.Name -match "^$prefix-" } }
| Select-Object -ExpandProperty Name
| Select-String "-(ib|vb[02])=([0-9A-Fa-f]{8})-"
| ForEach-Object { $hashMap[$_.Matches[0].Groups[1].Value] = $_.Matches[0].Groups[2].Value }

# A map of file signatures (ID concatenated with SHA-256 hashes) with their files
$signatureMap = @{}

# Find all ib, vb0, and vb2 files with their corresponding hashes, performs a
# file hash on them to remove duplicates, then stores them in $signatureMap,
# automatically removing duplicates
$hashMap.Keys
| ForEach-Object { $id = $_; $hash = $hashMap[$id]; $txtFiles
  | Where-Object { $_.Name -match "-$id=$hash-" }
  | Sort-Object -Property Name -Descending
  | ForEach-Object { $signatureMap["$id-$((Get-FileHash $_).Hash)"] = $_ } }

# Create the output directory if it doesn't exist
if ( -not (Test-Path $OutputDirectory)) {
  New-Item -Path $OutputDirectory -ItemType Directory
}

# Copy all unique files to the output direcotry
$signatureMap.Values
| ForEach-Object { Copy-Item -Path $_ -Destination $OutputDirectory }
