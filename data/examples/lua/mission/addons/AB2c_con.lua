
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 
ScriptCB_DoFile("hero_management")
ScriptCB_DoFile("settings_management")
ScriptCB_DoFile("world_management")

    REP = 1;
    CIS = 2;
    ATT = REP;
    DEF = CIS;

function ScriptPostLoad()

	cp1team = math.random(2)
		if cp1team == 1 then
			SetProperty("cp1", "Team", "1")
		elseif cp1team == 2 then
			SetProperty("cp1", "Team", "2")
		end

	cp2team = math.random(2)
		if cp2team == 1 then
			SetProperty("cp2", "Team", "1")
		elseif cp2team == 2 then
			SetProperty("cp2", "Team", "2")
		end

	cp3team = math.random(2)
		if cp3team == 1 then
			SetProperty("cp3", "Team", "1")
		elseif cp3team == 2 then
			SetProperty("cp3", "Team", "2")
		end

	cp4team = math.random(2)
		if cp4team == 1 then
			SetProperty("cp4", "Team", "1")
		elseif cp4team == 2 then
			SetProperty("cp4", "Team", "2")
		end

	ab2_wld_stuff()
	unkillable_cps()

    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
	cp5 = CommandPost:New{name = "cmdturret1"}
    cp6 = CommandPost:New{name = "outercp1"}
    cp7 = CommandPost:New{name = "outercp2"}
    cp8 = CommandPost:New{name = "outercp3"}
    cp9 = CommandPost:New{name = "outercp4"}
    cp10 = CommandPost:New{name = "outercp5"}
    cp11 = CommandPost:New{name = "outercp6"}

    conquest = ObjectiveConquest:New{
					teamATT = ATT,
					teamDEF = DEF, 
                    textATT = "game.modes.con", 
                    textDEF = "game.modes.con2",
                    multiplayerRules = true}

    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)  
    conquest:AddCommandPost(cp9)
    conquest:AddCommandPost(cp10)
    conquest:AddCommandPost(cp11)     

    conquest:Start()

    EnableSPHeroRules()

	AddAIGoal(3, "deathmatch", 100)

 end

function ScriptInit()

	rema_noHUD = true

	ReadDataFile("dc:LOAD\\AB2_1.LVL")

	if ScriptCB_GetPlatform() == "PSP" then
			SetPSPModelMemory(0000000) -- adjust this number until your PSP map works and doesn't look weird, recommended between 3000000 and 6000000
			SetPSPClipper(1) -- no idea what this is, but PSP needs it
	elseif ScriptCB_GetPlatform() == "PS2" then
			SetPS2ModelMemory(0000000) -- adjust this number until your PS2 map works and doesn't look weird, recommended between 3000000 and 6000000
	end

	SetUberMode(1);
    ReadDataFile("ingame.lvl")
	ReadDataFile("dc:HUD\\hud_16x09.lvl")
	ReadDataFile("dc:LOAD\\AB2_2.LVL")

    SetMaxFlyHeight(150)
    SetMaxPlayerFlyHeight(150)

    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    ReadDataFile("sound\\yav.lvl;yav1cw")

	ReadDataFile("dc:SIDE\\com.lvl", "ab2_item_water_mine", "ab2_item_powerup_poison", "ab2_item_powerup_shocker")

    ReadDataFile("dc:SIDE\\rep.lvl",
						 "rep_inf_ep3_rifleman",
						 "rep_inf_ep3_rocketeer",
						 "rep_inf_ep3_engineer",
						 "rep_inf_ep3_sniper",
						 "rep_inf_ep3_officer",
						 "rep_inf_ep3_jettrooper",
						 "rep_hover_fightertank",
						 "rep_hover_barcspeeder",
						 "rep_hero_anakin",
						 "rep_hero_cloakedanakin",
						 "rep_hero_kiyadimundi",
						 "rep_hero_macewindu",
						 "rep_hero_obiwan",
						 "rep_hero_yoda",
						 "rep_hero_aalya")

    ReadDataFile("dc:SIDE\\cis.lvl",
						 "cis_inf_rifleman",
						 "cis_inf_rocketeer",
						 "cis_inf_engineer",
						 "cis_inf_sniper",
						 "cis_inf_officer",
						 "cis_inf_droideka",
						 "cis_hover_aat",
						 "cis_hover_stap",
						 "cis_hero_countdooku",
						 "cis_hero_jangofett",
						 "cis_hero_darthmaul")

	ReadDataFile("dc:SIDE\\snw.lvl", "snw_inf_wampa")
	ReadDataFile("dc:SIDE\\geo.lvl", "geo_inf_acklay")
	ReadDataFile("dc:LOAD\\AB2_3.LVL")

	SetupTeams{
		rep = {
			team = REP,
			units = 64,
			reinforcements = 300,
			soldier  = { "rep_inf_ep3_rifleman",5,11},
			assault  = { "rep_inf_ep3_rocketeer",5,11},
			engineer = { "rep_inf_ep3_engineer",5,11},
			sniper   = { "rep_inf_ep3_sniper",5,11},
			officer  = { "rep_inf_ep3_officer",5,11},
			special  = { "rep_inf_ep3_jettrooper",5,11},
	        
		},
		cis = {
			team = CIS,
			units = 64,
			reinforcements = 300,
			soldier  = { "cis_inf_rifleman",5,11},
			assault  = { "cis_inf_rocketeer",5,11},
			engineer = { "cis_inf_engineer",5,11},
			sniper   = { "cis_inf_sniper",5,11},
			officer  = { "cis_inf_officer",5,11},
			special  = { "cis_inf_droideka",5,11},
		}
	}

		if ScriptCB_InMultiplayer() then
			SetHeroClass(1, "rep_hero_aalya")
			SetHeroClass(2, "cis_hero_darthmaul")
		elseif not ScriptCB_InMultiplayer() then
			rephero()
			cishero()
		end

		cq_extra_tickets()

    AddWalkerType(0, 11) -- Droideka Count, should coincide with the CIS "special" slot in setup_teams{}
    AddWalkerType(1, 0) -- Vehicles with 1 pair of legs
    AddWalkerType(2, 0) -- Vehicles with 2 pair of legs
    AddWalkerType(3, 0) -- Vehicles with 3 pair of legs
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 128)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 128)
	SetMemoryPoolSize("EntityFlyer", 64) -- Count of flyer vehicles + remote rockets
    SetMemoryPoolSize("EntityHover", 64) -- Count of hover vehicles
	SetMemoryPoolSize("EntityWalker", 64) -- Count of walker vehicles, should coincide with AddWalkerType()
	SetMemoryPoolSize("CommandHover", 0) -- Count of command hover vehicles
	SetMemoryPoolSize("CommandWalker", 0) -- Count of command walker vehicles
    SetMemoryPoolSize("EntityLight", 256)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 64) -- Count of mannable turrets
	SetMemoryPoolSize("Navigator", 512)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("SoldierAnimation", 512)
	SetMemoryPoolSize("EntityMine", 128)
	SetMemoryPoolSize("AcklayData", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("FlagItem", 2) -- Count of carryable flag items

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:AB2\\AB2.lvl", "AB2_conquest")

	ScriptCB_RemoveTexture("map_mask")
	ReadDataFile("dc:LOAD\\AB2_4.LVL")

    SetDenseEnvironment("false")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")
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
    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

	AddCameraShot(0.108911, -0.010497, -0.989411, -0.095360, -313.653473, 10.545284, -174.794907);
	AddCameraShot(0.601339, 0.015513, 0.798578, -0.020601, -103.263824, 4.767753, -160.524536);
	AddCameraShot(0.441790, -0.055355, -0.888462, -0.111323, -205.988113, 17.719975, -118.429893);
	AddCameraShot(0.983046, -0.087666, 0.160406, 0.014305, 99.838654, 7.059903, -50.701031);
	AddCameraShot(0.623040, -0.033200, -0.780378, -0.041585, -5.008909, 9.350779, 122.205238);
	AddCameraShot(0.869969, -0.112794, 0.476048, 0.061721, 40.521610, 29.373150, 352.754333);
	AddCameraShot(0.593911, -0.083913, -0.792274, -0.111939, 65.753731, 14.138998, 280.011749);
	AddCameraShot(0.685284, -0.050275, -0.724591, -0.053159, -152.618744, 5.323565, 243.500534);
	AddCameraShot(0.635877, -0.076908, -0.762393, -0.092210, -229.131027, 27.598173, 171.188110);
	AddCameraShot(-0.004186, 0.000063, -0.999876, -0.015151, -345.378937, 5.442807, 217.540100);
	AddCameraShot(0.914736, -0.086405, -0.392957, -0.037118, -200.105515, 13.795705, 107.707794);
	AddCameraShot(0.543014, 0.021254, 0.838813, -0.032832, -135.214584, 5.975453, 61.763607);
	AddCameraShot(0.680865, -0.139275, 0.704458, 0.144101, -193.450851, 10.103094, 135.947296);
	AddCameraShot(-0.240166, 0.041078, -0.955980, -0.163510, -290.263092, 29.028078, 34.880203);
	AddCameraShot(0.238598, -0.137452, -0.833004, -0.479878, -358.822662, 124.572678, 48.499493);
	AddCameraShot(0.805635, -0.141745, 0.566503, 0.099672, -113.574677, 9.956266, 26.113916);
	AddCameraShot(0.006007, -0.001057, -0.984854, -0.173278, -143.886215, 9.438190, -38.240601);
	AddCameraShot(0.966816, -0.138948, -0.212202, -0.030497, -318.176270, 9.438190, -82.192276);
	AddCameraShot(0.521099, -0.072360, -0.842341, -0.116968, -91.178459, 25.367990, 106.848511);
	AddCameraShot(-0.411288, 0.065920, -0.897662, -0.143875, 36.610535, 32.711952, 81.241203);

end