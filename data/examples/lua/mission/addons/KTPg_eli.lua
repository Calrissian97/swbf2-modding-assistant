
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("water_management")

function ScriptPostLoad()

	SetClassProperty("all_hero_luke_jedi", "UnitType", "Trooper")
	SetClassProperty("all_hero_hansolo_tat", "UnitType", "Pilot") -- we need him to build the armored turrets
	SetClassProperty("all_hero_leia", "UnitType", "Trooper") -- this prevents her from sitting around on her pampered ass
	SetClassProperty("all_hero_chewbacca", "UnitType", "Trooper")
	SetClassProperty("imp_hero_darthvader", "UnitType", "Trooper")
	SetClassProperty("imp_hero_emperor", "UnitType", "Trooper")
	SetClassProperty("imp_hero_bobafett", "UnitType", "Trooper")
	SetClassProperty("rep_hero_yoda", "UnitType", "Trooper")
	SetClassProperty("rep_hero_macewindu", "UnitType", "Trooper")
	SetClassProperty("rep_hero_anakin", "UnitType", "Trooper")
	SetClassProperty("rep_hero_aalya", "UnitType", "Trooper")
	SetClassProperty("rep_hero_kiyadimundi", "UnitType", "Trooper")
	SetClassProperty("rep_hero_obiwan", "UnitType", "Trooper")
	SetClassProperty("cis_hero_grievous", "UnitType", "Trooper")
	SetClassProperty("cis_hero_darthmaul", "UnitType", "Trooper")
	SetClassProperty("cis_hero_countdooku", "UnitType", "Trooper")
	SetClassProperty("cis_hero_jangofett", "UnitType", "Trooper")

	DisableBarriers("Barrier967")
	DisableBarriers("Barrier966")
	DisableBarriers("Barrier965")
	DisableBarriers("Barrier957")
	DisableBarriers("Barrier958")
	DisableBarriers("Barrier959")
	DisableBarriers("Barrier960")
	DisableBarriers("Barrier961")
	DisableBarriers("Barrier962")
	DisableBarriers("Barrier963")
	DisableBarriers("Barrier964")

	sealevel()

	AICanCaptureCP(1, "slavecp", "false")
	AICanCaptureCP(2, "slavecp", "false")

	SetProperty("killablelink1", "Team", "3")
	SetProperty("killablelink2", "Team", "3")
	SetProperty("killablelink3", "Team", "3")
	SetProperty("killablelink4", "Team", "3")
	SetProperty("killablelink5", "Team", "3")
	SetProperty("killablelink6", "Team", "3")
	SetProperty("killablelink7", "Team", "3")
	SetProperty("killablelink8", "Team", "3")
	SetProperty("killablelink9", "Team", "3")
	SetProperty("killablelink10", "Team", "3")
	SetProperty("killablelink11", "Team", "3")

	SetProperty("hidemeinlua1", "IsVisible", "0")
	SetProperty("hidemeinlua2", "IsVisible", "0")

    cp1 = CommandPost:New{name = "eli_cp1"}
    cp2 = CommandPost:New{name = "eli_cp2"}
    cp3 = CommandPost:New{name = "eli_cp3"}
    cp4 = CommandPost:New{name = "eli_cp4"}
    cp5 = CommandPost:New{name = "eli_cp5"}
    cp6 = CommandPost:New{name = "eli_cp6"}
    cp7 = CommandPost:New{name = "eli_cp7"}
    cp8 = CommandPost:New{name = "eli_cp8"}
    cp9 = CommandPost:New{name = "eli_cp9"}
    cp10 = CommandPost:New{name = "eli_cp10"}
    cp11 = CommandPost:New{name = "eli_cp11"}
    cp12 = CommandPost:New{name = "eli_cp12"}
    cp13 = CommandPost:New{name = "eli_cp13"}
    cp14 = CommandPost:New{name = "eli_cp14"}
    cp15 = CommandPost:New{name = "eli_cp15"}
	cp16 = CommandPost:New{name = "eli_cp16"}

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
    conquest:AddCommandPost(cp12)
    conquest:AddCommandPost(cp13)
    conquest:AddCommandPost(cp14)
    conquest:AddCommandPost(cp15)
	conquest:AddCommandPost(cp16)

    conquest:Start()

    EnableSPHeroRules()

	AddAIGoal(1,"Conquest",100);
	AddAIGoal(2,"Conquest",100);

end

function ScriptInit()

	ReadDataFile("dc:LOAD\\load1.lvl")

	rema_noHUD = true

	if ScriptCB_GetPlatform() == "PSP" then
			SetPSPModelMemory(0000000) -- adjust this number until your PSP map works and doesn't look weird, recommended between 3000000 and 6000000
			SetPSPClipper(1) -- no idea what this is, but PSP needs it
	elseif ScriptCB_GetPlatform() == "PS2" then
			SetPS2ModelMemory(0000000) -- adjust this number until your PS2 map works and doesn't look weird, recommended between 3000000 and 6000000
	end

    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",70)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",850)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",850) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",850)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",750)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",8000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",140)     -- should be ~1x #combo       -- should be ~1x #combo

	SetUberMode(1)
    ReadDataFile("ingame.lvl")
	ReadDataFile("dc:HUD\\hud_16x09.lvl")

	ReadDataFile("dc:LOAD\\load2.lvl")

	ALL = 1
	IMP = 2
	ATT = 1
	DEF = 2

    SetMaxFlyHeight(50)
	SetMaxPlayerFlyHeight(50)

    ReadDataFile("sound\\kam.lvl;kam1gcw")

    ReadDataFile("dc:SIDE\\all_eli.lvl",
                "all_hero_luke_jedi",
                "all_hero_hansolo_tat",
                "all_hero_leia",
                "all_hero_chewbacca")

    ReadDataFile("dc:SIDE\\imp_eli.lvl",
                "imp_hero_darthvader",
                "imp_hero_emperor",
                "imp_hero_bobafett")

    ReadDataFile("dc:SIDE\\rep_eli.lvl",
                "rep_hero_yoda",
                "rep_hero_macewindu",
                "rep_hero_anakin",
                "rep_hero_aalya",
                "rep_hero_kiyadimundi",
                "rep_hero_obiwan")

    ReadDataFile("dc:SIDE\\cis_eli.lvl",
                "cis_hero_grievous",
                "cis_hero_darthmaul",
                "cis_hero_countdooku",
                "cis_hero_jangofett")

	ReadDataFile("dc:LOAD\\load3.lvl")

    SetupTeams{
        hero = {
            team = ALL,
            units = 64,
                reinforcements = 250,
                soldier = { "all_hero_hansolo_tat",1,8},
                assault = { "all_hero_chewbacca",1,8},
                engineer= { "all_hero_luke_jedi",1,8},
                sniper  = { "rep_hero_obiwan",1,8},
                officer = { "rep_hero_yoda",1,8},
                special = { "rep_hero_macewindu",1,8},           
        },
    }   

    AddUnitClass(ALL,"all_hero_leia",1,8)
    AddUnitClass(ALL,"rep_hero_aalya",1,8)
    AddUnitClass(ALL,"rep_hero_kiyadimundi",1,8)

    SetupTeams{
        villain = {
            team = IMP,
            units = 64,
            reinforcements = 250,
                soldier = { "imp_hero_bobafett",1,8},
                assault = { "imp_hero_darthvader",1,8},
                engineer= { "cis_hero_darthmaul",1,8},
                sniper  = { "cis_hero_jangofett",1,8},
                officer = { "cis_hero_grievous",1,8},
                special = { "imp_hero_emperor",1,8},
        },
    }

    AddUnitClass(IMP, "rep_hero_anakin",1,8)
    AddUnitClass(IMP, "cis_hero_countdooku",1,8)

    AddWalkerType(0, 0)
    AddWalkerType(1, 0) -- Vehicles with 1 pair of legs
    AddWalkerType(2, 0) -- Vehicles with 2 pair of legs
    AddWalkerType(3, 0) -- Vehicles with 3 pair of legs
    
    local weaponCnt = 96
    SetMemoryPoolSize("Aimer", 1)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 320)
    SetMemoryPoolSize("ConnectivityGraphFollower", 23)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth",41)
    SetMemoryPoolSize("EntityDefenseGridTurret", 0)
    SetMemoryPoolSize("EntityDroid", 0)
	SetMemoryPoolSize("EntityFlyer", 8)
    SetMemoryPoolSize("EntityLight", 80, 80)
    SetMemoryPoolSize("EntityPortableTurret", 0)
    SetMemoryPoolSize("EntitySoundStream", 2)
    SetMemoryPoolSize("EntitySoundStatic", 45)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 120)
    SetMemoryPoolSize("MountedTurret", 32)
    SetMemoryPoolSize("Navigator", 23)
    SetMemoryPoolSize("Obstacle", 667)
    SetMemoryPoolSize("Ordnance", 80)
    SetMemoryPoolSize("ParticleEmitter", 512)
    SetMemoryPoolSize("ParticleEmitterInfoData", 512)
    SetMemoryPoolSize("PathFollower", 23)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TentacleSimulator", 24)
    SetMemoryPoolSize("TreeGridStack", 290)
    SetMemoryPoolSize("UnitAgent", 23)
    SetMemoryPoolSize("UnitController", 23)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:KTP\\KTP.lvl", "KTP_eli")
    SetDenseEnvironment("false")

    SetNumFishTypes(3)
    SetFishType(0,1.0,"fish1")
	SetFishType(1,1.0,"fish2")
	SetFishType(2,1.0,"fish3")

    SetNumBirdTypes(3)
    SetBirdType(0,1.0,"bird4")
	SetBirdType(1,1.0,"bird5")
	SetBirdType(2,1.0,"bird1")

    ScriptCB_EnableHeroMusic(1)
    ScriptCB_EnableHeroVO(1)

    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
	SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
	SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)
	SetOutOfBoundsVoiceOver(1, "allleaving")
	SetOutOfBoundsVoiceOver(2, "impleaving")
	SetAmbientMusic(ALL, 1.0, "all_kam_amb_start",  0,1)
	SetAmbientMusic(ALL, 0.8, "all_kam_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_kam_amb_end",    2,1)
	SetAmbientMusic(IMP, 1.0, "imp_kam_amb_start",  0,1)
	SetAmbientMusic(IMP, 0.8, "imp_kam_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_kam_amb_end",    2,1)
	SetVictoryMusic(ALL, "all_kam_amb_victory")
	SetDefeatMusic (ALL, "all_kam_amb_defeat")
	SetVictoryMusic(IMP, "imp_kam_amb_victory")
	SetDefeatMusic (IMP, "imp_kam_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    SetAttackingTeam(ATT)

	AddCameraShot(0.865172, -0.123637, 0.481108, 0.068752, 46.863567, 14.641465, 168.983292);
	AddCameraShot(0.828072, -0.105089, -0.546303, -0.069330, -50.480949, 14.641465, 158.057480);
	AddCameraShot(0.874161, -0.116863, 0.467210, 0.062459, 98.498863, 14.914258, 89.953285);
	AddCameraShot(0.695029, -0.154741, 0.685352, 0.152587, 107.164467, 31.825745, 42.687305);
	AddCameraShot(0.974988, -0.119491, -0.186012, -0.022797, 28.154608, 27.071613, 29.730799);
	AddCameraShot(0.267938, -0.040896, -0.951547, -0.145238, -82.764870, 8.984087, -80.045586);
	AddCameraShot(-0.412710, 0.159163, -0.836778, -0.322707, 49.075672, 25.601568, -82.894180);
	AddCameraShot(0.301346, -0.067694, -0.927983, -0.208462, -102.925713, 25.601568, -37.527004);
	AddCameraShot(0.897620, -0.163367, -0.402761, -0.073302, -96.215782, 13.703372, 90.227386);
	AddCameraShot(-0.009669, 0.001157, -0.992870, -0.118805, -4.956502, 35.088135, -24.556435);
	AddCameraShot(0.920885, -0.090229, 0.377442, 0.036982, 45.493652, 11.739380, -141.632660);
	AddCameraShot(0.923230, -0.092234, -0.371166, -0.037081, -76.636307, 11.739380, -132.129532);
	AddCameraShot(-0.414299, 0.006737, -0.909996, -0.014798, -28.144886, 10.259871, -195.268356);
	AddCameraShot(0.684844, -0.179748, 0.683038, 0.179274, -45.369572, 13.751266, -176.160416);
	AddCameraShot(-0.008550, 0.002227, -0.967683, -0.252015, 23.990515, 14.028867, -186.547867);
	AddCameraShot(0.974705, -0.186998, 0.120210, 0.023062, -2.078470, 28.103676, -202.773849);
	AddCameraShot(0.065915, -0.010414, -0.985546, -0.155710, -9.497380, 28.103676, -243.589355);
	AddCameraShot(0.696607, -0.075504, -0.709315, -0.076881, -187.765259, 35.531013, 36.082569);

end