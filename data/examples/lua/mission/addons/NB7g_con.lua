

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

    local ALL = 2
    local IMP = 1
    local ATT = 1
    local DEF = 2
    
function ScriptPostLoad()	   

	AICanCaptureCP("Team3", ATT, false)
	AICanCaptureCP("Team3", DEF, false)

	SetClassProperty("gun_inf_soldier", "CapturePosts", "0")
	SetClassProperty("gun_inf_rider", "CapturePosts", "0")
	SetClassProperty("gun_inf_defender", "CapturePosts", "0")

    cp1 = CommandPost:New{name = "duke"}
    cp2 = CommandPost:New{name = "overlook"}
    cp3 = CommandPost:New{name = "palace"}
    cp4 = CommandPost:New{name = "plaza"}
    cp5 = CommandPost:New{name = "resevoir"}
    cp6 = CommandPost:New{name = "rotunda"}
    cp7 = CommandPost:New{name = "terraces"}

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

    conquest:Start()

    EnableSPHeroRules()

 end

function ScriptInit()
	ReadDataFile("dc:Load\\load4.lvl")
	if ScriptCB_GetPlatform() == "PSP" then
			SetPSPModelMemory(0000000) -- adjust this number until your PSP map works and doesn't look weird, recommended between 3000000 and 6000000
			SetPSPClipper(1) -- no idea what this is, but PSP needs it
	elseif ScriptCB_GetPlatform() == "PS2" then
			SetPS2ModelMemory(0000000) -- adjust this number until your PS2 map works and doesn't look weird, recommended between 3000000 and 6000000
	end

    ReadDataFile("ingame.lvl")
	ReadDataFile("dc:Load\\load5.lvl")
    SetMaxFlyHeight(-15)
    SetMaxPlayerFlyHeight(-15)

	SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  

    ReadDataFile("sound\\yav.lvl;yav1gcw")

    ReadDataFile("dc:SIDE\\all.lvl", "all_hero_luke_jedi")
	ReadDataFile("dc:SIDE\\imp.lvl", "imp_hero_darthvader")

    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_inf_wookiee",
					"all_hover_combatspeeder")

    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
					"imp_hover_fightertank")

	ReadDataFile("SIDE\\tur.lvl", "tur_bldg_laser") 

    ReadDataFile("dc:SIDE\\gun.lvl",
						 "gun_inf_soldier",
						 "gun_inf_defender",
						 "gun_inf_rider")

	SetTeamName(3, "Gungans")
	AddUnitClass(3, "gun_inf_defender",3,3)
	AddUnitClass(3, "gun_inf_soldier",3,3)
	AddUnitClass(3, "gun_inf_rider",3,3)
	SetUnitCount(3, 9)
	SetTeamAsEnemy(3, 1)
	SetTeamAsEnemy(1, 3) 
	SetTeamAsFriend(2, 3)
	SetTeamAsFriend(3, 2)
	AddAIGoal(3,"Deathmatch",1000)

	ReadDataFile("dc:SIDE\\tga.lvl", "all_inf_markspersonjungle")
	ReadDataFile("dc:Load\\load6.lvl")
	SetupTeams{
		all = {
			team = ALL,
			units = 32,
			reinforcements = 150,
			soldier	= { "all_inf_rifleman",12,16},
			assault	= { "all_inf_rocketeer",4,8},
			engineer= { "all_inf_engineer",4,8},
			sniper	= { "all_inf_sniper",4,8},
			officer	= { "all_inf_officer",4,4},
			special	= { "all_inf_wookiee",4,4},
		},
		imp = {
			team = IMP,
			units = 32,
			reinforcements = 150,
			soldier	= { "imp_inf_rifleman",12,16},
			assault	= { "imp_inf_rocketeer",4,8},
			engineer= { "imp_inf_engineer",4,8},
			sniper	= { "imp_inf_sniper",4,8},
			officer	= { "imp_inf_officer",4,4},
			special	= { "imp_inf_dark_trooper",4,4},
		},
	}

    SetHeroClass(ALL, "all_hero_luke_jedi")
    SetHeroClass(IMP, "imp_hero_darthvader")

    ClearWalkers()
    AddWalkerType(0, 0) -- Droideka Count, should coincide with the CIS "special" slot in setup_teams{}
    AddWalkerType(1, 0) -- Vehicles with 1 pair of legs
    AddWalkerType(2, 0) -- Vehicles with 2 pair of legs
    AddWalkerType(3, 0) -- Vehicles with 3 pair of legs
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 8) -- Count of flyer vehicles + remote rockets
    SetMemoryPoolSize("EntityHover", 8) -- Count of hover vehicles
	SetMemoryPoolSize("EntityWalker", 8) -- Count of walker vehicles, should coincide with AddWalkerType()
	SetMemoryPoolSize("CommandHover", 0) -- Count of command hover vehicles
	SetMemoryPoolSize("CommandWalker", 0) -- Count of command walker vehicles
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32) -- Count of mannable turrets
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("FlagItem", 2) -- Count of carryable flag items

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:NB6\\NB6_Dark.lvl", "NB6_conquest")
    SetDenseEnvironment("false")

    SetNumFishTypes(3)
    SetFishType(0,1.0,"fish1")
	SetFishType(1,1.0,"fish2")
	SetFishType(2,1.0,"fish3")

    SetNumBirdTypes(3)
    SetBirdType(0,1.0,"bird1")
	SetBirdType(1,1.0,"bird2")
	SetBirdType(2,1.0,"bird3")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")
    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)
    SetOutOfBoundsVoiceOver(1, "impleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")
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

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

	AddCameraShot(0.875147, -0.035637, -0.482143, -0.019634, -266.027222, -43.484680, 107.307587);
	AddCameraShot(0.844148, -0.040415, -0.533972, -0.025565, -88.411659, -42.140137, 94.181847);
	AddCameraShot(0.787370, -0.030937, 0.615229, 0.024173, -16.766157, -42.488464, 90.253403);
	AddCameraShot(-0.007750, 0.000360, -0.998893, -0.046394, -30.257778, -42.488464, -99.422462);
	AddCameraShot(0.716042, -0.029500, 0.696842, 0.028709, 17.218943, -42.488464, -42.094337);
	AddCameraShot(0.977678, -0.118562, 0.172198, 0.020882, -73.778008, -26.648840, 9.746839);
	AddCameraShot(0.370138, -0.027272, -0.926066, -0.068233, -201.957520, -31.780275, -131.383530);
	AddCameraShot(0.198355, -0.028185, -0.969981, -0.137830, -275.180878, -31.145144, -145.480911);
	AddCameraShot(0.955436, -0.158113, 0.245940, 0.040700, -243.299789, -30.252705, -55.212437);
	AddCameraShot(-0.135691, 0.017505, -0.982455, -0.126742, -293.621613, -36.779041, -139.689621);
	AddCameraShot(0.697426, -0.098762, -0.702807, -0.099524, -400.363190, -30.602295, -96.146080);
	AddCameraShot(-0.313627, 0.042130, -0.940166, -0.126295, -278.855988, -31.446966, -9.391107);
	AddCameraShot(-0.000165, 0.000019, -0.993453, -0.114240, -355.424713, -31.047001, 4.679021);
	AddCameraShot(0.705568, -0.085904, -0.698260, -0.085014, -365.367981, -31.047001, 118.216972);
	AddCameraShot(0.799387, -0.052398, -0.597246, -0.039148, -360.738159, -44.646145, 184.083344);
	AddCameraShot(0.766069, -0.081448, 0.634003, 0.067407, -152.341705, -34.635635, 91.349594);

end