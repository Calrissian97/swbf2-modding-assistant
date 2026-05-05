# Filetypes of the Star Wars Battlefront 2 Modtools
This document describes the various filetypes of the assets contained in BF2_Modtools.

Sections:
 - Backup Files (lines 47-48)
 - ODF Files (lines 50-52)
 - Combo Files (lines 54-55)
 - HUD Files (lines 57-59)
 - MSH Files (lines 61-66)
 - Animation Files (lines 68-76)
 - Texture Files (lines 78-83)
 - Script Files (lines 85-90)
 - Movie Files (lines 92-103)
 - Sound Files (lines 105-131)
 - Particle Effect Files (lines 133-135)
 - World Animation Files (lines 137-139)
 - World Effects Files (lines 141-143)
 - World Lights Files (lines 145-147)
 - World Sky Definition Files (lines 149-151)
 - World Portals and Sectors Files (lines 153-155)
 - World AI Barrier Files (lines 157-159)
 - World AI Planning Files (lines 161-163)
 - World AI Hintnode Files (lines 165-167)
 - World Foliage Files (lines 169-171)
 - World Paths Files (lines 173-175)
 - World Boundary Files (lines 177-179)
 - World Regions Files (lines 181-183)
 - World Terrain Files (lines 185-190)
 - Base World File (lines 192-194)
 - Layer World File (lines 196-198)
 - World Layer Groups (lines 200-202)
 - World Layers and Gamemodes (lines 204-206)
 - World Layer Requirements (lines 208-210)
 - World Object Groups (lines 212-214)
 - Font Files (lines 216-221)
 - Localization Files (lines 223-225)
 - Level Files- .req, .mrq, .lvl (lines 227-244)
 - World Creation Files (lines 246-254)
 - World Stats Files (lines 256-257)
 - Munging Files (lines 259-267)
 - Debugging Files (lines 269-274)
 - Miscellaneous (lines 276-293)
 - Documentation (lines 295-296)

---

## .bak
Backup files for all modtools file types. Used to save old copies of assets.

# Object Definition Files (Game Classes)
## .odf
Text files defining game object class properties for all entities (props, soldiers, cloth, lights, dust, godrays etc), written by hand.

# .combo
Text files defining animation playback and available controls for melee attack combinations, written by hand for each class utilizing melee weapons requiring behavior outside defaults.

# Heads Up Display Files
## .hud
Text files defining what and how entities are displayed on the player's HUD, such as team reinforcement counts, minimaps, weapon model positions and rotations, weapon ammunition counts, entity names, and healthbars. They can be edited using the programmer's build of the game by appending /hud to the commandline when running, and hitting CTRL+E on the keyboard to show the HUD editing overlay, or written by hand.

# Meshes
## .msh
Chunked binary model files containing mesh data (models, materials, animations). These can be viewed with Calrissian97's fully-featured (models, animations, all material types, cloth simulation) MSH3JS webapp: https://calrissian97.github.io/MSH3JS/ or desktop application: https://github.com/Calrissian97/MSH3JS/releases, or AnakinGT's older OpenGL viewer: https://github.com/Gametoast/MeshViewer_OpenGL (more limited, no cloth support). MSH files can be imported/exported along with embedded animations in either the Autodesk Softimage or XSI Modtools 3D modelling programs using the following plugin: https://github.com/Schlechtwetterfront/xsizetools or in Blender with the following addon: https://github.com/Calrissian97/SWBF-msh-Blender-IO. Other tools for editing msh files include the console app MSHConsole: https://github.com/Calrissian97/MSHConsole/releases, or the GUI app MSHEditor: https://github.com/Ben1138/MSHEditor. They can also be converted to Autodesk FBX format via MSH2FBX: https://github.com/Ben1138/MSH2FBX.

## .msh.option
Text files containing parameters read when munging msh files to modify what is packed into the resulting lvl file, written by hand.

# Animations
## .zaabin
Chunked binary files containing keyframe data for all animations, munged from msh files. These are created by an animation munger from msh files.

## .zafbin
Chunked binary files containing mesh skeleton data, created by an animation munger from msh files.

## .anims
Text file in a req format listing animations inside neighboring zaabin files, created by an animation munger from msh files.

# Textures
## .tga
Binary texture files in TGA format without RLE compression. Size must be a power of 2, exceptions are cubemaps. These can be edited in several image editor programs, recommended appliacation is GIMP.

## .tga.option
Text files containing parameters read when munging tga files to modify their formatting in the resulting lvl file, written by hand.

# Scripts
## .lua
Text files containing scripts to be run by a Pandemic Studios- modified version of lua 5.0.2, written by hand. There is a lua API and auto-complete VS Code extension by Marth8880 here: https://github.com/Gametoast/SWBF2-Lua-API.

## .addme
Text files containing lua 5.0.2 scripts that define what gamemodes are displayed and selectable for an addon map from the Instant Action screen, adds these gamemode's mission scripts to the table of missions, reads the core.lvl for localization strings for an addon, the color of the text used for displaying the map name on the Instant Action screen, and preview movie to play when the map name is selected, written by hand.

# Movies
## .mvs
Munged chunked binary files containing packed bik movies and playback configuration data.

## .mcfg
Text files defining named movie playback properties and listing containing movie segments, written by hand.

## .mlst
Text files listing relative paths to bik movie files to be munged, used by moviemunger to produce a mvs, written by hand.

## .bik
Binary movie files in RadTools BIK format to be played either in the game interface (shell) or ingame (during mission gameplay). These can be viewed in VLC or RadGameTools which also supports bik video file creation.

# Sounds
## .sfx
Text file list of relative paths to stock mono or stereo wav sound files to munged into a shared bank of sound effects inside a common.bnk file, written by hand. These are *not* used in modding, they are simply the file lists used to munge the game's shared sound bank used in the PC version only and is not accessible by modders.

## .asfx
Text file list of relative paths to additional short custom mono 22,050 to 44,100 Hz 16bit PCM wav sound files to be munged into a bank of sound effects inside a sound lvl, written by hand. Sounds can be resampled or aliased here, and it should be noted that tabs (\t) are invalid whitespace characters in this file, and their inclusion counts to the sound memory limit. These are held in memory are should be used for fast or frequent playback such as weapon, vehicle, or unit voice over sounds.

## .stm
Text file list of relative paths to mono or stereo 44,100 to 48,000 Hz 16bit PCM wav sound files to be munged into a "stream" of "sound streams" inside a sound lvl, written by hand. These "sound streams" do *not* count to the sound memory limit as they are streamed from disk during playback. Sounds can be aliased here and it should be noted that tabs (\t) are invalid whitespace characters in this file. These are streamed from disk and should be used for infrequent but near-constant playback such as ambient world effects, music, or announcer voice overs.

## .st4
Text file list of relative paths to custom stereo 44,100 to 48,000 Hz 16bit PCM wav sound files to be munged into a "stream" of "sound streams" inside a sound lvl, written by hand. These "sound streams" do *not* count to the sound memory limit as they are streamed from disk during playback. Sounds can be aliased here and it should be noted that tabs (\t) are invalid whitespace characters in this file. As opposed to stm files, these files used Dolby Pro Logic II to simulate quadriphonic surround sound for the console versions of Star Wars Battlefront II (PS2, XBOX). 

## .snd
Text file for primary sound property naming and configurations, written by hand. Both sound stream and sound effect properties are defined here from asfx or stm listed sound files, with each property given a name and list of attributes such as sound sample name(s) or sound stream name, gain, pitch, looping, distances, reverb, rolloff, and priority. World sound space properties are also defined here, determining the reverb, gain, diffusion, density, rolloff, and decay of all sound effects that originate from within an associated world sound space region.

## .ffx
Text file for foley property grouping, written by hand. It lists a group of sound samples to be played for each type of foley (grass, wood, metal, stone, dirt, water, and terrain).

## .mus
Text file for defining music property names and playback configurations, written by hand. The sound stream sample name is listed within each property as well as playback parameters such as priority, fade in/out and playback time.

## .wav
Binary sound files in wav format to be played in-game. These can be formatted as mono or stereo 11,025 to 48,000 Hz 16bit PCM wav files. Can be created or edited in common audio editing programs such as Audacity.

## .tsr
Text file for sound trigger region configurations.

# Particle Effects
## .fx
Text files defining particle emitter behaviors and used meshes and textures. These can be created and edited in the ParticleEditor.exe program found in BF2_Modtools/ToolsFL/bin, or edited by hand.

# World Animations
## .anm
Text files defining animations of world objects. Animation properties are defined with a name and given rotation and translation keys for each animation. An animation group is also defined listing animations to play in that group and the names of objects to be animated by each animation. These are created in the level-editing program zeroeditor.exe.

# World Effects
## .fx
Text files defining world effects such as precipitation, sunflare, godrays, fog/dust, blur, etc, written by hand.

# World Lights
## .lgt
Text files defining the position, rotation, type, and attributes of all lights in a world, including a section for global lights such as up to two directional lights and the top and bottom ambient light colors. These are created by the level-editor ZeroEditor, placed by hand. Each world layer can have their own lgt file, and can be edited by hand.

# World Sky Definition
## .sky
Text files defining world fog and scene ranges, ambient colors, and sky dome properties such as msh dome models, cloud layer, low resolution terrain, terrain color and bump/detail map, and msh sky objects, written by hand.

# World Portals and Sectors
## .pvs
Text files defining polygon sectors and contained objects inside their bounds to be associated and rendered within their respective sector as well as rectangle portals associated with up to two sectors that determine if objects are culled in rendering if the portal is visible by a player or if the player is inside a sector. These are created by the level-editor ZeroEditor, placed by hand.

# World AI Barriers
## .bar
Text files defining AI barriers for a world defining 2D top-down rectangles that AI units will avoid. Can be targeted to SOLDIER, HOVER, SMALL, MEDIUM, HUGE, and FLYER AI Size Types. Barriers are named, and can be referenced in mission lua scripts to individually enable/disable barriers. These are created by the level-editor ZeroEditor, placed by hand.

# World AI Planning
## .pln
Text files defining named 2D top-down circle AI hubs and rectangle connections that create a connectivity graph AI units will follow to objectives. Connections can be targeted to SOLDIER, HOVER, SMALL, MEDIUM, HUGE, and FLYER AI Size Types. They can also be referenced in mission lua scripts to enable/disable connections. Both hubs and connections are created by the level-editor ZeroEditor, placed by hand. Each world layer can have their own pln file.

# World AI Hintnodes
## .hnt
Text files defining named nodes that advertise specific AI behaviors such as Snipe, Cover, Vehicle Cover, Patrolling, Mine laying, etc. These nodes have an orientation to dictate what direction the AI unit should be facing. These are created by the level-editor ZeroEditor and placed by hand. Each world layer can have their own hnt file.

# World Foliage
## .prp
Text files defining foliage layers used by the terrain that will spawn animated msh entities with properties for spread factor, frequency, scale, stiffness, and color variation, written by hand.

# World Paths
## .pth
Text files defining named Catmull-Rom spline paths. These paths can be used for either spawning entities (spawnpaths) or for entity following (entitypaths). Paths and path nodes can contain properties that dictate how path following entities behave when following a path. These are created by the level-editor ZeroEditor, placed by hand. Each world layer can have their own pth file, and can be edited by hand.

# World boundary
## .bnd
Text files defining named Catmull-Rom spline paths used for defining the playable region of a world (typically only one). Entities with health will be killed if outside the boundary for a period of six seconds. These are created by the level-editor ZeroEditor, placed by hand.

# World Regions
## .rgn
Text files defining named 3D regions either in a Box, Cylinder, or Sphere shape. Used for shadows/lighting, sound spaces, sound streaming, sound effects, command post capturing, vehicle spawning, AI visual ranges, damage regions, death regions, rumble effects, rainshadows, planar reflections, and minimap bounds. Each world layer can have their own rgn file. These are created by the level-editor ZeroEditor, placed by hand.

# World Terrain
## .ter
Chunked binary files defining terrain grid resolution, size, colors, textures, vertex heightmap, foliage layers, and an optional water layer. These are created and edited through the level-editor ZeroEditor.

## .ter.option
Text files containing parameters read when munging ter files to modify how the ter file is packed into the resulting lvl file, written by hand.

# Base World File
## .wld
Text files defining the base lgt, sky, and ter files for this world, as well as all named entities and their positions, rotations, and properties as a base layer (always loaded regardless of gamemode). These are created through the level-editor ZeroEditor, and can be edited by hand if done carefully.

# Layer World File
## .lyr
Text files defining the lgt file for this world layer, as well as all named entities in this layer and their positions, rotations, and properties. These are created through the level-editor ZeroEditor, and can be edited by hand if done carefully.

# World Layer Groups
## .grp
Text files listing each layer of a world and its number starting at zero. These are created through the level-editor ZeroEditor, and can be edited by hand if done carefully.

# World Layers and Gamemodes
## .ldx
Text files listing each layer of a world and its number starting at zero, as well as gamemodes that allow for grouping of layers to be loaded together. These are created through the level-editor ZeroEditor, and can be edited by hand if done carefully.

# World Layer Requirements
## .mrq
Text files listing required modtool files for a world layer to be packed into a lvl when munged. Their formatting is identical to req files. These are created through the level-editor ZeroEditor, and can be edited by hand.

# World Object Groups
## .obg
Text files listing objects and their placements in a group. Can be imported/exported in zeroeditor.exe. 

# Fonts
## .fff
Binary font files produced by FontEdit.exe used by all interfaces in the game. These can be edited in the FontEdit.exe program found in BF2_Modtools/ToolsFL/bin.

## .fff.option
Text files containing parameters read when munging font fff files. -texsize 128 is the only known parameter.

# Localization
## .cfg
Text files listing text property names and hexadecimal values of strings for a specific language (English, Spanish, French, German, Italian, Japanese, UK English). They are created by the localization tool MultiLanguageTool.exe found in BF2_Modtools/ToolsFL/bin, or edited by Marth8880's ZeroLocalizationTool: https://github.com/Gametoast/ZeroLocalizationTool. 

# Level files
## .req
Text files listing required modtool files by filename (without extensions) to be packed into lvl file(s) when munged.

## .lvl
Munged chunked binary files containing packed resources from source req file(s). These are what is read by the game to load resources (art assets, sounds, configurations).

### LVLExplorer
There is a program which allows users to view some contents of a lvl file called LVLExplorer, which can be found here: https://github.com/Ben1138/LVLExplorer.

### lvl-repack
There is a program that allows for repacking lvl files to reduce their filesize by SleepKiller/PrismaticFlower that can be found here: https://github.com/PrismaticFlower/lvl-repack.

### swbf-unmunge
There is an extremely useful tool that can extract assets from munged lvl files back to their source modtool files, with varying degrees of success. Useful for accidental deletion of source files, this tool by SleepKiller/PrismaticFlower can be found here: https://github.com/PrismaticFlower/swbf-unmunge.

### CustomLVL
There is a program that allows for independent munging of req files into lvl files regardless of naming called CustomLVL, which can be found here: https://github.com/Gametoast/CustomLVL.

# World Creation
## config.ini
Text files defining configuration options for the zeroeditor.exe level-editing program. Properties such as window size, window maximization, refresh rate, load last world, confirm exit, and using slow (but more accurate) collision.

## zeroeditor.exe
Executable program for level-editing worlds. This program allows for terrain creation and manipulation, object, region, path, light, hintnode, barrier, and boundary placement, as well as planning hubs and connection placement, and portals and sectors placment. It also allows for baking world lighting into the terrain colors, and toggling in-game terrain, foliage, and water. It also allows for creating, deleting, and editing world layers and gamemodes. Files loaded are wld files, with layers optionally loaded, and object groups and even terrain can be saved as obj model files. A patch with some UI improvements can be found at https://github.com/Gametoast/ZeroEditor-Updated-UI. A newer version of this editor was supplied by Psych0fred and can be found here: https://app.box.com/s/cicc2a1y2f6vjd6bosqt8w43i00wsznq.

## WorldEdit.exe
A more modern and updated zeroeditor replacement is WorldEdit by SleepKiller/PrismaticFlower. This WIP application has a number of unique features to make level creation easier for modders, though it does not yet work for ARM CPUs and some older or niche GPUs. It can be found here: https://github.com/PrismaticFlower/WorldEdit.

# World Stats
There is a program, ZeroWorldStats which can output information regarding object, region, and plan connection and hub counts, as well as Command Post names and spawn paths of a world layer written by Marth8880 that can be found here: https://github.com/Gametoast/ZeroWorldStats.

# Munging Files
## .bat
Text files containing bat scripts to be run in command prompt that contain platform switches for munging modtool files in specific ways for different platforms (PC, XBOX, PS2) by calling munging programs on them, copying munged lvl files to the game's installed Addon directory, and deleting munged files when a clean munge is desired.

## Modtools VisualMunge.exe
Executable program in each addon's BF2_Modtools/"data_..."/_BUILD folder that calls the selected bat script categories (Common, Sides, Worlds, Sound, Load, Shell, Localize, or Movies) to munge that addon's modtool files and copy the munged files to the game's installed Addon directory as a new addon, displaying a text log of any errors encountered while munging. There is a version of this program in the BF2_Modtools/data/_BUILD directory that copies files in the parent data directory to a newly created directory in BF2_Modtools to create a new data folder ("data_...") for a new addon where the user defines a three-letter sequence for their addon, an addon map name and description, and what gamemodes to initially create for this addon. This creates all required template files to create a new world addon.

## ZeroMunge
There is a newer more robust program called ZeroMunge meant to replace Modtools VisualMunge.exe that allows for more finely adjusting which munge bat scripts are called, written by Marth8880 that can be found here: https://github.com/Gametoast/ZeroMunge.

# Debugging
## .log
The animation munger, sound munger, and addme script munger all produce text log files denoting any errors produced while munging (invalid geometry, missing bones, missing wav sound files, invalid lua code). The programmer's build will also output a text BFront2.log file that will indicate error messages of varying severity. Severity 1 is informational, 2 is warning, 3 is severe and often causes crashing.

## BF2_Modtools.exe
This is a programmer's build/debugger of the game called BF2_modtools.exe that when placed in the game's GameData directory allows the user to hit ` on the keyboard to display a code console where predefined functions can be called to alter various game states, debug rendering, dump camera positions to a text CameraCoords.txt file, and manipulate world properties. It also produces a text log file of information including errors encountered while running.

# Miscellaneous
## Unofficial Patch 
There is an unofficial patch that contains a number of fixes and features that many modders and players deem necessary written by Zerted that can be found here: https://github.com/Gametoast/un-official-patch. This patch allows up to 5 custom eras per map, or 14 gamemodes (without Anakin's HD Menus Remaster mod, which extends this further) as well as notable additions such as script globals `__thisMapsCode__` and `__thisMapsMode__`, preview-movies for mod maps, a freecam, and a fakeconsole.

## Alternative Addon System
There is an alternative addon system for adding and registering mods with the game that can be found here: https://github.com/Gametoast/AltAddonSystem.

## HD Menus and Unoffical Patch Installer
There is a program that installs the unoffical patch 1.3 and improves the sizing and textures of several menu elements, as well as several in-game audio fixes and features such as AI hero units and installs unofficial patch 1.3 called SWBF2 Remastered by GT-Anakin, which can be found here: https://www.moddb.com/mods/star-wars-battlefront-ii-full-hd-interface/.

## Classic Collection Mod Patch
There is a patch for the Classic Collection edition of the game to restore mod functionality that may have been lost due to game system updates by Aspyr Studios. It can be found here: https://github.com/Gametoast/ClassicCollectionModPatch.

## Shaderpatch
An improved shader system fixing various high-resolution issues and providing a multitude of features can be found here: https://github.com/PrismaticFlower/shaderpatch. This project works by redirecting DirectX9 calls to DirectX11, and provides post-processing options as well as cloth rendering and softskin unit deformations on PC.

## Additional Tools
Additional modding programs and tools can be found here: https://github.com/Gametoast/Documentation/wiki/Tools-and-Programs.

# Documentation
There is a GitHub Wiki that contains online links to BF1 and BF2 documentation that is useful for modding that can be found here: https://github.com/Gametoast/Documentation/wiki.
