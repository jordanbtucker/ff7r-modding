# USkeletalMesh4 Data Map

```
type FNameRef
  index int32
  instance int32

type FGuid
  A uint32
  B uint32
  C uint32
  D uint32

type TArray<T>
  Count int32
  Items T[]

type TMapPair<TK, TV>
  Key TK
  Value TV

type TMap<TK, TV>
  Map TArray<TMapPair<TK, TV>>

type FStripDataFlags
  GlobalStripFlags byte
  ClassStripFlags byte

type FVector
  X float
  Y float
  Z float

type FBoxSphereBounds
  Origin FVector
  BoxExtent FVector
  SphereRadius float

type UMaterialInterface
  index int32 # Import

type FMeshUVChannelInfo
  bInitialized bool4
  bOverrideDensities bool4
  LocalUVDensities float[4]

type FSkeletalMaterial
  Material UMaterialInterface
  MaterialSlotName FNameRef
  UVChannelData FMeshUVChannelInfo

type FMeshBoneInfo
  Name FNameRef
  ParentIndex int32

type FVector4
  X float
  Y float
  Z float
  W float

type FQuat
  X float
  Y float
  Z float
  W float

type FTransform
  Rotation FQuat
  Translation FVector
  Scale3D FVector

type FReferenceSkeleton
  RefBoneInfo TArray<FMeshBoneInfo>
  RefBonePose TArray<FTransform>
  NameToIndexMap TMap<FNameRef, int32>

type FApexClothPhysToRenderVertData
  PositionBaryCoordsAndDist FVector4
  NormalBaryCoordsAndDist FVector4
  TangentBaryCoordsAndDist FVector4
  SimulMeshVertIndices int16[4]
  Padding int32[2]

type FClothingSectionData
  AssetGuid FGuid
  AssetLodIndex int32

type FSkelMeshSection4
  StripFlags FStripDataFlags
  MaterialIndex int16
  BaseIndex int32
  NumTriangles int32
  TriangleSorting byte
  bDisabled bool4
  CorrespondClothSectionIndex int16
  bEnableClothLOD_DEPRECATED byte
  bRecomputeTangent bool4
  bCastShadow bool4
  BaseVertexIndex uint32
  BoneMap TArray<uint16>
  NumVertices int32
  MaxBoneInfluences int32
  ClothMappingData TArray<FApexClothPhysToRenderVertData>
  PhysicalMeshVertices TArray<FVector>
  PhysicalMeshNormals TArray<FVector>
  CorrespondClothAssetIndex int16
  ClothingData FClothingSectionData
  unk1 int32
  unk2 int32
    if unk1
      skip unk2 * 16 bytes

type FMultisizeIndexContainer
  DataSize byte
    if DataSize == 2
      Indices16 TArray<uint16>
    else
      Indices32 TArray<uint32>

type FPackedNormal
  Data uint32
  Pos FVector

type FMeshUVHalf
  uint16 U
  uint16 V

type FMeshUVFloat
  float U
  float V

type FGPUVert4Half
  Normal[0] FPackedNormal
  Normal[2] FPackedNormal
  UV FMeshUVHalf[parent.NumTexCoords]

type FGPUVert4Float
  Normal[0] FPackedNormal
  Normal[2] FPackedNormal
  UV FMeshUVFloat[parent.NumTexCoords]

type FSkeletalMeshVertexBuffer4
  StripFlags FStripDataFlags
  NumTexCoords int32
  bUseFullPrecisionUVs bool4
  MeshExtension FVector
  MeshOrigin FVector
    if not bUseFullPrecisionUVs
      VertsHalf TArray<FGPUVert4Half>
    else
      VertsFloat TArray<FGPUVert4Float>

type FSkinWeightInfo
  BoneIndex byte[bExtraBoneInfluences ? 8 : 4]
  BoneWeight byte[bExtraBoneInfluences ? 8 : 4]

type FSkinWeightVertexBuffer
  SkinWeightStripFlags FStripDataFlags
  bExtraBoneInfluences bool4
  NumVertices int32
  Weights TArray<FSkinWeightInfo>
  # possible conditional for bHasVertexColors

type FStaticLODModel4
  StripFlags FStripDataFlags
  Sections TArray<FSkelMeshSection4>
  Indices FMultisizeIndexContainer
  ActiveBoneIndices TArray<int16>
  Size int32
  NumVertices int32
  RequiredBones TArray<int16>
  MeshToImportVertexMap TArray<int32>
  MaxImportVertex int32
  NumTexCoords int32
  VertexBufferGPUSkin FSkeletalMeshVertexBuffer4
  SkinWeights FSkinWeightVertexBuffer
  AdjacencyIndexBuffer FMultisizeIndexContainer # read conditionally, but the condition is yet unknown

type USkeletalMesh4
  StripFlags FStripDataFlags
  Bounds FBoxSphereBounds
  Materials TArray<FSkeletalMaterial>
  RefSkeleton FReferenceSkeleton
  LODModels TArray<FStaticLODModel4>
```
