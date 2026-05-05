# Game Crashing
This document explains errors the game may encounter that may or may not cause crashes and the common causes.

Sections:
- Common Crashing Causes (lines 11-15)
- Logging (lines 17-274)
- Rare Crashing Causes (lines 276-277)

---

# Most Common Crashes
The most common crash to desktop (CTD) causes are animation-related.

## Missing Resource
Beyond animations, missing resources such as weapon, unit, ordnance, or inherited classes may causes CTDs.

# Logging
Some information is printed by the game into the BFront2.log when the programmers' build/debugger is executed. This includes error messages of varying severity. Message Severity 1 and 2 errors rarely cause crashing, while Message Severity 3 errors may cause CTDs.

## Common Logs
The following errors are severity 3 errors that **will** likely result in a game crash:
Running out of addressable memory (4GB limit for 32-bit application, textures the most likely culprit).
```
Message Severity: 3
C:\Battlefront2\main\RedEngineFL\Memory\RedMemory.cpp(538)
Allocating -1895825408 bytes failed - no free blocks left in Heap 5 (Runtime)
```

"Not Found" error messages typically indicate a missing class, commonly an inherited class ODF from `Sides/Common`.
```
Message Severity: 3
.\Source\Ordnance.cpp(424)
Ordnance base class "com_weap_veh_fly_recoilless_ord" not found
```

"Animmap" error messages are commonly caused by a missing `.combo` or munged animation file (`.anims`, `.zaafbin`, or `.zaabin`).
```
Message Severity: 3
C:\Battlefront2\main\Battlefront2\Source\Weapon.cpp(96)
Weapon failed to find animmap obiwan_melee 
```

"Format" error messages are commonly caused by incorrect `.tga.option` format parameters, or by leaving RLE compression on when exporting `.tga` textures.
```
Message Severity: 3
C:\Battlefront2\main\RedEngineFL\Graphics\PC\Shaders\pcTerrainShader.cpp(180)
pcTerrainShader: detail texture expects L8 format! 
```

"Unable to find level chunk" error messages are most commonly caused by munging errors preventing resources from being packed into resulting lvl files. This may also sometimes (if using variables for layer names for example) occur if an empty string is included when trying to reference a sub-lvl, e.g., `ReadDataFile("dc:ABC\ABC.lvl", emptyStringVariable)`.
```
Message Severity: 3
.\Source\LoadUtil.cpp(829)
Unable to find level chunk AL1_CW-Assault in C:\Program Files\LucasArts\Star Wars Battlefront II\GameData\AddOn\AL1\Data\_lvl_pc\AL1\AL1.lvl

Message Severity: 3
.\Source\LoadUtil.cpp(1019)
Unable to find level chunk in dc:AL1\AL1.lvl 
```

"Animation Bank" error messages are produced when too many animation banks are loaded simultaneously.
```
Message Severity: 3
.\Source\SoldierAnimatorClass.cpp(1412)
Out of space for soldier animation banks (max 18) 
```

"Can't find soldier animation" error messages indicate animations referenced from `.combo` files are missing.
```
Message Severity: 3
.\Source\SoldierAnimatorClass.cpp(1881)
Can't find soldier animation human_sabre_stand_useforce(_upper)
```

"Could not find ODF" error messages are caused by missing `.odf` files:
```
Message Severity: 3
.\Source\LoadUtil.cpp(1172)
Could not find odf "tur_weap_built_gunturret"! 
```

"Pebble" error messages often indicate invalid `.sky` or `.fx` files. Ensure only valid definitions are present, formatted correctly (no missing brackets, etc). 
```
Message Severity: 3
..\PebbleFL\Common\PblConfig.h(71)
PblConfig: Data 63cc538f expected string
m_auiArgs[i] >= m_uiNumArgs*4 && m_auiArgs[i] < CONFIG_MAX_DATA_ARGS*4
```

"String pool" error messages indicate too many named objects are loaded. Only world objects that **must** be named to be referenced via lua scripting should have name properties. All other objects can have empty strings for names to preserve string pool memory, which is a memory pool that cannot be set/raised.
```
Message Severity: 3
C:\Battlefront2\main\Battlefront2\Source\StringDB.cpp(54)
String pool is full: 32768 pool is not big enough!
```

"Concatenate" error messages typically indicate a nil string variable was input into print().
```
Message Severity: 3
C:\Battlefront2\main\Battlefront2\Source\LuaHelper.cpp(312)
CallProc failed: (none):0: attempt to concatenate field `?' (a userdata value)
stack traceback:
	(none): in function <(none):99>
```

## Memory Pools
Memory pool errors are output if they need to be raised. The game will only raise some pools dynamically at mission start, others must have their pool counts set inside the mission script's `ScriptInit`. Such error logs look like this:
```
Message Severity: 2
C:\Battlefront2\main\RedEngineFL\Memory\RedMemoryPool.cpp(170)
Memory pool "<PoolName>" is full; raise count to at least <int>
```
Resolve them by taking the highest number you see requested, then multiplying by 1.15 for wiggle-room.

## Debug Information
The following is an example of debug info dumped by the debugger that can be safely ignored:
```
Opened logfile BFront2.log  2007-07-25 2030
ingame stream    movies\crawl.mvs
ifs_legal.Exit

Message Severity: 2
.\Source\GameMovie.cpp(399)
Unable to find open movie segment shell_main

ifs_saveop_DoOps     LoadFileList
ifs_saveop_DoOps     LoadFileList
ifs_saveop_DoOps     LoadProfile
ifs_saveop_DoOps     LoadProfile
num, Selection =    1    table: 03CA118C
+++mission modes changed! ifs_mspc_MapList_layout.SelectedIdx =    1
EraSelection.subst =     c    era_c
EraSelection.subst =     g    era_g
play movie    AB1         200    ,    300         510    x    400

Message Severity: 2
.\Source\GameMovie.cpp(399)
Unable to find open movie segment AB10.000000ly

+++mission modes changed! ifs_mspc_MapList_layout.SelectedIdx =    22
EraSelection.subst =     c    era_c
EraSelection.subst =     g    era_g
+++mission modes changed! ifs_mspc_MapList_layout.SelectedIdx =    44
EraSelection.subst =     g    era_g
EraSelection.subst =     g    era_g
num, Selection =    1    table: 03CA118C
+++mission modes changed! ifs_mspc_MapList_layout.SelectedIdx =    34
EraSelection.subst =     c    era_c
EraSelection.subst =     g    era_g
play movie    AB1         200    ,    300         510    x    400

EraSelection.subst =     c    era_c
EraSelection.subst =     g    era_g
num, Selection =    1    table: 03CA118C
EraSelection.subst =     c    era_c
EraSelection.subst =     g    era_g
this.CurButton =    nil
cur_button =    nil
+++ DoubleClicked 
bEra_CloneWar =     1     bEra_Galactic =     1
clonewar_visable =     true     galactic_visable =     true
Adding map:     NPTc_con     idx:     1
Adding map:     NPTc_1flag     idx:     2
Adding map:     NPTc_bf1     idx:     3
Adding map:     NPTg_con     idx:     4
Adding map:     NPTg_1flag     idx:     5
Adding map:     NPTg_bf1     idx:     6
play movie    AB1         200    ,    300         510    x    400

this.CurButton =    Launch
cur_button =    nil
```

These messages are leftovers from the console versions and can be ignored:
```
Message Severity: 2
.\Source\HUDElementBitmap.cpp(380)
HUD BitmapElement unable to find texture hud_target_hint_offscreen

Message Severity: 2
.\Source\HUDElementBitmap.cpp(380)
HUD BitmapElement unable to find texture btn_directional_pad_LR
```

Any error message with `InVehicle` in it can also be safely ignored:
```
Message Severity: 2
.\Source\VOHelper.cpp(183)
VOSound (<VoiceOverSoundProperty>): unknown modifier "InVehicle"
```

These error messages were present upon the retail release of the game and can be ignored:
```
Message Severity: 2
.\Source\EntityGeometry.cpp(1065)
Entity "com_weap_inf_remotedroid_ord" unknown building collision "p_buildingsphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1073)
Entity "com_weap_inf_remotedroid_ord" unknown vehicle collision "p_buildingsphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1089)
Entity "com_weap_inf_remotedroid_ord" unknown ordnance collision "p_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1081)
Entity "com_weap_inf_remotedroid_ord" unknown soldier collision "p_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1058)
Entity "com_weap_veh_guided_rocket_ord" unknown terrain collision "p_front_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1073)
Entity "com_weap_veh_guided_rocket_ord" unknown vehicle collision "p_front_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1065)
Entity "com_weap_veh_guided_rocket_ord" unknown building collision "p_front_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1051)
Entity "com_weap_veh_guided_rocket_ord" unknown targetable collision "CollisionMesh"

Message Severity: 2
.\Source\EntityGeometry.cpp(1058)
Entity "com_weap_award_rocket_launcher_" unknown terrain collision "p_front_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1073)
Entity "com_weap_award_rocket_launcher_" unknown vehicle collision "p_front_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1065)
Entity "com_weap_award_rocket_launcher_" unknown building collision "p_front_sphere"

Message Severity: 2
.\Source\EntityGeometry.cpp(1051)
Entity "com_weap_award_rocket_launcher_" unknown targetable collision "CollisionMesh"
```

These are common non-critical errors that will not cause CTDs:
```
Message Severity: 2
.\Source\FLEffect.cpp(214)
FLEffect::Read: duplicate effect class name (5f518933)!

Message Severity: 2
.\Source\SkyManager.cpp(122)
Skyfile FarSceneRange is in old format

Message Severity: 2
C:\Battlefront2\main\Battlefront2\Source\EntitySoldier.cpp(10471)
Soldier <className> has geometry collision

Message Severity: 2
C:\Battlefront2\main\RedEngineFL\Graphics\PC\pcRedTexture.cpp(553)
Texture '<textureName>' [<hexValue>] uses <size> MB
```

"Asteroid" related error messages indicate either the Asteroid memory pool wasn't set or missing asteroid `.odf` files.
```
Message Severity: 2
C:\Battlefront2\main\Battlefront2\Source\Asteroid.cpp(481)
Could not build asteroid
```

"ALL YOUR MODEL ARE BELONG TO US" error messages tend to be related to a missing `GeometryName` property in a prop's `.odf` file (underneath the `[properties]` line, not above which is only for zeroeditor).
```
Message Severity: 3
C:\Battlefront2\main\Battlefront2\Source\EntityProp.cpp(921)
Prop "<propName>" not built: "ALL YOUR MODEL ARE BELONG TO US."
```

# Rare Crashes
Maps that feature a large number of bumpmapped-entities to be rendered simultaneously can causes error messages and sometimes CTDs. Loading more than a single terrain file with a water layer can also sometimes cause CTDs, usually triggered when moving the camera quickly from side-to-side or directly up or down.
