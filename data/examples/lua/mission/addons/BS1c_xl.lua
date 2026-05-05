-- Bespin: Platforms CW XL
-- Calrissian97 01/05/26

-- Read required scripts
ScriptCB_DoFile("setup_teams")	 -- Setup Teams tables
ScriptCB_DoFile("BS1_Utilities") -- SetEnvironment, LoadEnvironment, AnnounceCPCapture, IsMulti functions
ScriptCB_DoFile("ObjectiveTDM")  -- Team Deathmatch Objective

-- These globals do not change
ATT = 1							-- "Attacking" team
DEF = 2							-- "Defending" team

-- Setup team numbers (0-9); Conventionally starts at 1 and 2, no more than 9 active teams
REP = 2
CIS = 1

-- Determine session type for multiplayer-breaking features
Multiplayer = IsMulti()

-- Only run if singleplayer
if Multiplayer == false then
	-- Determine CP layout (Switches attacking and defending teams)
	if ScriptCB_IsFileExist("..\\..\\addon\\BS1\\AltLayout.txt") == 1 then
		CIS = 2
		REP = 1
		print("BS1:Alt CP layout chosen")
	end
end

-- Tasks to run after asset loading
function ScriptPostLoad()
	-- Enable paths that flying vehicles will track and follow
	EnableFlyerPath("entitypath flyerpath", 1)

	-- Enable AI planning connections for the ramps on Central Platform
	SetCentralPlatformPlanning(true)
	
	-- Add AI goals (TDM)
	AddAIGoal(3, "Deathmatch", 100)
	AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)

    if Multiplayer == false then
        -- Setup mission objective (Uber mode on)
        TDM = ObjectiveTDM:New{
            teamATT = 1, teamDEF = 2, 
            multiplayerScoreLimit = 100,
            textATT = "game.modes.tdm",
            textDEF = "game.modes.tdm2",
            multiplayerRules = true,
            isUberMode = true,
        }
    else
        -- Setup mission objective (Uber mode off)
        TDM = ObjectiveTDM:New{
            teamATT = 1, teamDEF = 2, 
            multiplayerScoreLimit = 100,
            textATT = "game.modes.tdm",
            textDEF = "game.modes.tdm2",
            multiplayerRules = true,
            isUberMode = false,
        }
	end

	TDM:Start()
    EnableSPHeroRules()

	-- Remove central CP
	KillObject("cp3")
	-- Disable capturing
	SetProperty("cp1", "CaptureRegion", "_")
	SetProperty("cp2", "CaptureRegion", "_")
	SetProperty("cp4", "CaptureRegion", "_")
	SetProperty("cp5", "CaptureRegion", "_")
	SetProperty("cp6", "CaptureRegion", "_") 
	SetProperty("cp7", "CaptureRegion", "_")

	-- If singleplayer, allow for enabling transport landing
	if Multiplayer == false then
		-- Determine if AI transports should try landing at specified regions
		if ScriptCB_IsFileExist("..\\..\\addon\\BS1\\TransportLanding.txt") == 1 then
			ActivateRegion("landregion1")
			ActivateRegion("landregion2")
			ActivateRegion("landregion3")
			ActivateRegion("landregion4")
			print("BS1:Landing regions activated")
		end
		
	-- If multiplayer then disable AI transport landing
	else
		print("BS1:Multiplayer game, transport landing disabled")
		DeactivateRegion("landregion1")
		DeactivateRegion("landregion2")
		DeactivateRegion("landregion3")
		DeactivateRegion("landregion4")
		print("BS1:Landing regions deactivated")
	end

	-- The following four functions force AI transports to land upon entering landing regions --
	
	-- These are only enabled if playing singleplayer for balancing...
	if Multiplayer == false then
		Land1 = OnEnterRegion(
		function(region, character)
		
			-- Checks to make sure only specified class of flyer is set to land upon entering region
			if GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("rep_fly_gunship_sc") or GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("cis_fly_maf") then
				print("BS1:Land1:Transport entered region")
				ship = GetCharacterVehicle(character)				
				-- Force AI to leave transport after landing
				if not IsCharacterHuman(character) then
					print("BS1:Land1:AI transport set to land")
					EntityFlyerLand(ship)
					ExitVehicle(character)
				end
			end
		end,
		
		-- Name of landing region
	   "landregion1"
	   )

		Land2 = OnEnterRegion(
		function(region, character)
			if GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("rep_fly_gunship_sc") or GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("cis_fly_maf") then
				print("BS1:Land2:Transport entered region")
				ship = GetCharacterVehicle(character)
				if not IsCharacterHuman(character) then
					print("BS1:Land2:AI transport set to land")
					EntityFlyerLand(ship)
					ExitVehicle(character)
				end
			end
		end,
	   "landregion2"
	   )

		Land3 = OnEnterRegion(
		function(region, character)
			if GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("rep_fly_gunship_sc") or GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("cis_fly_maf") then
				print("BS1:Land3:Transport entered region")
				ship = GetCharacterVehicle(character)
				if not IsCharacterHuman(character) then
					print("BS1:Land3:AI transport set to land")
					EntityFlyerLand(ship)
					ExitVehicle(character)
				end
			end
		end,
	   "landregion3"
	   )

		Land4 = OnEnterRegion(
		function(region, character)
			if GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("rep_fly_gunship_sc") or GetEntityClass(GetCharacterVehicle(character)) == FindEntityClass("cis_fly_maf") then
				print("BS1:Land4:Transport entered region")
				ship = GetCharacterVehicle(character)
				if not IsCharacterHuman(character) then
					print("BS1:Land4:AI transport set to land")
					EntityFlyerLand(ship)
					ExitVehicle(character)
				end
			end
		end,
	   "landregion4"
	   )
	end
end

-- Initialize memory pools, setup teams, and load assets
function ScriptInit()
	-- Choose ToD or weather (See BS1_Utilities for function definition and weather options)
	-- BF1 is default
    local Environment = "BF1"
	
	-- Only dynamically set environment if playing singleplayer
	if Multiplayer == false then
		-- Checks text files for specified version for LOAD.lvl
		Environment = SetEnvironment()
	    -- Unlock unit count limits
		SetUberMode(1)
	else
		-- If on multiplayer just feed in default environment
		SetEnvironment(Environment)
	end
	print("BS1:Environment " .. Environment .. " selected")
	
	-- Set memory pools for rendering
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1200)
    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1800)

	-- Set aggressiveness for teams
	SetTeamAggressiveness(CIS, 1.0)
    SetTeamAggressiveness(REP, 1.0)

	-- Load custom and stock ingame assets (com_item_weaponrecharge, com_bldg_controlzone)
    ReadDataFile("..\\..\\addon\\BS1\\data\\_lvl_pc\\ingame.lvl") -- overwrites gonk with lowerez
    ReadDataFile("ingame.lvl")
	
	-- Set heights
    SetMaxFlyHeight(900)
	SetMaxPlayerFlyHeight(900)
    SetMinFlyHeight(-40)
	SetMinPlayerFlyHeight(-40)
    
	-- Set unit/weapon related memory pools
    SetMemoryPoolSize ("ClothData", 128) 				-- Arbitrary number, check logs and increase as needed
    SetMemoryPoolSize ("Combo", 70)              		-- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State", 850)      		-- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition", 875) 		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition", 875)  		-- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack", 850)     		-- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample", 10000) 	-- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect", 140)     		-- should be ~1x #combo 
	
	-- Set music memory pool
    SetMemoryPoolSize("Music", 64)						-- Arbitrary number, check logs and increase as needed
	
	-- Load specific sound assets for this world
	ReadDataFile("..\\..\\addon\\BS1\\data\\_lvl_pc\\SOUND\\BS1.lvl;BS1cw") -- Custom sounds
	ReadDataFile("sound\\cor.lvl;cor1cw") -- Stock sounds (Coruscant CW)

	-- Load stock side assets (REP)
	ReadDataFile("SIDE\\rep.lvl",
		"rep_inf_ep2_rifleman",
		"rep_inf_ep2_rocketeer",
		"rep_inf_ep2_engineer",
		"rep_inf_ep2_sniper",
		"rep_inf_ep3_officer",
		"rep_inf_ep2_jettrooper",
		"rep_hero_anakin",
		"rep_fly_gunship_sc",
		"rep_fly_anakinstarfighter_sc",
		"rep_fly_assault_dome"
	)
		
	-- Load stock side assets (CIS)
	ReadDataFile("SIDE\\cis.lvl",
		"cis_inf_rifleman",
		"cis_inf_rocketeer",
		"cis_inf_engineer",
		"cis_inf_sniper",
		"cis_inf_officer",
		"cis_inf_droideka",
		"cis_hero_grievous",
		"cis_fly_tridroidfighter",
		"cis_fly_droidfighter_sc",
		"cis_fly_fedlander_dome"
	)
	
	-- Determine which cloudcar class to load, BF1 or EA
	local cloudcarClass = "bes_fly_cloudcar"
	if Environment == "EA" then
		cloudcarClass = "bes_fly_cloudcar_ea"
	end

	-- Load custom sides for world-specific classes (Bespin Cloud Car, AA Turret, and CIS MAF)
	ReadDataFile("..\\..\\addon\\BS1\\data\\_lvl_pc\\SIDE\\BES.lvl",
		cloudcarClass,
		"cis_fly_maf",
		"bes_bldg_aa_turret")
	cloudcarClass = nil

	-- Setup team units
	SetupTeams{
		rep = {
			team = REP,
			units = 64,
			reinforcements = -1,
			soldier  = { "rep_inf_ep2_rifleman",   9, 20 },
			assault  = { "rep_inf_ep2_rocketeer",  1, 10 },
			engineer = { "rep_inf_ep2_engineer",   1, 10 },
			sniper   = { "rep_inf_ep2_sniper",     1, 8  },
			officer  = { "rep_inf_ep3_officer",    1, 8  },
			special  = { "rep_inf_ep2_jettrooper", 1, 8  },
		},
		cis = {
			team = CIS,
			units = 64,
			reinforcements = -1,
			soldier  = { "cis_inf_rifleman",  9, 20 },
			assault  = { "cis_inf_rocketeer", 1, 10 },
			engineer = { "cis_inf_engineer",  1, 10 },
			sniper   = { "cis_inf_sniper",    1, 8  },
			officer  = { "cis_inf_officer",   1, 8  },
			special  = { "cis_inf_droideka",  1, 8  },
		}
	}

	-- Set hero classes
	SetHeroClass(CIS, "cis_hero_grievous")
	SetHeroClass(REP, "rep_hero_anakin")
	
	-- Set attacking team
	SetAttackingTeam(ATT)
    
    -- Set "walker" memory pools (Droidekas and legged-transports)
    ClearWalkers()
    AddWalkerType(0, 10) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
	-- Set world-specific memory pools --
    local WeaponCount = 1024									-- Max number of weapon entities; Check log and raise as needed
	local UnitCount = 128										-- Max number of units to account for
	
	SetMemoryPoolSize("Weapon", WeaponCount)					-- Number of weapon entities;
    SetMemoryPoolSize("Aimer", 256)								-- Arbitrary number, check log and raise as needed
    SetMemoryPoolSize("AmmoCounter", WeaponCount)
    SetMemoryPoolSize("EnergyBar", WeaponCount)
	SetMemoryPoolSize("SoldierAnimation", 512)					-- Arbitrary number, raise as needed; Unit animation memory
	SetMemoryPoolSize("UnitAgent", UnitCount)					-- Number of units; AI allotment
	SetMemoryPoolSize("UnitController", UnitCount)				-- Number of units; AI controller memory
	SetMemoryPoolSize("Navigator", UnitCount)					-- Number of controllable entities; AI navigation memory
	SetMemoryPoolSize("EntityCloth", UnitCount)					-- Number of cloth entities; Note: props with cloth count too
    SetMemoryPoolSize("MountedTurret", 32)						-- Number of turrets in world
    SetMemoryPoolSize("EntityHover", 0)							-- Number of hover entities
	SetMemoryPoolSize("EntityFlyer", 16)						-- Number of flyer entities
    SetMemoryPoolSize("CommandFlyer", 4)						-- Number of transport entities 
    SetMemoryPoolSize("EntityLight", 200)						-- Number of lights in world (?)
    SetMemoryPoolSize("EntitySoundStream", 9)					-- Number of Sound Stream entities
    SetMemoryPoolSize("EntitySoundStatic", 6)					-- Number of Sound Static entities
	SetMemoryPoolSize("BaseHint", 1024)							-- Arbitrary number; hint node memory (?)
    SetMemoryPoolSize("Obstacle", 2017)							-- Arbitrary number; barrier memory
	SetMemoryPoolSize("PathNode", 1024)							-- Arbitrary number; spawn-path and flyer-path memory
    SetMemoryPoolSize("SoundSpaceRegion", 3)					-- Number of Sound Space Regions
    SetMemoryPoolSize("TreeGridStack", 512)						-- Arbitrary number, check log and raise as needed
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 256)		-- Arbitrary number, raise as needed
	SetMemoryPoolSize("ParticleEmitterObject", 2048)			-- Arbitrary number, raise as needed; Particle Effect memory
	SetMemoryPoolSize("RedShadingState", 64)					-- Arbitrary, raise as needed; Shader memory (?)
    
	-- Set spawning delay
    SetSpawnDelay(10.0, 0.25)
	
	-- Load BS1 world and layer(s)
	if Environment == "EA" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_lvl_pc\\BS1\\BS1.lvl;BS1_EA")
	else
		ReadDataFile("..\\..\\addon\\BS1\\data\\_lvl_pc\\BS1\\BS1.lvl;BS1_conquest")
	end
	
	-- Load ToD/weather assets (SKY, LGT, FX)
    LoadEnvironment(Environment)
	
	-- Advise AI to be mindful of tight spaces
    SetDenseEnvironment("true") -- SetUrbanEnvironment("true") also works

	-- Free up temporary variable
    Environment = nil
    
	-- Set sound parameters --
	-- Sounds to use for announcer vo
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
	-- Sounds to use for unit vo
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
	
	-- Load custom audio streams for this world
    OpenAudioStream("..\\..\\addon\\BS1\\data\\_lvl_pc\\SOUND\\BS1.lvl",  "BS1")
    OpenAudioStream("..\\..\\addon\\BS1\\data\\_lvl_pc\\SOUND\\BS1.lvl",  "BS1")

	-- Set voiceovers
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(CIS, "cisleaving")
    SetOutOfBoundsVoiceOver(REP, "repleaving")

	-- Set music playback
    SetAmbientMusic(REP, 1.0, "rep_cor_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_cor_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_cor_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_cor_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_cor_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_cor_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_cor_amb_victory")
    SetDefeatMusic (REP, "rep_cor_amb_defeat")
    SetVictoryMusic(CIS, "cis_cor_amb_victory")
    SetDefeatMusic (CIS, "cis_cor_amb_defeat")

	-- Set sound effects
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")

	-- Set entity death on entering death region
    AddDeathRegion("DEATH_REGION")
    
	-- Add opening and unit select camera positions
    AddCameraShot(0.995592, -0.062088, -0.070157, -0.004375, -13.880599, 117.294174, 125.611443);
	AddCameraShot(0.987853, -0.152717, 0.028361, 0.004384, 43.018829, 102.329865, -22.191162);
	AddCameraShot(0.695434, 0.013965, -0.718309, 0.014425, 86.394592, 102.080223, 93.668816);
	AddCameraShot(0.985292, -0.113937, 0.126510, 0.014629, 146.441269, 122.508514, 267.134552);
end
