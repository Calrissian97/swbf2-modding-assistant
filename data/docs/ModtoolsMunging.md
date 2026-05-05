# Munging
This document explains munging of swbf2 modtool files. Munging consists of processing input files (with optional parameters in companion .option files) via specific munging programs that transform the underlying data into a binary form ingestible for the game.

Sections:
 - Munging Assets (lines 17-31)
 - REQ to LVL Munging (lines 33-38)
 - Animations Munging (lines 40-45)
 - Sounds Munging (lines 47-49)
 - Sides Munging (lines 51-62)
 - Movies Munging (lines 64-66)
 - Scripts Munging (lines 68-73)
 - Models Munging (lines 75-78)
 - Textures Munging (lines 80-81)

---

# Munging Assets
Munging modtool files is orchestrated through bat scripts that compile and pack raw assets into `.lvl` files for the game engine to read. 

## Munge Methods:
*   **Manual Execution**: Running `.bat` scripts directly from the command line.
*   **VisualMunge.exe**: The official Modtools program found in your addon's `_BUILD` subfolder.
*   **ZeroMunge**: A modern, third-party alternative providing more granular control.

## Output and Deployment:
*   Munged assets are output to the addon folder's `_LVL_PC` directory.
*   These files are then copied to the game's installation directory under `GameData/addon/YourAddonNameHere`.
*   **Incremental Builds**: The munger compares timestamps and only recompiles files that have changed since the last build.

## Troubleshooting:
If errors occur, an error log will pop up. Detailed logs for each category can be found in the addon's `_BUILD` directory within their respective subfolders.

# Core Concepts
## REQ Files
REQ files are text files that list required assets to be munged and packed into a compiled lvl file.

## Sub-lvls
REQ files can define child lvl chunks to be packed into this req's `.lvl` file. This allows for independent loading of specific assets (like a single unit or vehicle), while assets listed in the base `.req` are always loaded upon a `ReadDataFile` call in a Lua script. Even sub-lvl req files will produce a `.lvl` file, but these will be later embedded into a parent `.lvl` file by a specific packing program during munging.

## Animations
### Munging animations from msh files
MSH model files can also contain an embedded animation sequence. When munging animations, each msh file name gets recorded as an animation once munged. At least a basepose.msh is required for animation munging, which typically only has frames 0 and 1 keyed to provide skeleton data. Each additional msh file adds an animation to the munged animation files (anims, zafbin, zaabin).

### Munging munged animation files
Munged animation files (anims, zafbin, zaabin) are detected by the munging program and packed into requiring lvl files by a packing program.

## Sounds
### Fixed munge bat scripts
There is a set of updated munge bat scripts designed to work on modern Windows operating systems. These often fix common failures to munge sounds and can be found here: [Sound Munge Fixes](https://app.box.com/s/4nuc1a9qc590lrp40cuaax9ny5aw78ed).

## Sides
### Munging a stock side
Munging stock sides is fairly simple as their munge bat scripts are typically copied from BF2_Modtools/data/_BUILD/Side into addon data folders. Simply select the side in the sides dropdown of the Modtools VisualMunge.exe program and click munge.

### Munging a custom side
Munging custom sides takes a few extra steps. Inside `BF2_Modtools/data_.../_BUILD/Side`, copy one of the stock side folders and rename it to your side's name. Edit the `munge.bat` inside to target your custom side.

For example, if your side is named "NEW":
```batch
@call ..\munge_side.bat NEW %1
```
After this, the side will appear as a selectable element in the `VisualMunge.exe` dropdown.

## Movies
### Manual munging of movies
Movies are typically found in `data_.../shell/movies`. If they fail to munge through standard tools, you can munge them manually by calling `MovieMunger.exe` from `ToolsFL/bin` on an `.mlst` file to produce an `.mvs` file.

## Scripts
### Munging mission scripts
Munging mission scripts is fairly simple, the main thing to remember is you must have a corresponding req for each mission script so that they are included in the addon's mission.lvl.

### Munging addme
Munging the `addme.lua` is automatic during a standard build. You can also manually run `MungeAddme.bat` in the `addme` folder, which produces a `addme.script` file in `addme/munged`.

## Models
Munging models can produce several warnings that can usually be ignored. Errors, however, must be fixed. The most common error is **invalid shadow volume geometry**. Shadow volumes must not be concave, have disconnected polygons, or holes.
### Model Munging Proxy
If munging a large amount of models seems to be taking too long for your liking, you may use this tool: https://github.com/PrismaticFlower/proxy_modelmunge. This simply calls multiple instances of the model munging program to run in parallel instead of serially processing each msh file.

## Textures
Munging textures rarely produces errors, the most common case being texture size not being a power of 2, or a tga texture using RLE compression which is *not* supported.
