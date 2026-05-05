# REQ Files
This document explains the purpose and function of `.req` and related `.mrq` files and how they result in chunked binary `.lvl` files.

Sections:
- REQ Files (lines 11-56)
- MRQ Files (lines 58-59)
- LVL Files (lines 61-62)

---

# REQ Files
Text files listing required modtool assets by filename **without extensions** to be packed into lvl file(s) when munged. They have one or more REQN sections separated by asset type, including other req files to be hierarchically packed into the resulting chunked lvl file. It may also have a `"platform=alias"` key that will only include certain REQN sections depending on the platform alias. Possible alias values are "pc", "xbox", or "ps2". For sound req files, an additional key `"align=<int>"` can adjust the byte-alignment of `str` and `bnk` REQN sections (typically 2048).

The corresponding assetType labels are associated with these modtools filetypes
| Asset Type | Modtools Filetype(s) |
| :--- | :--- |
| "animbank" | `.anims`, `.zaabin`, `.zafbin` |
| "bin" | `.bin` |
| "bnk" | `.sfx`, `.asfx` (Sound Effects)|
| "boundary" | `.bnd` (World Boundaries)|
| "class" | `.odf` |
| "config" | `.sky`, `.hud`, `.mcfg`, `.sanm`, `.snd`, `.mus`, `.ffx`, `.fx` (Particle Effects) |
| "congraph" | `.pln` (AI Planning) |
| "envfx" | `.fx` (World Effects) |
| "light" | `.lgt` |
| "loc" | `.cfg` (Localization) |
| "lvl" | `.req`, `.mrq` |
| "model" | `.msh` |
| "path" | `.pth` |
| "povs" | `.pvs` (Portals and Sectors) |
| "prop" | `.prp` (Foliage) |
| "script" | `.lua` |
| "str" | `.stm`, `.st4` (Sound Streams) |
| "terrain" | `.ter` |
| "texture" | `.tga` |
| "world" | `.wld`, `.lyr` |

## Schema
```
ucft
{
    REQN
    {
        "assetType1"
        "assetFilename1"
        "assetFilename2"
    }
    REQN
    {
        "assetType2"
        "platform=pc"
        "assetFilename3"
        "assetFilename4"
    }
}
```

# MRQ Files
Simimlar to `.req` files, these are text files listing required modtool assets by filename (without extensions) to be packed into lvl file(s) when munged. They have one or more REQN sections separated by asset type. They are different from `.req` files in that they are specific to world-layer packaging for gamemodes. Typically only including `congraph` and `world` REQN sections, they call for `.lyr` files that define world layers to be packed together into a sublvl of the resulting main world `.lvl` file. Their schema is the same as `.req` files.

# LVL Files
`.lvl` files are the resulting chunked binary files that contain all the munged assets listed in their preceding `.req` or `.mrq` file. They are named the same as their preceding req/mrq file, and can be packed into another `.lvl` file to create sub-lvls contained inside a single main `.lvl` file. When read by the game, assets from the base req's REQN sections will always be read, with an optional second argument for a sub-lvl to avoid loading assets from other sub-lvls. 
