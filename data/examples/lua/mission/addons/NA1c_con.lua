-- Naboo: Plains CW Conquest
-- Calrissian97 03/27/26

-- Read required scripts
ScriptCB_DoFile("setup_teams")  	 -- Setup Teams tables
ScriptCB_DoFile("NA1_Utilities") 	 -- SetEnvironment, LoadEnvironment, AnnounceCPCapture, IsMulti functions
ScriptCB_DoFile("ObjectiveConquest") -- Conquest Objective

-- These globals do not change
ATT = 1                         -- Attacking team (Always 1)
DEF = 2                         -- Defending team

-- Setup team numbers (0-9); Conventionally starts at 1 and 2, no more than 9 active teams
CIS = ATT
REP = DEF

-- Determine session type for multiplayer-breaking features
Multiplayer = IsMulti()
AltLayout = false -- Whether CPs are flipped
Fambaa = false -- Whether Fambaa is enabled

-- Only run if singleplayer
if Multiplayer == false then
    -- Determine CP layout (Switches attacking and defending teams)
    if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\AltLayout.txt") == 1 then
        REP = ATT
        CIS = DEF
		print("NA1: Alt CP layout chosen")
        AltLayout = true
    end
end

-- Tasks to run after asset loading (After ScriptInit)
function ScriptPostLoad()
    -- Create CPs for Conquest objective
    cp1 = CommandPost:New{name = "CP1"}
    cp2 = CommandPost:New{name = "CP2"}
    cp3 = CommandPost:New{name = "CP3"}
    cp4 = CommandPost:New{name = "CP4"}
    cp5 = CommandPost:New{name = "CP11"}
    
    -- Assign team objectives for Conquest
    conquest = ObjectiveConquest:New{
        teamATT = ATT, 
        teamDEF = DEF, 
        textATT = "game.modes.con", 
        textDEF = "game.modes.con2",
        multiplayerRules = true}
    
    -- Add CPs to Conquest
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)    
    conquest:AddCommandPost(cp5)

    -- Start mission objective
    conquest:Start()
    EnableSPHeroRules()

	-- If singleplayer, allow for CP capture announcements
	if Multiplayer == false then
        -- Announce CP captures
        AnnounceCPCapture("REP", "CIS", REP, CIS)
	end

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
    ReadDataFile("sound\\yav.lvl;yav1cw") -- Stock sounds
    ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SOUND\\NA1.lvl;NA1cw") -- Custom sounds for this world
    
    -- Holds classname, or could be empty if we'd rather not
    local droidfighterClass = ""
    -- Whether to enable starfighters on singleplayer
    if Multiplayer == false then
        if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\Starfighters.txt") == 1 then
            -- Set droidfighter classname for loading
            droidfighterClass = "cis_fly_droidfighter_sc"
            print("NA1: Starfighters enabled")
            -- Whether to swap jedifighter for N1 Naboo Starfighter
            if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\N1Starfighter.txt") == 1 then
                -- Override jedifighter class to our N1 version
                ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SIDE\\n1.lvl;rep_fly_jedifighter")
                print("NA1: N1 Starfighter Enabled")
            else
                ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SIDE\\nab.lvl;rep_fly_jedifighter")
            end
        end
    end

    -- Holds classname, or could be empty if we'd rather not
    local speederClass = ""
    -- Whether to enable Kaadu walkers on singleplayer
    if Multiplayer == false then
        if AltLayout == false then
            if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\Kaadu.txt") == 1 then
                print("NA1: Kaadu walkers enabled")
                ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SIDE\\nab.lvl;gun_walk_kaadu")
            else
                -- Only set barcspeeder classname if Kaadu is disabled
                speederClass = "rep_hover_barcspeeder"
            end
        end
    end

    -- Whether B1 droids are used or Super Battle Droids only on singleplayer
    local B1Droid = false
    if Multiplayer == false then
        if ScriptCB_IsFileExist("..\\..\\addon\\NA1\\B1Droid.txt") == 1 then
            print("NA1: B1 droids enabled")
            B1Droid = true
        end
    end

    -- Whether to load SBD or Marine class
    local droidClass = "cis_inf_rifleman" -- SBD as usual
    if B1Droid == true then
        droidClass = "cis_inf_marine" -- Load marine for CIS rifle weapon
    end

    -- Load stock side assets (REP)
    ReadDataFile("SIDE\\rep.lvl",
        "rep_inf_ep2_rifleman",
        "rep_inf_ep2_rocketeer",
        "rep_inf_ep2_engineer",
        "rep_inf_ep2_sniper",
        "rep_inf_ep3_officer",
        "rep_inf_ep2_jettrooper",
        "rep_hero_obiwan",
        "rep_hover_fightertank",
        "rep_fly_assault_dome",
        speederClass)
    
    -- Load stock side assets (CIS)
    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_rocketeer",
        "cis_inf_engineer",
        "cis_inf_sniper",
        "cis_inf_officer",
        "cis_inf_droideka",
        "cis_hero_darthmaul",
        "cis_hover_aat",
        "cis_hover_stap",
        "cis_fly_fedlander_dome",
        droidClass,
        droidfighterClass)

    -- Load stock side assets (TUR)
    ReadDataFile("SIDE\\tur.lvl", 
        "tur_bldg_laser")

    -- Use B1 Droid unit
    if B1Droid == true then
        -- Now that CIS Marine and rifle weapons are loaded, override rifleman class to our custom one
        ReadDataFile("..\\..\\addon\\NA1\\data\\_lvl_pc\\SIDE\\nab.lvl;cis_inf_rifleman")
    end

    -- Setup team units
	SetupTeams{
		rep = {
			team = REP,
			units = 32,
			reinforcements = 150,
			soldier  = { "rep_inf_ep2_rifleman",   9, 25 },
			assault  = { "rep_inf_ep2_rocketeer",  1,  4 },
			engineer = { "rep_inf_ep2_engineer",   1,  4 },
			sniper =   { "rep_inf_ep2_sniper",     1,  4 },
			officer =  { "rep_inf_ep3_officer",    1,  4 },
			special =  { "rep_inf_ep2_jettrooper", 1,  4 },
	        
		},
		cis = {
			team = CIS,
			units = 32,
			reinforcements = 150,
			soldier  = { "cis_inf_rifleman",  9, 25 },
			assault  = { "cis_inf_rocketeer", 1,  4 },
			engineer = { "cis_inf_engineer",  1,  4 },
			sniper =   { "cis_inf_sniper",    1,  4 },
			officer =  { "cis_inf_officer",   1,  4 },
			special =  { "cis_inf_droideka",  1,  4 },
		}
	}
    
    -- Set hero classes
    SetHeroClass(CIS, "cis_hero_darthmaul")
    SetHeroClass(REP, "rep_hero_obiwan")
    
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
            -- Gungans are always allied to REP
            SetTeamAsFriend(3, REP)
            SetTeamAsFriend(REP,3)
            SetTeamAsEnemy(CIS,3)
            SetTeamAsEnemy(3,CIS)
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
    SetMemoryPoolSize("EntityWalker", 8)
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 3) -- 1x2 (1 pair of legs) -> kaadu
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
	-- Set world-specific memory pools --
    local WeaponCount = 1024									-- Max number of weapon entities; Check log and raise as needed
	local UnitCount = 90										-- Max number of units to account for
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
    SetMemoryPoolSize("TentacleSimulator", 12)
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "gun_unit_vo_slow", voiceSlow)
    
    -- Sounds to use for unit vo
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    -- Ambient sounds to stream in
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")

    -- Custom ambient sounds to stream
    if Environment == "Rain" then
        OpenAudioStream("..\\..\\addon\\NA1\\data\\_lvl_pc\\SOUND\\NA1.lvl", "Rain")
    else
        OpenAudioStream("..\\..\\addon\\NA1\\data\\_lvl_pc\\SOUND\\NA1.lvl", "NA1")
    end

    -- Set voiceovers
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(CIS, "cisleaving")
    SetOutOfBoundsVoiceOver(REP, "repleaving")

    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)  

    -- Set music playback
    SetAmbientMusic(REP, 1.0, "rep_yav_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_yav_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_yav_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_yav_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_yav_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_yav_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_yav_amb_victory")
    SetDefeatMusic (REP, "rep_yav_amb_defeat")
    SetVictoryMusic(CIS, "cis_yav_amb_victory")
    SetDefeatMusic (CIS, "cis_yav_amb_defeat")

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
    speederClass = nil
    droidClass = nil
    B1Droid = nil
    droidfighterClass = nil
    
    -- Add opening and unit select camera positions
    AddCameraShot(-0.268189, 0.007129, -0.963000, -0.025598, 86.595695, -92.078239, 150.503632); -- CIS Hill
	AddCameraShot(0.992168, -0.083560, 0.092516, 0.007792, -34.928650, -91.845566, 212.914871); -- Pillars
	AddCameraShot(0.991260, -0.064975, -0.114564, -0.007509, -12.676682, -91.845566, 128.521439); -- Center
end