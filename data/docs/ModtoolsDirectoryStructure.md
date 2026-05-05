# BF2_Modtools Directories
This document explains the various directories of the Star Wars Battlefront 2 Modtools.
The following are directories found in the BF2_Modtools root directory, with heading sizes corresponding to hierarchy in the directory structure. A smaller heading indicates it is a child of the preceding larger heading folder.

Sections:
- Directory Visual Overview (lines 16-32)
- Assets Folder (lines 34-117)
- TEMPLATE Folder (lines 119-129)
- Space_Template Folder (lines 131-141)
- Data Folder (lines 143-144)
- Addon Data Folders (lines 146-261)
- ToolsFL Folder (lines 263-279)

---

# Visual Overview
```text
BF2_Modtools/
├── Assets/                 # Stock source assets (Animations, Shell, Sides, etc.)
├── Common/                 # Shared global sound and script configurations
├── data/                   # Addon data folder creation program, templates, addon munging/editing programs
├── data_.../               # Addon source data folders
│   ├── _BUILD/             # Munge scripts and logs
│   ├── _LVL_PC/            # Compiled .lvl output
│   └── [Assets]/           # Mod-specific MSH, ODF, LUA, etc.
├── Space_Template/         # Base files for space-map creation
├── Strings/english         # Installation and registry files for BF2_Modtools
├── Template/               # Base files for ground-map creation
├── ToolsFL/bin             # Munger and Editor executables
├── jedi side example.zip   # Example animations and sides folder
└── uninst.exe              # BF2_Modtools uninstaller
```

# Assets Folder
## Animations Folder
All stock animations are found here, separated into separate folders for the different categories. There are also three bat files:
*   `clean.bat`: Deletes logs and munged animations.
*   `munge.bat`: Munges every animation in all subfolders.
*   `munge_subdir.bat`: (Deprecated) Calls the aforementioned munge.bat.

### FirstPerson Folder
Animations used for animating the first person models, separated into distinct folders for the droideka, human, and sbdroid (super battle droid) units. Each subfolder contains at least a basepose.msh file containing the skeleton with two still frames (0-1) and a munge.bat for calling munge_animation.bat in the parent directory, providing the file list and output name which then calls zenasset.exe for initial munging, followed by binmunge for additional munging in BF2_Modtools/ToolsFL/bin. Additional msh files each add a unique animation to the compiled set.

### Prop Folder
Animations used for animating enveloped/vertex-weighted props, separated into distinct folders for each animated prop (doors, Jabba the Hutt, Death Star bridge, Rancor, Sarlaac Tentacle, and several more). Each subfolder contains at least a basepose.msh file containing the skeleton with two still frames (0-1) and a munge.bat for calling munge_animation.bat in the parent directory, providing the file list and output name which then calls zenasset.exe for initial munging, followed by binmunge for additional munging in BF2_Modtools/ToolsFL/bin. Additional msh files each add a unique animation to the compiled set.

### SoldierAddon Folder
Animations used for animating geometry addons fixed onto unit models. These are used for cis_inf_dooku_cape and imp_inf_vader_cape in BF1, but believed to be deprecated in favor of cloth simulation for BF2. That said, geometry addons are still feasible for modding custom units. Each subfolder contains at least a basepose.msh file containing the skeleton with two still frames (0-1) and a munge.bat for calling munge_animation.bat in the parent directory, providing the file list and output name which then calls zenasset.exe for initial munging, followed by binmunge for additional munging in BF2_Modtools/ToolsFL/bin. Additional msh files each add a unique animation to the compiled set.

### SoldierAnimationBank Folder
Animations used for animating units, every unit animation in the retail release is present here in folders separated by skeleton. Each subfolder contains at least a basepose.msh file containing the skeleton with two still frames (0-1) and a munge.bat for calling munge_animation.bat in the parent directory, providing the file list and output name which then calls zenasset.exe for initial munging, followed by binmunge for additional munging in BF2_Modtools/ToolsFL/bin. Additional msh files each add a unique animation to the compiled set.

### Vehicle
Animations used for animating vehicles, be they starfighters (referred to as flyers), tanks and speeders (referred to as hovers), and walkers. Each subfolder contains at least a basepose.msh file containing the skeleton with two still frames (0-1) and a munge.bat for calling munge_animation.bat in the parent directory, providing the file list and output name which then calls zenasset.exe for initial munging, followed by binmunge for additional munging in BF2_Modtools/ToolsFL/bin. Additional msh files each add a unique animation to the compiled set.

### UNUSED Folder
This folder simply contains a few unused msh animation files for the ewok, human, and human first person.

## Common Folder
Inside is a sound folder, containing the global.sfx file listing common/shared sound samples in the game shell (menus/interface) and the global.snd file defining audio buses, common sound configurations, and a default sound space configuration.

## Scripts Folder
This folder contains a three-character subfolder for each of the worlds, in which contains every mission script for that world with the exception of the PC subfolder, which contains scripts for the game shell (menus/interface) such as ifs_awardstats.lua, ifs_careerstats.lua, ifs_opt_controller_common.lua, ifs_opt_general.lua, ifs_opt_mp.lua, ifs_opt_mp_listtags.lua, ifs_personalstats.lua, ifs_teamstats.lua, and pctabs_options.lua.

## Shell Folder
The shell folder contains subfolders for various assets used in the game shell (menus/interface). It also contains a shell.req for requesting scripts, textures, and movie configuration files to be munged into a shell.lvl.

### Movies Folder
Contains a shell_subtitles.mcfg file for providing subtitle configurations to the training1 movie. It also has a PC subfolder containing several mlst files which list all the game shell and ingame movie paths to their bik movie files. A shell_movies.mcfg file is also present here, defining all movie property templates and all movie segment properties.

### Scripts Folder
Contains all lua scripts used by the game shell (menus/interface) as well as the Galactic Conquest mode interface. There is a PC subfolder containing a few additional PC-only interface screens.

### Textures Folder
Contains all game shell (menus/interface) textures, including logos, faction icons, titlebars, tabs, as well as all Galactic Conquest texture assets with a single tga.option file to apply -maps 1 (Disables mipmapping) to all textures in that folder when munged. It also contains a PC subfolder for logos in different languages, loading screen backgrounds, and icons for the game shell.

### Textures4 Folder
Contains textures used for game shell (menus/interface) icons exclusive to the PC version of the game. Also contains a single tga.option file to apply -maps 1 (Disables mipmapping) to all textures in that folder when munged, as well as a PC subfolder which contains only check_no.tga and check_yes.tga texture icons for the PC version of the game.

## Sides Folder
This folder contains a three-character subfolder for each side (team), with the exception of the Common subfolder containing assets shared amongst all the sides. Each side folder has at least a msh, munged, odf, and req subfolder inside them (except Common which is not munged into a lvl for itself therefore does not have a req file), and sometimes an effects folder as well. Each side subfolder also has at least one req file, listing the required assets to be munged into a single side lvl file as well as any sub-lvls inside the main lvl file for individual loading. Playable sides will also have a "...shell.req" file for requiring models and animations to be packed into a lvl for rendering inside the Galactic Conquest interface. The side subfolders here are ALL (Rebel Alliance team), CIS (CIS team), Common (shared amongst teams), DES (Jawa and Tusken Raider teams), EWK (Ewok team), GAM (Gamorrean Guard team), GAR (Naboo Guard and Jedi Temple Guard teams), GEO (Geonosian team), GUN (Gungan team), IMP (Empire team), JED (Jedi team), REP (Galactic Republic team), SNW (Wampa team), TUR (Turret team), and WOK (Wookiee team).

### Effects Folder
This side subfolder contains msh model files, msh.option files, tga textures, tga.option files, and fx files for particle effects (not to be confused with world fx files). Particle effects often use msh and nearly always tga files for effects such as the droideka shield and jetpack. All particle effects assets for this side will be here.

### MSH Folder
This side subfolder contains msh model files, msh.option files, tga textures, and tga.option files for this side. All art assets for the side will be here, as well as an optional PC subfolder containing art assets exclusive to the PC version of the game, sometimes overwriting models and textures in the parent directory when munged for the PC platform.

### Munged Folder
This side subfolder contains all munged animation files (anims, zaabin, zafbin) for each animation set used by units or vehicles in this side. Separate low resolution versions using a simpler skeleton for low resolution models are also present, named by appending lz to the filename.

### ODF Folder
This side subfolder contains all odf files used by this side, as well as combo files used for attack combos of units with melee weapons. All units, vehicles, weapons, and cloth objects in this side will have defining odf files here.

### REQ Folder
This side subfolder contains req files listing required assets for each sublvl to be packed separately into the parent side lvl file to allow for individual loading of class assets (Though this may cause duplicated assets among sublvls for classes sharing assets). They are typically (but not always) named after the unit or vehicle class their sublvl will contain. This folder may also contain an fpm subfolder which will have req files listing assets required for first person models to be munged into individual lvl files.

## Worlds Folder
This folder contains a three-character subfolder for each world. Each world folder has at least a msh, odf, and world1 folder, with optional effects (particle effects assets), munged (munged animations), as well as additional world folders (world2, world3, world4, ...) and an optional sky folder (sky configurations). If multiple "world%" folders are present, a sky folder (sky files) is likely also present for different sky configurations to be munged into separate lvl files.

### Effects Folder
This world subfolder contains msh model files, msh.option files, tga textures, tga.option files, and fx files for particle effects (not to be confused with world fx files). Particle effects often use msh and nearly always tga files for effects such as the dustwake, flyerspray, and walkerstomp effects. All particle effects assets for this world will be here or in a PC subfolder to overwrite assets in the parent directory when munging for the PC platform. This is also where water bumpmaps, normalmaps, and specularmask textures will be located if one of the child worlds has a water layer in it's terrain.

### MSH Folder
This world subfolder contains msh model files, msh.option files, tga textures, and tga.option files for this world. All art assets for the world will be here, as well as an optional PC subfolder containing art assets exclusive to the PC version of the game, sometimes overwriting models and textures in the parent directory when munged for the PC platform.

### Munged Folder
This world subfolder contains all munged animation files (anims, zaabin, zafbin) for each animation set used by animated props in this world (doors, enveloped/vertex-weighted props, bridges, etc).

### ODF Folder
This world subfolder contains all odf files used by this world. All props, destructible buildings, attachable or placeable lights, dust or fog effects, rumble effects, and cloth objects in this world will have defining odf files here.

### Sky Folder
This world subfolder contains several sky files for different sky configurations as well as a req file listing the individual sky sublvls. It will likely also have a REQ subfolder containing req files that will request for each sky file to be packed into it's own sublvl.

### World% Folder
These world subfolders, numbered starting at 1 (world1) contain all the world files used for each world. It typically at least contains bar (AI barriers), bnd (world boundary), fx (world effects), grp (world layer grouping), hnt (AI hintnodes), ldx (layer and gamemode layer-grouping), lgt (world lights), pln (AI Planning/Pathing/Connectivity Graph), pth (Catmull-Rom splines for spawning and entity following), rgn (world regions), sky (world sky configuration), ter (world terrain, present even when terrain is disabled), wld (base world layer), and req (world asset requirements) files, and likely additional world layer files (lyr, mrq, pth, hnt, lgt, rgn per layer).

# TEMPLATE Folder
This folder contains template assets which will be programmatically edited for a new addon world depending on what three-character name the user denotes for their world, and what gamemodes the user enables when using the Modtools VisualMunge.exe program in BF2_Modtools/data/_BUILD to create a new addon data folder.

## Addme Folder
This template subfolder contains an addme.lua and a mungeAddme.bat script which will both be programmatically edited to add the enabled gamemodes and map, and call for this worlds addme.lua to be munged, respectively.

## Common Folder
This template subfolder contains a mission.req file that lists required scripts to be packed into a mission.lvl file, and a sublvl section to be programmatically edited to add lvls for each enabled gamemode. It also has a mission subfolder containing req files for each of the enabled gamemodes, that will be similarly edited, and a scripts subfolder, which has a three-character wildcard `@#$` subfolder containing each possible gamemode mission script, the enabled ones being edited to use the three-character world sequence chosen by the user and everything then copied to the new addon data folder by the Modtools VisualMunge.exe program in BF2_Modtools/data/_BUILD.

## Worlds Folder
This template subfolder contains a three-character wildcard `@#$` subfolder which has two subfolders, _BUILD and world1 inside it. The _BUILD subfolder simply has a clean.bat and munge.bat for munging and cleaning (deleting) assets that will be programmatically edited to target the new addon world. The world1 subfolder has template world files (bar, pln, lgt, wld, etc) with a `@#$` filename that will be similarly edited upon using the Modtools VisualMunge.exe program in BF2_Modtools/data/_BUILD when creating a new addon data folder. It also includes the Yavin and Naboo sky dome models and textures, and two subfolders, modes and REQs. The modes folder has four different gamemode subfolders that contain world layer files for those gamemodes. The REQS folder simply has a `@#$`.req file that will be programmatically edited depending on the enabled gamemodes to include the requested layers.

# Space_Template Folder
This folder contains template assets for a space world which will be programmatically edited for a new addon world depending on what three-character name the user denotes for their world, and what gamemodes the user enables when using the Modtools VisualMunge.exe program in BF2_Modtools/data/_BUILD to create a new addon data folder.

## Addme Folder
This space_template subfolder contains an addme.lua and a mungeAddme.bat script which will both be programmatically edited to add the enabled gamemodes and map, and call for this worlds addme.lua to be munged, respectively.

## Common Folder
This space_template subfolder contains a mission.req file that lists required scripts to be packed into a mission.lvl file, and a sublvl section to be programmatically edited to add lvls for each enabled gamemode. It also has a mission subfolder containing req files for each of the enabled gamemodes, that will be similarly edited, and a scripts subfolder, which has a three-character wildcard `@#$` subfolder containing each possible gamemode mission script, the enabled ones being edited to use the three-character world sequence chosen by the user and everything then copied to the new addon data folder by the Modtools VisualMunge.exe program in BF2_Modtools/data/_BUILD.

## Worlds Folder
This space_template subfolder contains a three-character wildcard `@#$` subfolder which has two subfolders, _BUILD and world1 inside it. The _BUILD subfolder simply has a clean.bat and munge.bat for munging and cleaning (deleting) assets that will be programmatically edited to target the new addon world. The world1 subfolder has template world files (bar, pln, lgt, wld, etc) with a `@#$` filename that will be similarly edited upon using the Modtools VisualMunge.exe program in BF2_Modtools/data/_BUILD when creating a new addon data folder. It also includes the Yavin and Naboo sky dome models and textures, and two subfolders, modes and REQs. The modes folder has four different gamemode subfolders that contain world layer files for those gamemodes. The REQS folder simply has a `@#$`.req file that will be programmatically edited depending on the enabled gamemodes to include the requested layers.

# Data Folder
The data folder contains default files to be copied to new addon data folders, such as the level-editing program zeroeditor.exe, several munge bat scripts, an editlocalize.bat script which runs the localization program MultiLanguageTool.exe, and subfolders _BUILD, addme, Animations, Common, Editor, Sides, and Sound. The subfolders simply contain the default directory structures, munge bat scripts, and common assets, that each addon data folder should have.

# Addon Data Folders (data_...)
This folder is what contains all assets required to create an addon. It is named "data_..." where the ellipses represent the three-character world sequence the user chose during addon data folder creation with the ModTools VisualMunge.exe program in BF2_Modtools/data/_BUILD. The directory structure of each addon data folder is the same as the data folder, with the same munge bat scripts and common assets, but with the assets in the subfolders edited to replace the three-character wildcard (`@#$`) with the three-character world sequence chosen by the user, and with only the enabled gamemode mission scripts and world layer files included.

## _BUILD Folder
This folder contains all bat scripts necessary for calling the munging programs located in BF2_Modtools/ToolsFL/bin on the addon's assets as well as a Modtools VisualMunge.exe version (not to be confused with the version in BF2_Modtools/data) that targets this specific addon data folder. It also has several subfolders, each containing munge bats responsible for munging files in their respective addon data folder directories (Common, Load, Shell, Sides, Sound, and Worlds), as well as log files for listing warnings and errors encountered while munging, and a MUNGED subfolder into which munged files and compiled lvl files are output for their respective directory.

## _LVL_PC Folder
This folder contains a copy of all the munged and compiled lvl files for this addon data folder, to be copied to the game's installed directory (Star Wars Battlefront II/GameData/Addon/...) with the ellipses in the path representing the three-character addon sequence upon each munge ran through the Modtools VisualMunge.exe program located in the addon data folder's _BUILD subfolder.

## Addme Folder
This folder contains addme.lua which is responsible for adding the addon map and enabled gamemodes to the Instant Action map selection screen, as well as add the addon's mission scripts and load the addon's core.lvl for it's localization strings. It also has a scriptmunge.log for warnings and errors encountered while munging, a mungeAddme.bat which calls the scriptmunge.exe program in BF2_Modtools/ToolsFL/bin to munge the addon's addme.lua, and a munged folder which simply contains the munged script as a chunked binary addme.script file to be copied into the games Addon/.../ folder where the ellipses represents the addon's three-character sequence.

## Animations Folder
This folder contains a SoldierAnimationBank subfolder which, despite it's name, is where addon msh animations of any kind can be placed to be munged. A subfolder into SoldierAnimationBank can be made for each custom animation set, into which at least a basepose.msh and munge.bat can be present with optional additional msh animation files can be added to add unique animations to the compiled munged animation files (anims, zaabin, zafbin). The munge bat script typically outputs the munged animations to the data_.../Worlds/.../Munged directory, where the ellipses represent the three-character addon sequence.

## Common Folder
This folder contains assets that are likely to be shared across worlds in the addon data folder. It has several subfolders, as well as several req files: common.req (lists required game shell/interface scripts and textures), core.req (lists required localization cfg files for English, Spanish, Italian, French, German, and UK_English), core-japanese.req (lists required japanese cfg localization file, as well as unique fonts, textures, and shaders for Japan), ingame.req (lists required common assets such as scripts, textures, odf files, animation banks, models, and HUD configurations), inshell.req (lists required game shell/interface ingame movie configs, human animation bank, and a few particle effect models and textures), and mission.req (lists required mission scripts for the addon, and sublvls for each addon gamemode and era).

### Config Folder
This subfolder of Common simply contains SoldierAnimation.sanm, a file defining blending times and looping behavior for soldier animations. It is undetermined if this file can be edited and result in changed in-game behavior.

### Effects Folder
This subfolder of Common contains particle effects assets (msh, msh.option, tga, tga.option, fx files) commonly shared by addon worlds, as well as a PC subfolder for assets specific to the PC platform of the game.

### Fonts Folder
This subfolder of Common contains the font fff and fff.option files used by the game shell/interface and in-game HUD.

### HUD Folder
This subfolder of Common contains hud files that determine what elements appear on the player's HUD. There are 1playerhud.hud, 2playerhud.hud, 3playerhud.hud, and 4playerhud.hud files, each serving as HUD configurations for up to four players playing at once on the console versions of the game (although not initially supported, mods can allow for local multiplayer splitscreen for the PC version as well). There's also a hudtransforms.hud which defines how each weapon mesh is displayed and positioned/rotated onto each player's HUD. It also has a PC subfolder in which alone resides a 1playerhud.hud file.

### Interface Folder
This subfolder of Common contains game shell (menus/interface) texture assets for icons and images. There is also a PC subfolder for textures specific to the PC version of the game.

### Localize Folder
This subfolder of Common contains the localization cfg files for various translations of strings for the addon. This includes strings for the map name and description, as well as any new named entities in the addon world. It also has a PC subfolder for localization cfg files specific to the PC version of the game.

### Mission Folder
This subfolder of Common contains req files for each sublvl of the compiled and munged mission.lvl, with each req listing the respective mission script for each gamemode and era.

### MSHS Folder
This subfolder of Common msh files and textures that are commonly shared among addon worlds, such as the command post models, health and ammo droid models, a few weapon models, and HUD models/icons.

### Munged Folder
This subfolder of Common contains munged animation sets for human_0, human_1, human_2, human_3, human_4, humanfp, and humanlz (anim, zaabin, zafbin files) that are commonly shared among addon worlds.

### ODFS Folder
This subfolder of Common contains odf files that are commonly shared among addon worlds, such as the command posts, buildable health and ammo droids, a few weapons, powerup items dropped on unit deaths, flag items for capture the flag objectives, and notably com_snd_amb_static and com_snd_amb_streaming for sound props, com_inf_default for odf class inheritance, and com_item_vehicle_spawn for spawning all classes of vehicles.

### REQ Folder
This subfolder of Common contains a subfolder fpm which then has several req files for commonly shared first person models to be munged into lvl files.

### Scripts Folder
This subfolder of Common is where all addon lua scripts reside. All in-game scripts such as objective scripts, character select shell/interface scripts, and notably the setup_teams.lua script, used in addon mission scripts. Inside this folder is a subfolder "..." where the ellipses represents the three-character addon sequence. That subfolder contains the actual mission scripts that are run when launching the addon map. They are each prefixed with the three-character sequence, a single character denoting the era, followed by an underscore and the gamemode (e.g. XYZc_con for Clone Wars era, Conquest gamemode, or XYZg_ctf for Galactic Civil War era, Capture the Flag gamemode). Sometimes modders will also place utility scripts here or in the parent directory that are referenced and loaded in the mission lua script.

### Shaders Folder
This subfolder of Common contains a subfolder PC in which resides several xml, vsh, and h files regarding the games shaders. There's also a visual studio pcshaders.sln file, and shaders.vcproj file.

## Editor Folder
### Config Folder
This subfolder of Editor contains configuration files for the level-editing program zeroeditor.exe. It contains several subfolders for initialization configurations and assets for visual features of the editor.

### Interface Folder
This subfolder of Editor contains several tga textures used by the zeroeditor.exe program for the interface, as well as binary bmf font files used by zeroeditor.

## Load Folder
This folder contains tga textures that will be munged into loading screens for addon worlds. It will typically contain a texture, loadscreen.tga, and a req which lists it as a requirement. Whatever the req is named is what the resulting filename of the lvl will be.

## Shell Folder
This folder can contain movies, scripts, and art assets such as models and textures, each with their own subfolder. It will have a shell.req file listing what assets are required for the resulting shell.lvl. By convention the shell.lvl will be loaded while in the game shell (menu/interface). The entire Shell folder is entirely optional and up to modders to implement.

## Sides Folder
This folder contains subfolders for each side (team) to be munged with the addon. Side subfolders will contain at least a req file named after the side, listing the required assets. It may contain effects, msh, munged, odf, and req folders depending on what the side will encompass. Some modders separate odf and fx files into one side, with art assets like msh and tga files in another in order to reduce duplication of assets among sublvls. It should be noted that in order for a custom side to be munged, it must have a corresponding munging folder inside the addon data folder's _BUILD/Sides folder, which in turn contains a munge bat script containing `@call ..\munge_side.bat SideNameHere %1` where SideNameHere represents the name of the side's folder and req file. It should also be noted that a Common side is often present which contains art assets, animations, and odf classes which other sides may require and pull from.

## Sound Folder
This folder contains several subfolders that separate sound files by category.

### CW Folder
This folder contains sounds (mostly) unique to the Clone Wars era. It has an effects subfolder that contains wav file samples to be used as sound effects and held in game memory (a notoriously limited memory pool). It also has a streams subfolder that contains wav files to be used as sound streams and streamed in from disk during playback, thus avoiding counting towards the limited sound memory pool. The CW folder also contains text files defining sound properties and configurations, such as snd files for vehicle and unit sounds. The following snd files can be found here: cis_fly_droidfighter, cis_fly_grievousfighter, cis_fly_gunship, cis_fly_maf, cis_fly_tridroidfighter, cis_hover_aat, cis_hover_stap, cis_tread_hailfire, cis_tread_snailtank, cis_unit, cis_unit_space, cis_walk_spider, cw_foley_dirt_config, cw_foley_grass_config, cw_foley_metal_config, cw_foley_snow_config, cw_foley_stone_config, cw_foley_waterdeep_config, cw_foley_watershallow_config, cw_foley_wood_config, rep_fly_anakinfighter, rep_fly_arc170, rep_fly_gunship, rep_fly_jedifighter, rep_fly_vwing, rep_hover_combatspeeder, rep_hover_fightertank, rep_hover_speederbike, rep_unit, rep_unit_space, rep_walk_atrt, and rep_walk_atte.

### GCW Folder
This folder contains sounds (mostly) unique to the Galactic Civil War era. It has an effects subfolder that contains wav file samples to be used as sound effects and held in game memory (a notoriously limited memory pool). It also has a streams subfolder that contains wav files to be used as sound streams and streamed in from disk during playback, thus avoiding counting towards the limited sound memory pool. The GCW folder also contains text files defining sound properties and configurations, such as snd files for vehicle and unit sounds. The following snd files can be found here: all_fly_awing, all_fly_gunship, all_fly_snowspeeder, all_fly_xwing, all_fly_ywing, all_hover_combatspeeder, all_hover_skiff, all_unit, all_unit_space, gcw_foley_dirt_config, gcw_foley_grass_config, gcw_foley_metal_config, gcw_foley_snow_config, gcw_foley_stone_config, gcw_foley_waterdeep_config, gcw_foley_watershallow_config, gcw_foley_wood_config, imp_fly_tie, imp_fly_tiebomber, imp_fly_trooptrans, imp_hover_fightertank, imp_hover_speederbike, imp_unit, imp_unit_space, imp_walk_atat, imp_walk_atboth, imp_walk_atst, and wok_vo.

### Global Folder
This folder contains sounds shared between the eras. It has an effects subfolder that contains wav file samples to be used as sound effects and held in game memory (a notoriously limited memory pool). It also has a streams subfolder that contains wav files to be used as sound streams and streamed in from disk during playback, thus avoiding counting towards the limited sound memory pool. The global folder has the following snd files that can be found here: wok_unit_vo, wok_foley_wood_config, wok_foley_grass_config, wok_foley_dirt_config, wok_foley_waterdeep_config, wok_foley_watershallow_config, wok_foley_metal_config, wok_foley_snow_config, wok_foley_stone_config, small_foley_wood_config, small_foley_grass_config, small_foley_dirt_config, small_foley_waterdeep_config, small_foley_metal_config, small_foley_stone_config, rep_unit_vo, imp_unit_vo, gun_unit_vo, global_world, global_vo, gar_unit, gam_unit_vo, exp_obj_water, exp_obj_large, exp_obj_huge, exp_obj, des_unit_vo, cis_unit_vo, and all_unit_vo. It also has German and French variants of the voice overs. The global folder also has several stream stm files for voice overs such as the following: yav_objective_vo_slow, wok_vo_quick, wok_unit_vo_slow, uta_objective_vo_slow, tan_objective_vo_slow, spa1_objective_vo_slow, rep_unit_vo_slow, rep_unit_vo_quick, pol_objective_vo_slow, nab_objective_vo_slow, myg_objective_vo_slow, mus_objective_vo_slow, KAS_objective_vo_slow, kam_objective_vo_slow, imp_unit_vo_slow, imp_unit_vo_quick, hot_objective_vo_slow, gun_unit_vo_slow, global_vo_slow, global_vo_quick, geo_objective_vo_slow, gcw_music, gam_unit_vo_slow, fel_objective_vo_slow, des_unit_vo_slow, dea_objective_vo_slow, cw_music, cor_objective_vo_slow, cis_unit_vo_slow, cis_unit_vo_quick, all_unit_vo_slow, all_unit_vo_quick, wok_unit_vo, wok_foley_wood_config, wok_foley_watershallow_config, wok_foley_waterdeep_config, wok_foley_stone_config, wok_foley_metal_config, wok_foley_snow_config, wok_foley_grass_config, wok_foley_dirt_config, small_foley_wood_config, small_foley_grass_config, small_foley_dirt_config, small_foley_waterdeep_config, small_foley_metal_config, small_foley_stone_config, rep_unit_vo, imp_unit_vo, gun_unit_vo, global_world, global_vo, gar_unit, gam_unit_vo, exp_obj_water, exp_obj_large, exp_obj_huge, exp_obj, des_unit_vo, cis_unit_vo, and all_unit_vo. It also has a global.req file for compiling a global.lvl containing unit and objective voice over streams, and music streams.

### Shell Folder
This folder contains sounds played in the game shell (menus/interface). It has an effects subfolder that contains wav file samples to be used as sound effects and held in game memory (a notoriously limited memory pool). It also has a streams subfolder that contains wav files to be used as sound streams and streamed in from disk during playback, thus avoiding counting towards the limited sound memory pool. It has the following stream stm files: shell_music, shell_ui, and shell_vo. It also has French, German, Italian, Japanese, Spanish, and UK_English versions of these streams. Also present are two snd config files: shell and shell_vo. The shell folder also contains a shell.req file for compiling a shell.lvl containing shell voice overs, music, and UI sounds.

### Worlds Folder
This folder contains several subfolders for each world. Modders will typically add their own addon world sound folder here. These world folders will have an effects folder if they use custom sound effects containing audio wav files, and nearly always a streams folder for custom sound streams containing audio wav files to be streamed from disk for ambient environmental sounds.

## Worlds Folder
This folder contains a three-character addon sequence subfolder containing assets for the addon world. Inside are optional Effects, Munged, and Sky folders, and typically have MSH, ODF, and world subfolders, numbered starting at 1 (world1) containing unique assets for each addon world.

### Effects Folder
This addon world subfolder contains:
*   `.msh` and `.msh.option` files (Models)
*   `.tga` and `.tga.option` files (Textures)
*   `.fx` files (Particle effects, not world FX)

Common effects include `dustwake`, `flyerspray`, and `walkerstomp`. This is also where water-related textures (`bumpmaps`, `normalmaps`, `specularmask`) are located.

### MSH Folder
This addon world subfolder contains msh model files, msh.option files, tga textures, and tga.option files for these addon world(s). All art assets for the addon world(s) will be here, as well as an optional PC subfolder containing art assets exclusive to the PC version of the game, sometimes overwriting models and textures in the parent directory when munged for the PC platform.

### Munged Folder
This addon world subfolder contains all munged animation files (anims, zaabin, zafbin) for each animation set used by animated props in these addon world(s) (doors, enveloped/vertex-weighted props, bridges, etc).

### ODF Folder
This addon world subfolder contains all odf files used by these addon world(s). All props, destructible buildings, attachable or placeable lights, dust or fog effects, rumble effects, and cloth objects in this world will have defining odf files here.

### Sky Folder
This addon world subfolder contains several sky files for different sky configurations as well as a req file listing the individual sky sublvls. It will likely also have a REQ subfolder containing req files that will request for each sky file to be packed into it's own sublvl.

### World% Folder
These addon world subfolders, numbered starting at 1 (world1) contain all the world files used for each addon world. It typically at least contains bar (AI barriers), bnd (world boundary), fx (world effects), grp (world layer grouping), hnt (AI hintnodes), ldx (layer and gamemode layer-grouping), lgt (world lights), pln (AI Planning/Pathing/Connectivity Graph), pth (Catmull-Rom splines for spawning and entity following), rgn (world regions), sky (world sky configuration), ter (world terrain, present even when terrain is disabled), wld (base world layer), and req (world asset requirements) files, and likely additional world layer files (lyr, mrq, pth, hnt, lgt, rgn per layer).

# ToolsFL
## Bin Folder
This folder contains the executables responsible for Modtools functionality.

**Primary Mungers:**
`BinMunge.exe`, `ConfigMunge.exe`, `FontMunge.exe`, `LocalizeMunge.exe`, `MovieMunge.exe`, `OdfMunge.exe`, `PathMunge.exe`, `PathPlanningMunge.exe`, `pc_ModelMunge.exe`, `pc_ShaderMunge.exe`, `pc_TextureMunge.exe`, `ScriptMunge.exe`, `SoundFLMunge.exe`, `TerrainMunge.exe`, `WorldMunge.exe`, `ZenAsset.exe`.

**Editors:**
*   `FontEdit.exe`: Create/edit `.fff` font files.
*   `MultiLanguageTool.exe`: Edit localization `.cfg` files.
*   `ParticleEditor.exe`: Edit particle effect `.fx` files.

**Utilities:**
*   `LevelPack.exe`: Packing `.lvl` chunks.
*   `DSManager.exe`: Dedicated server manager.
*   `luac.exe`: Lua 5.0.2 compiler.
*   `pc_ShaderCompiler.exe`, `Hash.exe`, `PatchMaker.exe`.
