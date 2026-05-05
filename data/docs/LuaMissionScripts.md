# Mission Scripting
This document explains mission scripting for Star Wars Battlefront 2.

Sections:
- Mission Scripting Overview (lines 18-19)
- Mission Script Conventions (lines 21-22)
- Mission Globals (lines 24-36)
- ScriptPreInit Function (lines 38-39)
- ScriptInit Function (lines 41-42)
- ScriptPostLoad Function (lines 44-45)
- Utility Scripts (lines 47-54)
- Space Mission Scripts (lines 56-57)
- Mission Creation Guide (lines 59-415)
- Space Mission Creation Guide (lines 417-506)

---

# Overview
"Missions" are gameplay scripts that define the gamemode, era, and map to be played. Each selectable gamemode/era for each map must have it's own mission script.

# Conventions
Mission scripts are what runs for each selected map, gamemode, and era. They start by importing required scripts via ScriptCB_DoFile calls, typically at least ScriptCB_DoFile("setup_teams") is included for setting up the teams. Next, globals are defined, ScriptPostLoad is defined as a function to be run after asset loading, and a ScriptInit function is defined for asset loading.

## Globals
Globals are used to identify teams and roles. While `ATT` and `DEF` are standard for attacker/defender logic, faction-specific globals (like `REP` or `CIS`) are used for readability. These are defined before any functions and after importing any required scripts.

| Constant | Description | Value (Typical) |
| :--- | :--- | :--- |
| `ATT` | Attacking team identifier (Required, always 1). | `1` |
| `DEF` | Defending team identifier (Required, always 2). | `2` |
| `ALL` | Alliance team index. | `0 - 9` |
| `IMP` | Empire team index. | `0 - 9` |
| `REP` | Republic team index. | `0 - 9` |
| `CIS` | CIS team index. | `0 - 9` |

*Note: Additional team indices can be assigned to non-playable teams, such as local factions.*

## ScriptPreInit
This function, if defined, runs before ScriptInit and can was typically used to allocate memory for the PS2 version of the game before loading assets in ScriptInit, or to simply call `SetWorldExtents(value)` for space missions since their levels tend to be large.

## ScriptInit
This function which must always be defined in a mission script is responsible for loading assets and setting world configurations such as memory pools, sounds and music properties, camera shots, adding bird and fish entities, adjusting AI behavior, and importantly, setting up team classes, unit counts, and reinforcement counts.

## ScriptPostLoad
This required function runs after ScriptInit, to complete tasks pertaining to loaded world properties and classes. It is primarily responsible for setting up mission objectives which in turn determine victory or defeat conditions.

## Utility Scripts
Battlefront 2 uses several external scripts to handle complex logic outside the main mission file. This modular approach keeps mission scripts cleaner and allows for shared logic across multiple maps.

*   **`setup_teams.lua`**: Crucial for defining team properties, available classes, and faction-specific sounds.
*   **Objective Scripts**: Handle the logic for different gamemodes like `ObjectiveConquest` or `ObjectiveCTF`.
*   **UI/Shell Scripts**: Manage spawn selection screens and mid-game interfaces.

Modders are encouraged to create their own utility scripts for custom features (e.g., hero spawning logic or side-objectives) and include them using `ScriptCB_DoFile`.

## Space Missions
Space missions tend to define more functions than usual due to a large amount of tasks to be run on world objects and callbacks to setup, such as Critical Capital Ship Systems, linked shields amongst objects, and linked turrets to Frigates and AutoDefense Mainframes. Note that the stock LinkedDestroyables.lua script incorrectly deducts points from a player if they repair an *internal* critical system and another player later destroys the linked *external* critical system. To fix this, the following modification to LinkedDestroyables.lua can be made, specifically by adding the following line to the Init function inside the LinkedDestroyables table after line 38: `SetProperty(objectName, "Team", 0)`.

# Mission Creation Guide
Missions are Lua scripts defining gameplay parameters for specific combinations of maps, eras, and modes. At a minimum, team globals and two functions: ScriptInit, ScriptPostLoad must be defined.

### Stock Game Modes
| Extension | Mode | Objective Script |
| :--- | :--- | :--- |
| `_con` | Conquest | `ObjectiveConquest` |
| `_ctf` | 2-Flag CTF | `ObjectiveCTF` |
| `_1flag` | 1-Flag CTF | `ObjectiveOneFlagCTF` |
| `_eli` | Hero Assault | `ObjectiveTDM` |
| `_xl` | XL | `ObjectiveTDM` |
| `_c` | Campaign | Multiple |

## 1. Conquest Mission Script (The Base Template)

### Imports & Globals
```lua
ScriptCB_DoFile("ObjectiveConquest") -- Objective logic for Conquest gamemode
ScriptCB_DoFile("setup_teams") -- Table setup for playable teams

-- Role Identifier
ATT = 1
DEF = 2

-- Team index
REP = ATT
CIS = DEF

-- For GCW era:
-- IMP = ATT
-- ALL = DEF
```

### `ScriptPostLoad()`: Objective Logic
This function handles initialization *after* assets are loaded. The order of objective-related operations is important.

1.  **Define Command Posts**: `cp1 = CommandPost:New{name = "cp1"}`. Names must match ZeroEditor exactly.
2.  **Initialize Objective**:
    ```lua
    conquest = ObjectiveConquest:New{
        teamATT = ATT, teamDEF = DEF, -- Define team roles
        textATT = "game.modes.con", textDEF = "game.modes.con2", -- Set objective HUD text
        multiplayerRules = true -- Allow for multiplayer gameplay
    }
    ```
3.  **Add CPs**: `conquest:AddCommandPost(cp1)`. CPs not added here will not affect reinforcements.
4.  **Finalize**: 
    ```lua
    conquest:Start() -- Start the objective logic
    EnableSPHeroRules() -- Enable Hero classes and unlocking rules
    -- Additional world-specific setup, such as setting object properties, registering deathregions, adjusting AI planning/barriers, playing animations, callbacks, etc.
    ```

### `ScriptInit()`: Configuration & Assets
This function runs once at the very beginning to load files and set constraints. The order of sound-related operations is important (classes cannot be loaded before sounds or the game will complain of missing sounds, streams cannot be opened until sound configs are loaded, etc.)

#### Scene & Memory
| Command | Purpose |
| :--- | :--- |
| `ReadDataFile("assetFile.lvl")` | **Required** for all missions to load game and level assets. |
| `SetMaxFlyHeight(int)` | Prevents jump-units/flyers from leaving bounds. |
| `SetMemoryPoolSize("pool", size)`| **Required** Allocates engine pool memory (Cloth, Combo, UnitAgent, etc). |
| `SetSpawnDelay(10.0, 0.25)` | **Required** Sets default respawn timings. |
| `SetDenseEnvironment("bool")` | Adjusts AI pathing for cluttered/expansive maps. |
| `SetMapNorthAngle(angle, int)` | Sets North direction of minimap. |
| `AISnipeSuitabilityDist(distance)` | Sets suitable distance for AI sniping on this map. |
| `SetGroundFlyerMap(int)` | Makes AI flyers more aware of terrain if 1, no terrain if 0. |

```lua
function ScriptInit()   
    SetPS2ModelMemory(4056000) -- Specific to PS2
    SetMapNorthAngle(180, 1) -- Set North angle of minimap
    SetMaxFlyHeight(25) -- Set max flying height
    SetMaxPlayerFlyHeight (25) -- Set max flying height for player
    AISnipeSuitabilityDist(30) -- Adjust AI sniping distance
    SetNumBirdTypes(1) -- If map has birds, set count of types
    SetBirdType(0,1.0,"bird") -- If map has birds, set size and texture
    SetNumFishTypes(1) -- If map has fish, set count of types
    SetFishType(0,0.8,"fish") -- If map has fish, set size and texture
    SetMemoryPoolSize("Music", 33) -- Set music memory before loading music/sounds
    ReadDataFile("ingame.lvl") -- Read common/shared in-game assets
    ReadDataFile("sound\\cor.lvl;cor1cw") -- Read sound file sub-lvl BEFORE assets needing sounds to prevent errors

    -- For GCW era:
    -- ReadDataFile("sound\\cor.lvl;cor1gcw")

    ReadDataFile("SIDE\\rep.lvl", -- Read these sub-lvls for required side assets (REP team unit, weapon, vehicle classes)
        "rep_inf_ep3_rifleman",
        "rep_fly_assault_DOME",
        "rep_fly_gunship_DOME",
        "rep_inf_ep3_rocketeer",
        "rep_inf_ep3_engineer",
        "rep_inf_ep3_sniper", 
        "rep_inf_ep3_officer",
        "rep_inf_ep3_jettrooper",
        "rep_hero_macewindu")
    
    -- for GCW era:
    -- ReadDataFile("SIDE\\imp.lvl",
    --     "imp_inf_rifleman",
    --      "imp_inf_rocketeer",
    --      "imp_inf_engineer",
    --      "imp_inf_sniper",
    --      "imp_inf_officer",
    --      "imp_inf_dark_trooper",                   
    --      "imp_hero_emperor")

    ReadDataFile("SIDE\\cis.lvl", -- Read these sub-lvls for required side assets (CIS team unit, weapon, vehicle classes)
        "cis_inf_rifleman",
        "cis_fly_droidfighter_DOME",
        "cis_inf_rocketeer",
        "cis_inf_engineer",
        "cis_inf_officer",
        "cis_inf_sniper",
        "cis_inf_droideka",
        "cis_hero_darthmaul")

    -- For GCW era:
    -- ReadDataFile("SIDE\\all.lvl",
    --      "all_bldg_defensegridturret",
    --      "all_inf_rifleman",
    --      "all_inf_rocketeer",
    --      "all_inf_engineer",
    --      "all_inf_sniper",
    --      "all_inf_officer",
    --      "all_inf_wookiee",
    --      "all_hero_luke_jedi")
    
    ReadDataFile("SIDE\\tur.lvl", -- Read these sub-lvls for required side assets (Turrets)
        "tur_bldg_laser")
    ...
```

#### Team Configuration
**SetupTeams** table defines the unit loadout for each side:
*   `units`: The number of AI units active simultaneously.
*   `reinforcements`: Starting ticket count.
*   `min/max`: For units (e.g., `{ "class", 9, 25 }`), the game first satisfies all minimums, then randomly fills up to the `units` limit using the max values as caps.

**SetHeroClass** defines which hero unlocks for which team index.
```lua
    ...
    SetupTeams{ -- Table used for team registration/management
        rep = { -- Metatable of rep team
            team = REP, -- Associate teamIndex with rep team
            units = 32, -- Set rep team's active unit count
            reinforcements = 150, -- Set rep team's reinforcement count
            soldier  = { "rep_inf_ep3_rifleman",   7, 25 }, -- Set class name of rep soldier, min and max counts
            assault  = { "rep_inf_ep3_rocketeer",  1, 4  },
            engineer = { "rep_inf_ep3_engineer",   1, 4  },
            sniper   = { "rep_inf_ep3_sniper",     1, 4  },
            officer =  { "rep_inf_ep3_officer",    1, 4  },
            special =  { "rep_inf_ep3_jettrooper", 1, 4  },
        },
        cis = { -- Metatable of cis team
            team = CIS, -- Associate teamIndex with cis team
            units = 32, -- Set cis team's active unit count
            reinforcements = 150, -- Set cis team's reinforcement count
            soldier  = { "cis_inf_rifleman",  7, 25 }, -- Set class name of cis soldier, min and max counts
            assault  = { "cis_inf_rocketeer", 1, 4 },
            engineer = { "cis_inf_engineer",  1, 4 },
            sniper   = { "cis_inf_sniper",    1, 4 },
            officer =  { "cis_inf_officer",   1, 4 },
            special =  { "cis_inf_droideka",  1, 4 },
        }
     }
    SetHeroClass(CIS, "cis_hero_darthmaul") -- Set hero class for CIS team to this class name
    SetHeroClass(REP, "rep_hero_macewindu") -- Set hero class for REP team to this class name

    -- For GCW era:
    -- SetupTeams{
    --     imp = {
    --         team = IMP,
    --         units = 32,
    --         reinforcements = 150,
    --         soldier  = { "imp_inf_rifleman", 7, 25 },
    --         assault  = { "imp_inf_rocketeer", 1, 4 },
    --         engineer = { "imp_inf_engineer", 1, 4 },
    --         sniper   = { "imp_inf_sniper", 1, 4 },
    --         officer =  { "imp_inf_officer", 1, 4 },
    --         special =  { "imp_inf_dark_trooper", 1, 4 },
    --     },
    --     all = {
    --         team = ALL,
    --         units = 32,
    --         reinforcements = 150,
    --         soldier  = { "all_inf_rifleman", 7, 25 },
    --         assault  = { "all_inf_rocketeer", 1, 4 },
    --         engineer = { "all_inf_engineer", 1, 4 },
    --         sniper   = { "all_inf_sniper", 1, 4 },
    --         officer =  { "all_inf_officer", 1, 4 },
    --         special =  { "all_inf_wookiee", 1, 4 },
    --     }
    -- }
    -- SetHeroClass(IMP, "imp_hero_emperor")
    -- SetHeroClass(ALL, "all_hero_luke_jedi")

    -- Alternative method of adding classes to teams
    --AddUnitClass(CIS, "cis_inf_officer_hunt", 1, 2) -- Add unit class to CIS team with min and max counts
    ...
```

#### Walker Allocation
`AddWalkerType(legPairs, count)`:
*   `0`: Droidekas.
*   `1`: AT-ST / oneman AT-ST (ATRT).
*   `2`: Spider Walkers / AT-AT.
*   `3`: AT-TE.
> Note: Count may be set to -count to aggresively minimize allocations
```lua
    ...
    ClearWalkers() -- Clear automatic walker allocations (unreliable)
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 3) -- 1x2 (1 pair of legs: ATST, ATRT)
    AddWalkerType(2, 1) -- 2x2 (2 pairs of legs: ATAT, Spider Walker)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs: ATTE)
    ...
```

#### Memory Pool Allocations
Different for each world depending on entity counts, `SetMemoryPool("pool", count)`.
```lua
    ...
	-- Set world-specific memory pools (check log and raise as needed)
	SetMemoryPoolSize("Weapon", 256)				 -- Number of weapon entities
    SetMemoryPoolSize("Aimer", 128)					 -- Arbitrary number; weapon-related
    SetMemoryPoolSize("AmmoCounter", 256)            -- Ammo counters for weapon entities
    SetMemoryPoolSize("EnergyBar", 256)              -- Energy counters for entities that sprint/boost
	SetMemoryPoolSize("SoldierAnimation", 512)		 -- Arbitrary number; Unit animation memory
	SetMemoryPoolSize("UnitAgent", 64)				 -- Number of units; AI allotment
	SetMemoryPoolSize("UnitController", 64)			 -- Number of units; AI controller memory
	SetMemoryPoolSize("Navigator", 64)				 -- Number of controllable entities; AI navigation memory
	SetMemoryPoolSize("EntityCloth", 64)			 -- Number of cloth entities
    SetMemoryPoolSize("EntityHover", 5)				 -- Number of hover entities
    SetMemoryPoolSize("EntityFlyer", 4)              -- Number of flyer entities
    SetMemoryPoolSize("EntityLight", 200)			 -- Arbitrary number; Light memory-related
    SetMemoryPoolSize("EntitySoundStream", 2)		 -- Number of Sound Stream entities
    SetMemoryPoolSize("EntitySoundStatic", 70)		 -- Number of Sound Static entities
	SetMemoryPoolSize("BaseHint", 256)				 -- Number of hint nodes
    SetMemoryPoolSize("Obstacle", 836)				 -- Number of barriers
	SetMemoryPoolSize("PathNode", 128)				 -- Number of path nodes; spawn-path and flyer-path memory
    SetMemoryPoolSize("SoundSpaceRegion", 24)		 -- Number of Sound Space Regions
    SetMemoryPoolSize("TreeGridStack", 512)			 -- Arbitrary number; Worldspace memory-related
    SetMemoryPoolSize("ParticleEmitterObject", 1024) -- Arbitrary number; Particle Effect memory
    SetMemoryPoolSize("TentacleSimulator", 24)       -- Arbitrary number; Tentacle simulation memory
    ...
```

#### Loading World Data
`ReadDataFile("dc:ABC\\ABC.lvl", "ABC_conquest")`
Loads the addon map `.wld` and the mode-specific `.mrq` layer(s).
```lua
    ...
    SetSpawnDelay(10.0, 0.25) -- Set spawning rate defaults
    ReadDataFile("cor\\cor1.lvl","cor1_Conquest") -- load coruscant world and conquest layer
    SetDenseEnvironment("True") -- Adjust AI behavior for close-quarters map
    AddDeathRegion("DeathRegion1") -- Add a death region
    ...
```

#### Sound & Music
*   **Audio Streams**: `OpenAudioStream` loads music, unit VO (quick/slow), and ambient loops.
*   **VO Events**: `SetBleedingVoiceOver` triggers cues when reinforcements drop. `SetOutOfBoundsVoiceOver` triggers the "return to battle" warning.
*   **Dynamic Music**: `SetAmbientMusic` switches tracks based on game progress (1.0 = Start, 0.8 = Mid, 0.2 = End).

```lua
    ...
    -- Sound Config
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow") -- read rep announcer voice overs
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow) -- read cis announcer voice overs

    -- For GCW era:
    -- voiceSlow = OpenAudioStream("sound\\global.lvl", "imp_unit_vo_slow")
    -- AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)

    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) -- read announcer voice overs
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick") -- read rep unit combat voice overs
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick) -- read cis unit combat voice overs

    -- For GCW era:
    -- voiceQuick = OpenAudioStream("sound\\global.lvl", "imp_unit_vo_quick")
    -- AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_quick", voiceQuick)

    OpenAudioStream("sound\\global.lvl",  "cw_music") -- read clone wars music

    -- For GCW era: 
    -- OpenAudioStream("sound\\global.lvl",  "gcw_music")

    OpenAudioStream("sound\\cor.lvl",  "cor1") -- read world-specific sound streams
    OpenAudioStream("sound\\cor.lvl",  "cor1") -- read twice for "quadriphonic" streams

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1) -- rep team announcements
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1) -- cis team announcements
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1) -- rep team announcements
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1) -- cis team announcements
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)
    SetOutOfBoundsVoiceOver(REP, "Repleaving") -- rep team leaving announcement
    SetOutOfBoundsVoiceOver(CIS, "Cisleaving") -- cis team leaving announcement
    SetAmbientMusic(REP, 1.0, "rep_cor_amb_start",  0,1) -- rep team music configs
    SetAmbientMusic(REP, 0.8, "rep_cor_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_cor_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_cor_amb_start",  0,1) -- cis team music configs
    SetAmbientMusic(CIS, 0.8, "cis_cor_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_cor_amb_end",    2,1)
    SetVictoryMusic(REP, "rep_cor_amb_victory") -- rep team victory music
    SetDefeatMusic (REP, "rep_cor_amb_defeat") -- rep team defeat music
    SetVictoryMusic(CIS, "cis_cor_amb_victory") -- cis team victory music
    SetDefeatMusic (CIS, "cis_cor_amb_defeat") -- cis team defeat music

    -- For GCW era:
    -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    -- SetOutOfBoundsVoiceOver(1, "allleaving")
    -- SetOutOfBoundsVoiceOver(2, "impleaving")

    -- SetAmbientMusic(ALL, 1.0, "all_cor_amb_start",  0,1)
    -- SetAmbientMusic(ALL, 0.8, "all_cor_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.2, "all_cor_amb_end",    2,1)
    -- SetAmbientMusic(IMP, 1.0, "imp_cor_amb_start",  0,1)
    -- SetAmbientMusic(IMP, 0.8, "imp_cor_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.2, "imp_cor_amb_end",    2,1)

    -- SetVictoryMusic(ALL, "all_cor_amb_victory")
    -- SetDefeatMusic (ALL, "all_cor_amb_defeat")
    -- SetVictoryMusic(IMP, "imp_cor_amb_victory")
    -- SetDefeatMusic (IMP, "imp_cor_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin") -- set zoom-in sound
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout") -- set zoom-out sound
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit") -- set spawn display sounds
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")
    ...
```

#### Camerashots Setup
`AddCameraShot(quatW, quatX, quatY, quatZ, posx, posy, posz)` defines satellite camera positions throughout the level (16 shots max).
```lua
    ...
    -- Add opening/unit select/spectating camera positions
	AddCameraShot(0.998781, -0.048930, -0.006498, -0.000318, 103.957405, 8.547074, 319.198608); -- Beachhead
	AddCameraShot(-0.234943, 0.002553, -0.971949, -0.010560, 255.632736, 14.563819, -57.746239); -- Western Pier
	AddCameraShot(0.953158, -0.017164, 0.301936, 0.005437, 117.207672, 4.113541, 57.403130); -- Eastern Platform
	AddCameraShot(0.207372, 0.005745, -0.977870, 0.027091, 24.945528, 1.562206, 75.405655); -- Western Dock
end
```

## 2. 2-Flag CTF Differences

### Objective Logic
Uses `ObjectiveCTF` with team-specific capture regions:
*   **Sound**: `SoundEvent_SetupTeams(REP, 'rep', CIS, 'cis')` is required for capture/lost cues.
*   **Objective Parameters**:
    *   `captureLimit`: Goals needed to win.
    *   `homeRegion`: A region name used only to trigger flag respawns.
    *   `captureRegion`: Where the flag must be brought to score.

```lua
function ScriptPostLoad()
    SoundEvent_SetupTeams(REP, 'rep', CIS, 'cis') -- Set CTF announcer sounds
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag") -- Set rep flag geometry when on the ground
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried") -- Set rep flag geometry when carried
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag") -- Set cis flag geometry when on the ground
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried") -- Set cis flag geometry when carried
    SetClassProperty("com_item_flag_carried", "DroppedColorize", 1) -- Colorize flag when dropped
    ctf = ObjectiveCTF:New{ -- Setup 2-Flag CTF objective
        teamATT = ATT, -- Define team roles
        teamDEF = DEF,
        textATT = "game.modes.CTF", -- Set objective HUD text
        textDEF = "game.modes.CTF2",
        hideCPs = true, -- Hide command posts from minimap
        multiplayerRules = true -- Allow for multiplayer gameplay
    }
    ctf:AddFlag{ -- Register rep team's flag-related entities with objective logic
        name = "flag1", -- Register flag with rep team
        homeRegion = "Team1FlagCapture", -- Register rep team home region
        captureRegion = "Team2FlagCapture" -- Register rep team capture region
    }
    ctf:AddFlag{ -- Register cis team's flag-related entities with objective logic
        name = "flag2", -- Register flag with cis team
        homeRegion = "Team2FlagCapture", -- Register cis team home region
        captureRegion = "Team1FlagCapture" -- Register cis team capture region
    }
    ctf:Start() -- Start CTF objective logic
    EnableSPHeroRules() -- Enable Hero classes and unlocking rules
end
```

### Initialization
*   **Memory Pool**: `SetMemoryPoolSize("FlagItem", 2)` is **mandatory** or the game will crash.
*   **Layer Loading**: Load using the mode extension: `ReadDataFile("dc:ABC\\ABC.lvl", "ABC_ctf")`.

## 3. 1-Flag CTF Differences

### Objective Logic
Uses `ObjectiveOneFlagCTF` with team-specific capture regions:
*   `flagIcon`: The sprite used for the flag.
*   `captureRegionATT`: The scoring region for the attacking team.
*   `captureRegionDEF`: The scoring region for the defending team.

```lua
function ScriptPostLoad()
    SoundEvent_SetupTeams( 1, 'rep', 2, 'cis' ) -- Set CTF announcer sounds
	ctf = ObjectiveOneFlagCTF:New{ -- Setup 1-Flag CTF objective
        teamATT = REP, teamDEF = CIS, -- Define team roles
        textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", -- Set objective HUD text
        captureLimit = 5, -- Goals needed to win
        flag = "1flag_flag", -- Register flag entity
        flagIcon = "flag_icon", -- Set flag minimap element
        flagIconScale = 3.0, -- Set flag minimap element scale
        homeRegion = "1flag_capture2", -- Register home region (flag-spawning site)
        captureRegionATT = "1flag_capture1", captureRegionDEF = "1flag_capture2", -- Register team capture regions
        capRegionWorldATT = "1flag_effect2", capRegionWorldDEF = "1flag_effect1", -- Register capture effects
        capRegionMarkerATT = "hud_objective_icon_circle", -- Set team 1 capture region minimap elements
        capRegionMarkerDEF = "hud_objective_icon_circle", -- Set team 2 capture region minimap elements
        capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, -- Set capture region minimap elements scale
        multiplayerRules = true, -- Allow for multiplayer gameplay
        hideCPs = true -- Hide command posts from minimap
    }
	ctf:Start() -- Start CTF objective logic
	EnableSPHeroRules() -- Enable Hero classes and unlocking rules
end
```

### Initialization
*   **Memory Pool**: `SetMemoryPoolSize("FlagItem", 1)`.
*   **Layer Loading**: `ReadDataFile("dc:ABC\\ABC.lvl", "ABC_1flag")`.

## 4. Hero Assault Differences

### Objective Logic
Uses `ObjectiveTDM` (Team Deathmatch):
*   `isCelebrityDeathmatch = true`: Enables specific Hero Assault logic.
*   **AI Behavior**: Must manually set AI goals as they are not automatic in TDM:
    ```lua
    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)
    ```

### Team Setup
Heroes are typically defined as standard unit classes in `SetupTeams` to ensure they are always selectable, while `AddUnitClass` is used to populate additional class slots.

### Initialization
*   **Memory Pool**: High `Combo::` and `ClothData` values are required due to the density of Jedi classes.
*   **Layer Loading**: `ReadDataFile("dc:ABC\\ABC.lvl", "ABC_eli")`.

# Space Mission Creation Guide
Space missions often utilize a common logic file (e.g., `_cmn.lua`) to handle shared turret systems and environmental settings across different modes.

## 1. Common Space Logic (`_cmn.lua`)

### Turret Systems (`LinkedTurrets`)
Allows a central "mainframe" object to control the functional state of multiple turrets. This script can technically be used on ground maps as well.
```lua
ScriptCB_DoFile("LinkedTurrets")

function SetupTurrets()
    turretLinkageCIS = LinkedTurrets:New{ 
        team = CIS, mainframe = "cis-defense",
        turrets = {"cis_turr_1", "cis_turr_2", "cis_turr_3", "cis_turr_4", "cis_turr_5", "cis_turr_6"} 
    }
    turretLinkageCIS:Init()
end
```
**Events**: `OnDisableMainframe` (destruction) and `OnEnableMainframe` (repair) should be used to display `ShowMessageText` and play `BroadcastVoiceOver`.

### Environmental & Navigation
| Command | Purpose |
| :--- | :--- |
| `SetWorldExtents(2500)` | Defines playable space for units. Increase if units die instantly when exiting ships or moving through hangars. |
| `SetMaxFlyHeight(1800)` | Upper/lower limits for flyer altitude (AI and Player). Use `PrintPlayerPos` in the console to find appropriate values. |
| `SetAIVehicleNotifyRadius(100)` | Distance around a waiting craft from which AI can be lured into boarding. |
| `SetParticleLODBias(15000)` | **Required** for space-scale particles to render correctly. |

### Team & Memory Allocation
*   **SetupTeams**: `myTeamConfig` is typically defined in both the common and mode-specific scripts, as modes like CTF may exclude certain classes (e.g., Space Marines).
*   **Memory Pools**: Always allocate for `EntityFlyer` and `CommandFlyer`.
*   **Sky Assets**: `ReadDataFile("SPA\\spa_sky.lvl", planet)` loads backdrops like `"tat"` (Tatooine) or `"cor"` (Coruscant).

### Region Registration
| Command | Description |
| :--- | :--- |
| `AddDeathRegion(name)` | Activates a kill zone defined in ZeroEditor. |
| `AddLandingRegion(name)` | Restricts flyer landing and takeoff to the specified volume. If omitted, units can land anywhere. |

## 2. 1-Flag Space CTF Differences

### Objective Logic
Uses `ObjectiveOneFlagCTF` with space-specific dummy objects for visual markers:
*   `flag`: The object name from ZeroEditor.
*   `homeRegion`: Initial spawn and reset location.
*   `captureRegionATT / DEF`: The scoring regions for attackers/defenders.
*   `capRegionDummyObjectATT / DEF`: Visual orb markers (e.g., `"1flag_rep_marker"`) used to represent capture zones in 3D space.

### AI & Initialization
*   **Memory Pool**: `SetMemoryPoolSize("FlagItem", 1)` is mandatory.
*   **AI Goals**: `AddAIGoal(team, "Deathmatch", 100)` is required or AI will not spawn.

## 3. Space Assault Differences

### Overview
Assault mode focuses on starship critical systems using three supplemental scripts:
```lua
ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")
```
**Note**: `DisableSmallMapMiniMap()` is typically called in `ScriptPostLoad` for this mode.

### Objective Configuration (`SetupObjectives`)
Critical systems are mapped for each team. Attackers will prioritize these targets.
```lua
local repTargets = {
    engines = { "cis_drive_1", "cis_drive_2" },
    lifesupport = "cis-life-ext",
    bridge = "cis-bridge",
    comm = "cis-comms",
    sensors = "cis-sensors",
    frigates = "cis-frigate",
    internalSys = { "cis-life-int", "cis-engines" },
}
assault:SetupAllCriticalSystems("rep", repTargets, true)
```

### Shield Systems (`LinkedShields`)
Protects external objects (hull, bridge, engines) until the `controllerObject` (shield generator) is destroyed.
> **Tip**: Avoid shielding interior hangar meshes; shield impact effects on interior surfaces can look visualy jarring.

### Linked Destroyables
Synchronizes the state between internal systems and their external counterparts.
```lua
-- engineLinkage links external drives to the internal cooling/system
engineLinkageCIS = LinkedDestroyables:New{ 
    objectSets = {{"cis_drive_1", "cis_drive_2"}, {"cis-engines"}} 
}
```
