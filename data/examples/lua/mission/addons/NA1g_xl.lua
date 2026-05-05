-- Naboo: Plains GCW XL
-- Calrissian97 04/01/26

-- Read required scripts
ScriptCB_DoFile("setup_teams")  	 -- Setup Teams tables
ScriptCB_DoFile("NA1_Utilities") 	 -- SetEnvironment, LoadEnvironment, AnnounceCPCapture, IsMulti functions
ScriptCB_DoFile("ObjectiveTDM")      -- Team Deathmatch Objective

-- These globals do not change
ATT = 1                         -- Attacking team (Always 1)
DEF = 2                         -- Defending team

-- Setup team numbers (0-9); Conventionally starts at 1 and 2, no more than 9 active teams
IMP = ATT
ALL = DEF

-- Determine session type for multiplayer-breaking features
Multiplayer = IsMulti()
AltLayout = false -- Whether CPs are flipped
Fambaa = false -- Whether Fambaa is enabled

-- Only run if singleplayer
if Multiplayer == false then
    -- Determine CP layout (Switches attacking and defending teams)
    if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\AltLayout.txt") == 1 then
        ALL = ATT
        IMP = DEF
		print("NA1: Alt CP layout chosen")
        AltLayout = true
    end
end

-- Tasks to run after asset loading (After ScriptInit)
function ScriptPostLoad()
	-- Add mission objectives (TDM-XL)
	AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)

    TDM = ObjectiveTDM:New{
		teamATT = 1, teamDEF = 2, 
		multiplayerScoreLimit = 100,
		textATT = "game.modes.tdm",
		textDEF = "game.modes.tdm2",
		multiplayerRules = true,
		isUberMode = true,
	}
	TDM:Start()
    EnableSPHeroRules()

    -- If Fambaa is enabled only on singleplayer
    if Fambaa == true then
        -- Enable Fambaa barriers
        EnableBarriers("Fambaa1")
        EnableBarriers("Fambaa2")

         -- Callback to kill fakeshield upon Fambaa Shield death and disable barriers
        FambaaDeath = OnHealthChangeName(
            function(object, health)
                if health <= 0 then
                    SetProperty("fakeshield", "IsVisible", 0)
                    DisableBarriers("Fambaa1")
                    DisableBarriers("Fambaa2")
                    print("NA1: Fambaa killed, hiding fakeshield prop and disabling barriers")
                    ReleaseObjectKill(FambaaDeath)
                    FambaaDeath = nil
                end
            end,
        "fambaa_shield"
        )
    else
        -- If Fambaa not enabled disable barriers
        DisableBarriers("Fambaa1")
        DisableBarriers("Fambaa2")
    end

	-- Disable capturing CPs
    SetProperty("CP1",  "CaptureRegion", "_")
    SetProperty("CP2",  "CaptureRegion", "_")
    SetProperty("CP3",  "CaptureRegion", "_")
    SetProperty("CP4",  "CaptureRegion", "_") 
    SetProperty("CP11", "CaptureRegion", "_")
    SetProperty("CP11", "Team", ATT)
    
    -- Hide CW era props
    SetProperty("MTT1", "IsVisible", 0)
    SetProperty("MTT2", "IsVisible", 0)
    SetProperty("MTT3", "IsVisible", 0)
    SetProperty("MTT4", "IsVisible", 0)
    SetProperty("Lander", "IsVisible", 0)
    SetProperty("MTT1", "IsCollidable", 0)
    SetProperty("MTT2", "IsCollidable", 0)
    SetProperty("MTT3", "IsCollidable", 0)
    SetProperty("MTT4", "IsCollidable", 0)
    SetProperty("Lander", "IsCollidable", 0)

    -- Make heroes act as troopers, not snipers
    SetClassProperty("all_hero_leia", "UnitType", "Trooper")
    
    -- Freeup temporary variables
    Multiplayer = nil
    AltLayout = nil
    Fambaa = nil
end

 -- Initialize memory pools, setup teams, and load assets
function ScriptInit()
    -- Choose environment (See NA1_Utilities for function definition and environment options)
    -- BF1 is default
    local Environment = "BF1"

    -- Only dynamically set environment if playing singleplayer
	if Multiplayer == false then
        -- Checks text files for specified version for loading screen and models
        Environment = SetEnvironment()
	else
		-- If on multiplayer just feed in default environment
		SetEnvironment(Environment)
    end
    print("NA1: Environment " .. Environment .. " selected")

    -- Set memory pools for rendering
    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2048)
    SetMemoryPoolSize("ParticleTransformer::PositionTr", 2800)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1200)

    -- Load custom and stock ingame assets (com_item_weaponrecharge, com_bldg_controlzone)
    ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\ingame.lvl")  
    ReadDataFile("ingame.lvl")

    -- Set heights
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight (50)

    -- Warn AI flyers about terrain
    SetGroundFlyerMap(1);
    
    -- Set unit/weapon related memory pools
    SetMemoryPoolSize ("ClothData",128)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    --  Birdies
    if Environment ~= "Rain" then
        SetNumBirdTypes(1)
        SetBirdType(0,1.0,"bird")
    end
    
    -- Load specific sound assets for this world
    ReadDataFile("sound\\yav.lvl;yav1gcw") -- Stock sounds
    ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SOUND\\NA1.lvl;NA1gcw") -- Custom sounds for this world

    -- Starfighter classes to load
    local tieClass = ""
    local xwingClass = ""
    -- Whether to enable starfighters on singleplayer
    if Multiplayer == false then
        if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\Starfighters.txt") == 1 then
            -- Set tiefighter classname for loading
            tieClass = "imp_fly_tiefighter_sc"
            print("NA1: Starfighters enabled")
            -- Whether to swap xwing for N1 Naboo Starfighter
            if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\N1Starfighter.txt") == 1 then
                -- Override xwing class to our N1 version
                ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SIDE\\n1.lvl;all_fly_xwing_sc")
                print("NA1: N1 Starfighter Enabled")
            else
                xwingClass = "all_fly_xwing_sc"
            end
        end
    end

    -- Whether Kaadus are enabled
    local speederClass = ""
    -- Whether to enable Kaadu walkers on singleplayer
    if Multiplayer == false then
        if AltLayout == false then
            if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\Kaadu.txt") == 1 then
                print("NA1: Kaadu walkers enabled")
                ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SIDE\\nab.lvl",
                    "gun_walk_kaadu")
            else
                -- Only set speeder classname if Kaadu is disabled
                speederClass = "imp_hover_speederbike"
            end
        end
    end

    -- Load stock side assets (ALL)
    ReadDataFile("SIDE\\all.lvl",
        "all_inf_rifleman",
        "all_inf_rocketeer",
        "all_inf_engineer",
        "all_inf_sniper",
        "all_inf_officer",
        "all_inf_wookiee",
        "all_hero_leia",
        "all_fly_moncalamari_dome",
        "all_hover_combatspeeder",
        xwingClass)
                
    -- Load stock side assets (IMP)
    ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_rifleman",
        "imp_inf_rocketeer",
        "imp_inf_engineer",
        "imp_inf_sniper",
        "imp_inf_officer",
        "imp_inf_dark_trooper",
        "imp_hover_fightertank",
        "imp_hero_emperor",
        "imp_fly_destroyer_dome",
        "imp_walk_atst_jungle",
        speederClass,
        tieClass)

    -- Load stock side assets (TUR)
    ReadDataFile("SIDE\\tur.lvl", 
        "tur_bldg_laser")

    -- Setup team units
	SetupTeams{
		ALL = {
			team = ALL,
			units = 64,
			reinforcements = -1,
            soldier  = { "all_inf_rifleman",9, 20},
            assault  = { "all_inf_rocketeer",1, 10},
            engineer = { "all_inf_engineer",1, 10},
            sniper   = { "all_inf_sniper",1, 8},
            officer = {"all_inf_officer",1, 8},
            special = { "all_inf_wookiee",1, 8},
	        
		},
		IMP = {
			team = IMP,
			units = 64,
			reinforcements = -1,
            soldier  = { "imp_inf_rifleman",9, 20},
            assault  = { "imp_inf_rocketeer",1, 10},
            engineer = { "imp_inf_engineer",1, 10},
            sniper   = { "imp_inf_sniper",1, 8},
            officer = {"imp_inf_officer",1, 8},
            special = { "imp_inf_dark_trooper",1, 8},
		}
	}
    
    -- Set hero classes
    SetHeroClass(ALL, "all_hero_leia")
    SetHeroClass(IMP, "imp_hero_emperor")
    
    -- Add Gungan team if enabled on singleplayer
    if Multiplayer == false then
        if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\GunganTeam.txt") == 1 then
            print("NA1: Gungan Team enabled")
            -- Load stock Gungan assets
        ReadDataFile("SIDE\\gun.lvl",
            "gun_inf_defender",
            "gun_inf_rider",
            "gun_inf_soldier")
            -- Team setup
            SetTeamName(3, "local")
            AddUnitClass(3, "gun_inf_defender", 2)
            AddUnitClass(3, "gun_inf_soldier",    2)
            AddUnitClass(3, "gun_inf_rider",       2)
            SetUnitCount(3, 10)
            AddAIGoal(3, "Deathmatch", 100)
            -- Gungans are always allied to ALL
            SetTeamAsFriend(3, ALL)
            SetTeamAsFriend(ALL,3)
            SetTeamAsEnemy(IMP,3)
            SetTeamAsEnemy(3,IMP)
            -- Disallow CP capture
            AICanCaptureCP("CP1", 3, false)
            AICanCaptureCP("CP2", 3, false)
            AICanCaptureCP("CP3", 3, false)
            AICanCaptureCP("CP4", 3, false)
            AICanCaptureCP("CP11", 3, false)
        end
    end

    -- Whether to enable Fambaa Shield Generator on singleplayer
    if Multiplayer == false then
        if AltLayout == false then
            if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\FambaaShield.txt") == 1 then
                print("NA1: Fambaa Shields enabled")
                Fambaa = true
            end
        end
    end

    -- Set "walker" memory pools (Droidekas and legged-transports)
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", 6)
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 6) -- 1x2 (1 pair of legs) -> kaadu
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
	-- Set world-specific memory pools --
    local WeaponCount = 1024									-- Max number of weapon entities; Check log and raise as needed
	local UnitCount = 148										-- Max number of units to account for
	SetMemoryPoolSize("Weapon", WeaponCount)					-- Number of weapon entities;
    SetMemoryPoolSize("Aimer", 128)								-- Arbitrary number, check log and raise as needed
    SetMemoryPoolSize("AmmoCounter", WeaponCount)
    SetMemoryPoolSize("EnergyBar", WeaponCount)
	SetMemoryPoolSize("SoldierAnimation", 512)					-- Arbitrary number, raise as needed; Unit animation memory
	SetMemoryPoolSize("UnitAgent", UnitCount)					-- Number of units; AI allotment
	SetMemoryPoolSize("UnitController", UnitCount)				-- Number of units; AI controller memory
	SetMemoryPoolSize("Navigator", UnitCount)				    -- Number of controllable entities; AI navigation memory
	SetMemoryPoolSize("EntityCloth", UnitCount)					-- Number of cloth entities; Note: props with cloth count too
    SetMemoryPoolSize("EntityHover", 12)							-- Number of hover entities
	SetMemoryPoolSize("EntityFlyer", 2)						    -- Number of flyer entities
    SetMemoryPoolSize("EntityLight", 200)						-- Number of lights in world (?)
    SetMemoryPoolSize("EntitySoundStream", 2)					-- Number of Sound Stream entities
    SetMemoryPoolSize("EntitySoundStatic", 70)					-- Number of Sound Static entities
	SetMemoryPoolSize("BaseHint", 256)							-- Number of hint nodes
    SetMemoryPoolSize("Obstacle", 836)							-- Number of barriers
	SetMemoryPoolSize("PathNode", 128)							-- Number of path nodes; spawn-path and flyer-path memory
    SetMemoryPoolSize("SoundSpaceRegion", 68)					-- Number of Sound Space Regions
    SetMemoryPoolSize("TreeGridStack", 512)						-- Arbitrary number, check log and raise as needed
    SetMemoryPoolSize("ParticleEmitterObject", 1024)			-- Arbitrary number, raise as needed; Particle Effect memory
    SetMemoryPoolSize("TentacleSimulator", 22)
    SetMemoryPoolSize("MountedTurret", 32)
    
    -- Set spawning delay
    SetSpawnDelay(10.0, 0.25)

    -- Whether to load BF1 or Rain sound layer
    local soundLayer = "NA1_BF1"
    if Environment == "Rain" then
        soundLayer = "NA1_Rain"
    end

    -- Whether to load the Fambaa shield generator layer
    local fambaaLayer = ""
    if Fambaa == true then
        fambaaLayer = "NA1_Fambaa"
    end

    -- Whether to load the Foggy effects layer
    local foggyLayer = ""
    if Environment == "Foggy" then
        foggyLayer = "NA1_Foggy"
    end

    -- Load world and layer(s)
    ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\NA1\\NA1.lvl", "NA1_conquest", soundLayer, fambaaLayer, foggyLayer)

    -- Advise AI of environment
    SetDenseEnvironment("false")

    -- Load ToD/weather assets (SKY, LGT, FX, TER)
	LoadEnvironment(Environment)

    -- Set sound parameters --
	-- Sounds to use for announcer vo
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "gun_unit_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)  
    
    -- Ambient sounds to stream in
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")

    -- Custom ambient sounds to stream
    if Environment == "Rain" then
        OpenAudioStream("..\\..\\addon\\NA1\\data\\_lvl_pc\\SOUND\\NA1.lvl", "Rain")
    else
        OpenAudioStream("..\\..\\addon\\NA1\\data\\_lvl_pc\\SOUND\\NA1.lvl", "NA1")
    end

    -- Set voiceovers
    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(ALL, "allleaving")
    SetOutOfBoundsVoiceOver(IMP, "impleaving")

    -- Set music playback
    SetAmbientMusic(ALL, 1.0, "all_yav_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_yav_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_yav_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_yav_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_yav_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_yav_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_yav_amb_victory")
    SetDefeatMusic (ALL, "all_yav_amb_defeat")
    SetVictoryMusic(IMP, "imp_yav_amb_victory")
    SetDefeatMusic (IMP, "imp_yav_amb_defeat")

    -- Set sound effects
    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    -- Free up temporary variables
    Environment = nil
    soundLayer = nil
    fambaaLayer = nil
    foggyLayer = nil
    tieClass = nil
    xwingClass = nil
    speederClass = nil
    
    -- Add opening and unit select camera positions
    AddCameraShot(-0.268189, 0.007129, -0.963000, -0.025598, 86.595695, -92.078239, 150.503632); -- CIS Hill
	AddCameraShot(0.992168, -0.083560, 0.092516, 0.007792, -34.928650, -91.845566, 212.914871); -- Pillars
	AddCameraShot(0.991260, -0.064975, -0.114564, -0.007509, -12.676682, -91.845566, 128.521439); -- Center
end
