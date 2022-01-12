# Anatomy of a FF7R Font

A font in FF7R is made up two sets of assets:

1. a set of textures representing a map of characters in the font,
2. a data structure with information about where to find each character on the
   map textures.

## Font Textures

The textures are stored in `End\Content\GameContents\Menu\Billboard\Common` in
`*.uasset` and `*.uexp` files with names like `U_Com_JP_SystemFontNormal-00`.
The filename is structured with the following format:

```
      The language of the font. (JP and US share a font.)
      |  The name of the font. (SystemFont, DigitFont, etc.)
      |  |         The size of the font. (Normal, Large, XLarge, etc.)
      |  |         |     The resolution of the font. (Either 4K or nothing.)
      |  |         |     |  The index of the texture file.
      v  v         v     v  v
U_COM_JP_SystemFontNormal4K-00
```

Some fonts require more than one texture file. If this is required, additional
asset files will have the same name with a different index. (e.g.
`U_COM_JP_SystemFontNormal-01`, `U_COM_JP_SystemFontNormal-02`, etc.)

Each texture is contained in a pair of files with the same basename, but with
different file extensions. The `*.uasset` file contains information about the
type of data in the `*.uexp` file, and the `*.uexp` file contains the texture
information. Tools like [UE Viewer](https://www.gildor.org/en/projects/umodel)
can extract the textures from the files.

## Font Data

The data for each font is stored in
`End\Content\GameContents\Menu\Resident\Font` in folders for the font's
language, and in `*.uasset` and `*.uexp` files with names like
`SystemFontNormal`. The filename is structured with the following format:

```
The language of the font. (JP and US share a font.)
|  The name of the font. (SystemFont, DigitFont, etc.)
|  |         The size of the font. (Normal, Large, XLarge, etc.)
|  |         |     The resolution of the font. (Either 4K or nothing.)
v  v         v     v
JP\SystemFontNormal4K
```

Similar to the texture files, the font data is contained in a pair of `*.uasset`
and `*.uexp` files. There is no known tool to extract this information yet, and
analyzing the `*.uexp` file for what its data means is a work in progress
described here.

### Font Data Structure

The `*.uexp` file for font data has the following known structure so far.

```
Offset  Data Type         Info
0x0000  8 bytes           Unknown information
0x0008  32-bit integer    The number of characters in the font

0x000C  For each character (relative offsets follow):

0x0000  UTF-16 code unit  The current character
0x0002  16-bit integer    The texture index where the character resides
0x0004  16-bit integer    The X coordinate of the character on the texture map
0x0006  16-bit integer    The Y coordinate of the character on the texture map
0x0008  16-bit integer    The width of the character on the texture map
0x000A  16-bit integer    The height of the character on the texture map
0x000C  6 bytes           Unknown information. Appears to be three more 16-bit
                          integers. Possibly information about baseline or
                          kerning.
```
