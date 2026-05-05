-- Initializes the FO GC!
print("Entered ifs_freeform_init_ANF.lua")

-- Read our utility script to add its functions!
ReadDataFile("..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\mission.lvl")
ScriptCB_DoFile("ANF_Utilities") 

ifs_freeform_init_ANF = function(this, IMP, ALL)

	-- common init
	ifs_freeform_init_common(this)

	-- default victory condition (take all planets)
	this:SetVictoryPlanetLimit(nil)
	
	-- associate codes with teams
	this.teamCode = {
		[IMP] = "imp",
		[ALL] = "all"
	}
	
	-- Call for the FO Initialization
	this.Setup = function(this)
		print("ifs_freeform_init_ANF: Setup()")
		
		SetMemoryPoolSize("ParticleTransformer::PositionTr", 512)
		SetMemoryPoolSize("ParticleTransformer::SizeTransf", 512)
		SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1024)
		SetMemoryPoolSize("ParticleEmitterObject", 32)
		SetMemoryPoolSize("ParticleEmitterInfoData", 256)
		SetMemoryPoolSize("ParticleEmitter", 256)
		
		-- Read CGC Content
		ReadDataFile("..\\..\\addon\\ZZZ\\data\\_LVL_PC\\SIDE\\FO_ART.lvl",
			"FO_Weapons",
			"FO_inf_heavy_stormtrooper",
			"FO_inf_Officer",
			"FO_special_jet_trooper",
			"FO_special_elite_stormtrooper",
			"FO_special_flametrooper",
			"FO_inf_Space")
		
		ReadDataFile("..\\..\\addon\\ZZZ\\data\\_LVL_PC\\SIDE\\RES_ART.lvl",
			"RES_Weapons",
			"RES_inf_soldier",
			"RES_inf_vanguard",
			"RES_inf_sniper",
			"RES_inf_technician",
			"RES_inf_officer",
			"RES_special_jet_trooper",
			"RES_special_spy",
			"RES_special_wookie",
			"RES_inf_Space")
		
		----------------------------------------------------------------------------------------------
		DeleteEntity("kam_star")
		DeleteEntity("geo_star")
		--DeleteEntity("tantive")
		DeleteEntity("end_star")
		DeleteEntity("hot_star")
		DeleteEntity("star16")
		
		SetEntityMatrix("dea",GetEntityMatrix("star19"))
		SetEntityMatrix("dea_camera", GetEntityMatrix("star19"))
		SetEntityMatrix("dea_fleet1", GetEntityMatrix("star19_fleet1"))
		SetEntityMatrix("dea_fleet2", GetEntityMatrix("star19_fleet2"))
		CreateEntity(GetEntityClass("dea_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.6, GetEntityMatrix("dea_camera")), "dea2_camera");
		CreateEntity(GetEntityClass("dea_fleet1"),
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.2, -0.1, GetEntityMatrix("dea_fleet1")), "dea2_fleet1"); -- MonCalaShip
		CreateEntity(GetEntityClass("dea_fleet2"),
		CreateMatrix(2.5, 0.0, 1.0, 0.0, 0.0, 0.45, 0.15, GetEntityMatrix("dea_fleet2")), "dea2_fleet2"); -- StarDestroyer
		DeleteEntity("dea_fleet1")
		DeleteEntity("dea_fleet2")
		DeleteEntity("dea_camera")
		CreateEntity(GetEntityClass("dea2_camera"), GetEntityMatrix("dea2_camera"), "dea_camera");
		CreateEntity(GetEntityClass("dea2_fleet1"), GetEntityMatrix("dea2_fleet1"), "dea_fleet1");
		CreateEntity(GetEntityClass("dea2_fleet2"), GetEntityMatrix("dea2_fleet2"), "dea_fleet2");
		DeleteEntity("dea2_fleet1")
		DeleteEntity("dea2_fleet2")
		DeleteEntity("dea2_camera")
		DeleteEntity("star19")
		DeleteEntity("star19_fleet1")
		DeleteEntity("star19_fleet2")
		----------------------------------------------------------------------------------------------
		
		SetEntityMatrix("tantive",GetEntityMatrix("star17"))
		CreateEntity(GetEntityClass("tantive"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 25.0, 0.0, 50.0, GetEntityMatrix("star17")), "tan");
		CreateEntity(GetEntityClass("dea_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 25.0, 0.0, 49.7, GetEntityMatrix("star17")), "tan_camera");
		CreateEntity(GetEntityClass("dea_fleet1"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 25.0, 0.0, 50.0, GetEntityMatrix("star17")), "tan_fleet1");
		CreateEntity(GetEntityClass("dea_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 25.0, 0.0, 50.0, GetEntityMatrix("star17")), "tan_fleet2");
		DeleteEntity("tantive")
		
		CreateEntity(GetEntityClass("tan"), 
		CreateMatrix(1.1, 0.0, 1.0, 0.0, 0.0, 0.0, 0.25, GetEntityMatrix("tan")), "tantive");
		CreateEntity(GetEntityClass("tan_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("tan_camera")), "tantive_camera");
		CreateEntity(GetEntityClass("tan_fleet1"), 
		CreateMatrix(2.0, 0.0, 1.0, 0.0, 0.0, -0.02, 0.0, GetEntityMatrix("tan_fleet1")), "tantive_fleet1");
		CreateEntity(GetEntityClass("tan_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("tan_fleet2")), "tantive_fleet2");
		DeleteEntity("tan")
		DeleteEntity("tan_camera")
		DeleteEntity("tan_fleet1")
		DeleteEntity("tan_fleet2")
		----------------------------------------------------------------------------------------------
		CreateEntity(GetEntityClass("end"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star20")), "end2");
		CreateEntity(GetEntityClass("end_system"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star20")), "end2_system");
		CreateEntity(GetEntityClass("end_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star20_camera")), "end2_camera");
		CreateEntity(GetEntityClass("end_fleet1"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star20_fleet1")), "end2_fleet1");
		CreateEntity(GetEntityClass("end_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star20_fleet2")), "end2_fleet2");
		CreateEntity(GetEntityClass("star20"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end")), "star202");
		CreateEntity(GetEntityClass("star20_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end_camera")), "star202_camera");
		CreateEntity(GetEntityClass("star20_fleet1"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end_fleet1")), "star202_fleet1");
		CreateEntity(GetEntityClass("star20_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end_fleet2")), "star202_fleet2");
		DeleteEntity("end")
		DeleteEntity("end_camera")
		DeleteEntity("end_system")
		DeleteEntity("end_fleet1")
		DeleteEntity("end_fleet2")
		DeleteEntity("star20")
		DeleteEntity("star20_camera")
		DeleteEntity("star20_fleet1")
		DeleteEntity("star20_fleet2")
		
		CreateEntity(GetEntityClass("end2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end2")), "end");
		CreateEntity(GetEntityClass("end2_system"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, GetEntityMatrix("end2_system")), "end_system");
		CreateEntity(GetEntityClass("end2_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, GetEntityMatrix("end2")), "end_camera");
		CreateEntity(GetEntityClass("end2_fleet1"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end2_fleet1")), "end_fleet1");
		CreateEntity(GetEntityClass("end2_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("end2_fleet2")), "end_fleet2");
		CreateEntity(GetEntityClass("star202"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star202")), "star20");
		CreateEntity(GetEntityClass("star202_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star202_camera")), "star20_camera");
		CreateEntity(GetEntityClass("star202_fleet1"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star202_fleet1")), "star20_fleet1");
		CreateEntity(GetEntityClass("star202_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityMatrix("star202_fleet2")), "star20_fleet2");
		DeleteEntity("end2")
		DeleteEntity("end2_camera")
		DeleteEntity("end2_system")
		DeleteEntity("end2_fleet1")
		DeleteEntity("end2_fleet2")
		DeleteEntity("star202")
		DeleteEntity("star202_camera")
		DeleteEntity("star202_fleet1")
		DeleteEntity("star202_fleet2")
		----------------------------------------------------------------------------------------------
		this.spaceValue = {
			victory = 100, defeat = 25,
		}
		
		-- associate names with teams
		this.teamName = {
			[0] = "",
			[ALL] = "common.sides.all.name",
			[IMP] = "common.sides.imp.name" 
		}
		
		-- associate names with team bases
		this.baseName = {
			[ALL] = "ifs.freeform.base.res",
			[IMP] = "ifs.freeform.base.fo"
		}
		
		-- associate names with team fleets
		this.fleetName = {
			[0] = "",
			[ALL] = "ifs.freeform.fleet.res",
			[IMP] = "ifs.freeform.fleet.fo"
		}
		
		-- associate entity class with team fleets
		this.fleetClass = {
			[ALL] = "gal_prp_moncalamaricruiser",
			[IMP] = "gal_prp_stardestroyer"
		}
		
		-- associate icon textures with team fleets
		this.fleetIcon = {
			[ALL] = "all_fleet_normal_icon",
			[IMP] = "FO_fleet_normal"
		}
		this.fleetStroke = {
			[ALL] = "all_fleet_normal_stroke",
			[IMP] = "FO_fleet_stroke"
		}
		
		-- set the explosion effect for each team
		this.fleetExplosion = {
			[ALL] = "gal_sfx_moncalamaricruiser_exp",
			[IMP] = "gal_sfx_stardestroyer_exp"
		}
		
		-- team base planets
		this.planetBase = {
			[ALL] = "cor", -- cor
			[IMP] = "pol", -- pol
		}
		
		-- team potential starting locations
		this.planetStart = {
			[ALL] = { "myg", "cor", "kas" },
			[IMP] = { "pol", "mus", "uta" },
		}
		
		-- AI able to purchase
		ifs_purchase_tech_cards = {
			[1] = {
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				true
			},
			[2] = {
				false,
				true,
				true,
				true,
				true,
				true,
				true,
				true,
				false
			}
		}
		-- Purchasable Bonuses
		ifs_purchase_tech_table_freeform = {
			{
				mesh = "gal_shell_surveillance",
				name = "surveillance",
				cost = { [false] = 40, [true] = 40 },
				bonus = "sensor_array",
				hints = {
					{ "ctf$", 3 },
					{ "^dea", 1 },
					{ "^pol", 1 },
					{ "^spa", 1 },
					{ "^tan", 1 },
					{ ".*", 2 },
				}
			},	
			--[[{
				mesh = "gal_shell_adrenaline", --"gal_shell_adrenaline",
				name = "adrenaline",
				cost = { [false] = 100, [true] = 20 },
				bonus = "energy_boost",
				hints = {
					-- great for CTF, okay for indoor maps, good otherwise
					{ "ctf$", 3 },
					{ "^dea", 1 },
					{ "^pol", 1 },
					{ "^spa", 1 },
					{ "^tan", 1 },
					{ ".*", 2 },
				}
			},
			--]]
			{
				mesh = "gal_shell_supply_cache",
				name = "supply_cache",
				cost = { [false] = 100, [true] = 40 },
				bonus = "supplies",
				hints = {
					-- good on indoor levels, okay on other levels
					{ "^tan", 2 },
					{ "^pol", 2 },
					{ "^dea", 2 },
					{ "^kam", 2 },
					{ "^mus", 2 },
					{ "^nab", 2 },
					{ ".*", 1 }
				}
			},	
			{
				mesh = "gal_shell_fo_reinforcements", --"gal_shell_reinforcements",
				name = "reinforcement",
				cost = { [false] = 100, [true] = 60 },
				bonus = "garrison",
				hints = {
					-- great for conquest, useless otherwise
					{ "con$", 3 },
					{ ".*", 0 },
				}
			},
			{
				mesh = "gal_shell_defense_grid",
				name = "defense_grid",
				cost = { [false] = 100, [true] = 60 },
				bonus = "autoturrets",
				hints = {
					-- great for conquest, good for indoor maps, okay otherwise
					{ "con$", 3 },
					{ "^dea", 2 },
					{ "^pol", 2 },
					{ "^spa", 2 },
					{ "^tan", 2 },
					{ ".*", 1 }
				}
			},
			{
				mesh = "gal_shell_bacta_refinery",
				name = "bacta_refinery",
				cost = { [false] = 100, [true] = 80 },
				bonus = "bacta_tanks",
				hints = {
					-- okay for space, great for conquest, good otherwise
					{ "^spa", 1 },
					{ "con$", 3 },
					{ ".*", 2 }
				}
			},
			{
				mesh = "gal_shell_advanced_fo_armor", --"gal_shell_advanced_armor",
				name = "advanced_armor",
				cost = { [false] = 100, [true] = 80 },
				bonus = "combat_shielding",
				hints = {
					-- good in space, great otherwise
					{ "^spa", 2 },
					{ ".*", 3 }
				}
			},
			{
				mesh = "gal_shell_espionage",
				name = "espionage",
				cost = { [false] = 100, [true] = 80 },
				bonus = "sabotage",
				hints = {
					-- great in space, good on levels with big vehicles, okay on levels with small vehicles, useless otherwise
					{ "^spa", 3 },
					{ "^geo", 2 },
					{ "^hot", 2 },
					{ "^kas", 2 },
					{ "^uta", 2 },
					{ "^fel", 1 },
					{ "^end", 1 },
					{ "^nab", 1 },
					{ "^yav", 1 },
					{ ".*", 0 }
				}
			},
			{
				mesh = "gal_shell_blaster_amplification",
				name = "blaster_amplification",
				cost = { [false] = 100, [true] = 100 },
				bonus = "advanced_blasters",
				hints = {
					-- good in space, great otherwise
					{ "^spa", 2 },
					{ ".*", 3 }
				}
			},
			{
				mesh = "gal_shell_res_leadership", --gal_shell_fo_leadership
				name = "leadership",
				cost = { [false] = 100, [true] = 100 },
				bonus = "leader",
				hints = {
					-- useless in space, great in conquest, good otherwise
					{ "^spa", 0 },
					{ "con$", 3 },
					{ ".*", 2 }
				}
			},
		}

		-- Custom anim sets by yours truly!
		pistol_anim_set = {
			animbanks = { "human_0", "human_3" },
			unselected = { upper = "human_tool_crouch_idle_emote", lower = "human_rifle_crouch_idle_takeknee_lower" },
			select_start = "human_pistol_stand_walkforward",
			select_loop = { upper = "human_pistol_stand_walkforward", lower = "human_pistol_standalert_walkforward_full" },
		}

		rifle_anim_set = {
			animbanks = { "human_0", "human_3" },
			unselected = { upper = "human_rifle_crouch_idle_emote_full", lower = "human_rifle_crouch_idle_takeknee_lower" },
			select_start = "human_rifle_stand_walkforward",
			select_loop = { upper = "human_rifle_stand_walkforward", lower = "human_pistol_standalert_walkforward_full" },
		}

		bazooka_anim_set = {
			animbanks = { "human_0", "human_2", "human_3"},
			unselected = { upper = "human_bazooka_crouch_idle_emote", lower = "human_rifle_crouch_idle_takeknee_lower" },
			select_start = "human_bazooka_stand_walkforward",
			select_loop = { upper = "human_bazooka_stand_walkforward", lower = "human_pistol_standalert_walkforward_full" },
		}

		marksperson_anim_set = {
			animbanks = { "human_0", "human_3" },
			unselected = { upper = "human_rifle_crouch_idle_emote_full", lower = "human_rifle_crouch_idle_takeknee_lower" },
			select_start = "human_rifle_standalert_walkforward",
			select_loop = { upper = "human_rifle_standalert_walkforward", lower = "human_pistol_standalert_walkforward_full" },
		}

		jet_anim_set = {
			animbanks = { "human_0", "human_1" },
			unselected = { upper = "human_rifle_crouch_idle_emote_full", lower = "human_rifle_crouch_idle_takeknee_lower" },
			select_start = "human_rifle_jetpack_hover",
			select_loop = { upper = "human_rifle_jetpack_hover", lower = "human_rifle_jetpack_hover" },
		}

		-- Defines what units are purchaseable
		ifs_purchase_unit_types = {"soldier", "assault", "sniper", "engineer", "officer", "special", "elite", "advanced", "pilot", "marine"}
		-- Defines the cost for each unit
		ifs_purchase_unit_cost = {
			soldier = 0,
			pilot = 0,
			marine = 120,
			assault = 100,
			sniper = 120,
			engineer = 100,
			officer = 140,
			special = 160,
			elite = 180,
			advanced = 200,
		}

		-- predefined teams for freeform, can be overidden
		ifs_purchase_team_table = {
			all = {
				--file = "..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\SIDE\\RES_ART.lvl",
				
				classes = {
					soldier = {
						name = "entity.RES.inf_soldier",
						info = "ifs.freeform.purchase.military.sides.all.soldier",
						sound = "mtg_all_unit_name_rifleman",
						body = "RES_inf_Soldier",
						weapon = "RES_weap_inf_EL-16_HFE",
						anim_set = rifle_anim_set
					},
					assault = {
						name = "entity.RES.inf_vanguard",
						info = "ifs.freeform.purchase.military.sides.all.vanguard",
						sound = "mtg_all_unit_name_rocketeer",
						body = "RES_inf_Assault",
						weapon = "re_weap_hh-15_projectile_launcher",
						anim_set = bazooka_anim_set
					},
					sniper = {
						name = "entity.RES.inf_sniper",
						info = "ifs.freeform.purchase.military.sides.all.sharpshooter",
						sound = "mtg_all_unit_name_sniper",
						body = "RES_inf_sniper",
						weapon = "re_weap_e-17d_sniper_rifle",
						anim_set = marksperson_anim_set
					},
					engineer = {
						name = "entity.RES.inf_technician",
						info = "ifs.freeform.purchase.military.sides.all.technician",
						sound = "mtg_all_unit_name_engineer",
						body = "RES_technician",
						weapon = "RES_weap_inf_EL-16_HFE",
						anim_set = rifle_anim_set
					},
					officer = {
						name = "entity.RES.inf_officer",
						info = "ifs.freeform.purchase.military.sides.all.commandingofficer",
						sound = "mtg_all_unit_name_rifleman",
						body = "RES_inf_Officer",
						weapon = "RES_weap_GLIE-44",
						anim_set = pistol_anim_set
					},
					special = {
						name = "entity.RES.special_jet_trooper",
						info = "ifs.freeform.purchase.military.sides.all.jetty",
						sound = "mtg_all_unit_name_rifleman",
						body = "RES_Jet_Trooper",
						weapon = "re_weap_e-17d_sniper_rifle",
						anim_set = jet_anim_set
					},
					elite = {
						name = "entity.RES.special_spy",
						info = "ifs.freeform.purchase.military.sides.all.spy",
						sound = "mtg_all_unit_name_officer",
						body = "RES_inf_Spy",
						weapon = "re_weap_e-17d_sniper_rifle",
						anim_set = rifle_anim_set
					},
					advanced = {
						name = "entity.RES.special_wookie",
						info = "ifs.freeform.purchase.military.sides.all.special",
						sound = "mtg_all_unit_name_special",
						body = "res_inf_wookie",
						weapon = "res_weap_bowcaster",
						anim_set = rifle_anim_set
					},
					pilot = {
						name = "entity.RES.inf_pilot",
						info = "ifs.freeform.purchase.military.sides.all.spacepilot",
						sound = "mtg_all_unit_name_pilot",
						body = "RES_pilot",
						weapon = "RES_weap_GLIE-44",
						anim_set = pistol_anim_set
					},
					marine = {
						name = "entity.RES.special_sf_pilot",
						info = "ifs.freeform.purchase.military.sides.all.marine",
						sound = "mtg_all_unit_name_marine",
						body = "RES_pilot_SF",
						weapon = "RES_weap_GLIE-44",
						anim_set = pistol_anim_set
					},
				}
			},		
			imp = {
				--file = "..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\SIDE\\FO_ART.lvl",

				classes = {
					soldier = {
						name = "entity.fo.inf_stormtrooper",
						info = "level.ANF.GC.fo_rifleman",
						sound = "mtg_imp_unit_name_rifleman",
						body = "FO_Stormtrooper",
						weapon = "fo_weap_f-11d_blaster_rifle",
						anim_set = rifle_anim_set
					},
					assault = {
						name = "entity.fo.inf_heavy_stormtrooper",
						info = "level.ANF.GC.fo_rocketeer",
						sound = "mtg_imp_unit_name_rocketeer",
						body = "FO_Stormtrooper_Heavy",
						weapon = "fo_weap_fwmb-10_repeating_blaster",
						anim_set = rifle_anim_set
					},
					engineer =  {
						name = "entity.fo.inf_sergeant",
						info = "level.ANF.GC.fo_sniper",
						sound = "mtg_imp_unit_name_sniper",
						body = "FO_Stormtrooper_Pauldron_Black",
						weapon = "fo_weap_e-11s_sniper_rifle",
						anim_set = marksperson_anim_set
					},
					sniper =   {
						name = "entity.fo.inf_officer",
						info = "level.ANF.GC.fo_officer",
						sound = "mtg_imp_unit_name_officer",
						body = "FO_Stormtrooper_Pauldron",
						weapon = "FO_weap_inf_SE-44C_B",
						anim_set = pistol_anim_set
					},
					officer = {
						name = "entity.fo.inf_squad_leader",
						info = "level.ANF.GC.squad_leader",
						sound = "mtg_imp_unit_name_officer",
						body = "FO_Stormtrooper_Pauldron_White",
						weapon = "fo_weap_f-11d_blaster_rifle",
						anim_set = rifle_anim_set
					},
					special = {
						name = "entity.fo.special_jet_trooper",
						info = "level.ANF.GC.fo_jetty",
						sound = "mtg_imp_unit_name_special",
						body = "FO_Jet_Trooper",
						weapon = "fo_weap_e-11s_sniper_rifle",
						anim_set = jet_anim_set
					},
					elite = {
						name = "entity.fo.special_elite_stormtrooper",
						info = "level.ANF.GC.elite",
						sound = "mtg_imp_unit_name_special",
						body = "FO_Elite_Stormie",
						weapon = "fo_weap_f-11d_blaster_rifle",
						anim_set = rifle_anim_set
					},
					advanced = {
						name = "entity.fo.special_flametrooper",
						info = "level.ANF.GC.flamey",
						sound = "mtg_imp_unit_name_special",
						body = "fo_inf_flametrooper",
						weapon = "fo_weap_d-93_incinerator_flamethrower",
						anim_set = rifle_anim_set
					},
					pilot =   {
						name = "entity.fo.inf_pilot",
						info = "level.ANF.GC.fo_pilot",
						sound = "mtg_imp_unit_name_pilot",
						body = "for_inf_pilot",
						weapon = "FO_weap_inf_SE-44C_W",
						anim_set = pistol_anim_set
					},
					marine = {
						name = "entity.fo.special_sf_pilot",
						info = "level.ANF.GC.fo_sf_pilot",
						sound = "mtg_all_unit_name_marine",
						body = "for_inf_sf_pilot",
						weapon = "FO_weap_inf_SE-44C_B",
						anim_set = pistol_anim_set
					},
				}
			}	
		}
		
	-- Initialize Variables for Installed Maps!
	local Crait, Jakku, Convopack, Bespin, BespinA, BespinB, RhenVar, RhenVarA, RhenVarB, Tatooine, TatooineA, TatooineB, Kashyyk, KashyykA, KashyykB, Naboo, NabooA, NabooB, Yavin, Geonosis, 
	Kamino = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
	-- Check to see what maps are installed (Marvel4 conversions + Ours + OG Convopack)
	Crait = DoesFileExist("..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\ANF\\CRA.lvl") -- star05
	Jakku = DoesFileExist("..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\ANF\\JA1.lvl") -- star18
	Space = DoesFileExist("..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\ANF\\SPA.lvl")
	
	Convopack = DoesFileExist("..\\..\\Addon\\BF1\\addme.script")
	if Convopack == 1 then
		print("ANF:HyperspaceLanes: OG Convopack found! Adding worlds...")
		
		CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn"); -- RHN
		CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
		CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star12"), "cdn"); -- CDN
		CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star15"), "ord"); -- ORD
		
		CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system"); -- RHN
		CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
		CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star12"), "cdn_system"); -- CDN
		CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star12"), "ord_system"); -- ORD
		
		CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera"); -- RHN
		CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
		CreateEntity(GetEntityClass("tat_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -2.0, GetEntityMatrix("star12")), "cdn_camera"); -- CDN
		
		CreateEntity(GetEntityClass("tat_camera"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -2.0, GetEntityMatrix("star15")), "ord_camera"); -- ORD
		
		CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1"); -- RHN
		CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2"); -- RHN
		
		CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
		CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
		
		CreateEntity(GetEntityClass("star12_fleet1"), 
		CreateMatrix(1.0, 0.0, 2.5, 0.0, 0.1, 0.1, -1.0, GetEntityMatrix("star12")), "cdn_fleet1"); -- CDN
		CreateEntity(GetEntityClass("star12_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.1, -0.1, -1.0, GetEntityMatrix("star12")), "cdn_fleet2"); -- CDN
		
		CreateEntity(GetEntityClass("star15_fleet1"), 
		CreateMatrix(1.0, 0.0, 2.5, 0.0, 0.2, 0.1, -1.0, GetEntityMatrix("star15")), "ord_fleet1"); -- ORD
		CreateEntity(GetEntityClass("star15_fleet2"), 
		CreateMatrix(0.0, 0.0, 0.0, 0.0, 0.0, -0.1, -1.0, GetEntityMatrix("star15")), "ord_fleet2"); -- ORD
		
		DeleteEntity("star08_camera") -- RHN
		DeleteEntity("star08") -- RHN
		DeleteEntity("star08_fleet1") -- RHN
		DeleteEntity("star08_fleet2") -- RHN
		
		DeleteEntity("star17_camera") -- BES
		DeleteEntity("star17") -- BES
		DeleteEntity("star17_fleet1") -- BES
		DeleteEntity("star17_fleet2") -- BES

		DeleteEntity("star12_camera") -- CDN
		DeleteEntity("star12") -- CDN
		DeleteEntity("star12_fleet1") -- CDN
		DeleteEntity("star12_fleet2") -- CDN
		
		DeleteEntity("star15_camera") -- ORD
		DeleteEntity("star15") -- ORD
		DeleteEntity("star15_fleet1") -- ORD
		DeleteEntity("star15_fleet2") -- ORD
		
		if Crait == 1 then -- If Crait is a GO
			print("ANF:HyperspaceLanes: Crait Found! Adding to CGC...")
			if Jakku == 1 then -- If Jakku is a GO
				print("ANF:HyperspaceLanes: Jakku Found! Adding to CGC...")
			
				CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
				CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
				CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
				CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
				CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
				
				CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
				CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
				CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
				CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
				CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
				
				DeleteEntity("star05_camera") -- CRA
				DeleteEntity("star05") -- CRA
				DeleteEntity("star05_fleet1") -- CRA
				DeleteEntity("star05_fleet2") -- CRA
				
				DeleteEntity("star18_camera") -- JAK
				DeleteEntity("star18") -- JAK
				DeleteEntity("star18_fleet1") -- JAK
				DeleteEntity("star18_fleet2") -- JAK 
	
				-- create the connectivity graph
				this.planetDestination = {
					["cor"] = { "end", "jak", "tantive" },
					["dag"] = { "cra", "star06", "nab" },
					["end"] = { "star20", "dea", "cor" },
					["fel"] = { "star13", "yav", "star14" },
					["geo"] = { "cdn", "tat", "star07", "star09" },
					["hot"] = { "star02", "pol" },
					["kas"] = { "cdn", "star13", "ord", "bes" },
					["kam"] = { "cdn", "star13", "tat", "star11" },
					["mus"] = { "star02", "star04", "cra" },
					["myg"] = { "jak", "bes", "ord" },
					["nab"] = { "star07", "cdn", "bes", "dag" },
					["pol"] = { "star04", "hot" },
					["tantive"] = { "cor", "bes" },
					["tat"] = { "star11", "geo", "kam", "star09" },
					["uta"] = { "star04", "cra", "star06" },
					["yav"] = { "ord", "fel", "star14" },
					["star02"] = { "hot", "mus", "star20" },
					--["star03"] = { "hot", "pol" },
					["star04"] = { "mus", "pol", "uta" },
					["cra"] = { "mus", "uta", "dag" }, -- CRAIT
					["star06"] = { "uta", "dag", "star07", "rhn" },
					["star07"] = { "nab", "star06", "geo" },
					["rhn"] = { "star06", "star09" }, -- RHENVAR
					["star09"] = { "tat", "geo", "rhn" },
					["star11"] = { "tat", "kam", "star14" },
					["cdn"] = { "geo", "kam", "nab", "kas" }, -- Concord Dawn
					["star13"] = { "kas", "kam", "fel" },
					["star14"] = { "fel", "yav", "star11" },
					["ord"] = { "kas", "yav", "myg" }, -- Ord Ibanna
					--["star16"] = { "yav", "myg", "star14" },
					["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
					["jak"] = { "cor", "myg", "dea" }, -- JAKKU
					["dea"] = { "star20", "jak", "end" }, -- Death Star
					["star20"] = { "end", "dea", "star02" },
				}
				
			else -- If Jakku is NOT a go
				
				CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
				CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
				CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
				CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
				CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
				
				DeleteEntity("star05_camera") -- CRA
				DeleteEntity("star05") -- CRA
				DeleteEntity("star05_fleet1") -- CRA
				DeleteEntity("star05_fleet2") -- CRA
				
				-- create the connectivity graph
				this.planetDestination = {
					["cor"] = { "end", "star18", "tantive" },
					["dag"] = { "cra", "star06", "nab" },
					["end"] = { "star20", "dea", "cor" },
					["fel"] = { "star13", "yav", "star14" },
					["geo"] = { "cdn", "tat", "star07", "star09" },
					["hot"] = { "star02", "pol" },
					["kas"] = { "cdn", "star13", "ord", "bes" },
					["kam"] = { "cdn", "star13", "tat", "star11" },
					["mus"] = { "star02", "star04", "cra" },
					["myg"] = { "star18", "bes", "ord" },
					["nab"] = { "star07", "cdn", "bes", "dag" },
					["pol"] = { "star04", "hot" },
					["tantive"] = { "cor", "bes" },
					["tat"] = { "star11", "geo", "kam", "star09" },
					["uta"] = { "star04", "cra", "star06" },
					["yav"] = { "ord", "fel", "star14" },
					["star02"] = { "hot", "mus", "star20" },
					--["star03"] = { "hot", "pol" },
					["star04"] = { "mus", "pol", "uta" },
					["cra"] = { "mus", "uta", "dag" }, -- CRAIT
					["star06"] = { "uta", "dag", "star07", "rhn" },
					["star07"] = { "nab", "star06", "geo" },
					["rhn"] = { "star06", "star09" }, -- RHENVAR
					["star09"] = { "tat", "geo", "rhn" },
					["star11"] = { "tat", "kam", "star14" },
					["cdn"] = { "geo", "kam", "nab", "kas" }, -- Concord Dawn
					["star13"] = { "kas", "kam", "fel" },
					["star14"] = { "fel", "yav", "star11" },
					["ord"] = { "kas", "yav", "myg" }, -- Ord Ibanna
					--["star16"] = { "yav", "myg", "star14" },
					["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
					["star18"] = { "cor", "myg", "dea" }, -- JAKKU
					["dea"] = { "star20", "star18", "end" }, -- Death Star
					["star20"] = { "end", "dea", "star02" },
				}
			end
		else -- If Crait is NOT a go
			if Jakku == 1 then -- If Jakku is a GO
				print("ANF:HyperspaceLanes: Jakku Found! Adding to CGC...")
			
				CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
				CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
				CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
				CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
				CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
				
				DeleteEntity("star18_camera") -- JAK
				DeleteEntity("star18") -- JAK
				DeleteEntity("star18_fleet1") -- JAK
				DeleteEntity("star18_fleet2") -- JAK 
				
				-- create the connectivity graph
				this.planetDestination = {
					["cor"] = { "end", "jak", "tantive" },
					["dag"] = { "star05", "star06", "nab" },
					["end"] = { "star20", "dea", "cor" },
					["fel"] = { "star13", "yav", "star14" },
					["geo"] = { "cdn", "tat", "star07", "star09" },
					["hot"] = { "star02", "pol" },
					["kas"] = { "cdn", "star13", "ord", "bes" },
					["kam"] = { "cdn", "star13", "tat", "star11" },
					["mus"] = { "star02", "star04", "star05" },
					["myg"] = { "jak", "bes", "ord" },
					["nab"] = { "star07", "cdn", "bes", "dag" },
					["pol"] = { "star04", "hot" },
					["tantive"] = { "cor", "bes" },
					["tat"] = { "star11", "geo", "kam", "star09" },
					["uta"] = { "star04", "star05", "star06" },
					["yav"] = { "ord", "fel", "star14" },
					["star02"] = { "hot", "mus", "star20" },
					--["star03"] = { "hot", "pol" },
					["star04"] = { "mus", "pol", "uta" },
					["star05"] = { "mus", "uta", "dag" }, -- CRAIT
					["star06"] = { "uta", "dag", "star07", "rhn" },
					["star07"] = { "nab", "star06", "geo" },
					["rhn"] = { "star06", "star09" }, -- RHENVAR
					["star09"] = { "tat", "geo", "rhn" },
					["star11"] = { "tat", "kam", "star14" },
					["cdn"] = { "geo", "kam", "nab", "kas" }, -- Concord Dawn
					["star13"] = { "kas", "kam", "fel" },
					["star14"] = { "fel", "yav", "star11" },
					["ord"] = { "kas", "yav", "myg" }, -- Ord Ibanna
					--["star16"] = { "yav", "myg", "star14" },
					["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
					["jak"] = { "cor", "myg", "dea" }, -- JAKKU
					["dea"] = { "star20", "jak", "end" }, -- Death Star
					["star20"] = { "end", "dea", "star02" },
				}
				
			else -- If Jakku is NOT a go
				
				-- create the connectivity graph
				this.planetDestination = {
					["cor"] = { "end", "star18", "tantive" },
					["dag"] = { "star05", "star06", "nab" },
					["end"] = { "star20", "dea", "cor" },
					["fel"] = { "star13", "yav", "star14" },
					["geo"] = { "cdn", "tat", "star07", "star09" },
					["hot"] = { "star02", "pol" },
					["kas"] = { "cdn", "star13", "ord", "bes" },
					["kam"] = { "cdn", "star13", "tat", "star11" },
					["mus"] = { "star02", "star04", "star05" },
					["myg"] = { "star18", "bes", "ord" },
					["nab"] = { "star07", "cdn", "bes", "dag" },
					["pol"] = { "star04", "hot" },
					["tantive"] = { "cor", "bes" },
					["tat"] = { "star11", "geo", "kam", "star09" },
					["uta"] = { "star04", "star05", "star06" },
					["yav"] = { "ord", "fel", "star14" },
					["star02"] = { "hot", "mus", "star20" },
					--["star03"] = { "hot", "pol" },
					["star04"] = { "mus", "pol", "uta" },
					["star05"] = { "mus", "uta", "dag" }, -- CRAIT
					["star06"] = { "uta", "dag", "star07", "rhn" },
					["star07"] = { "nab", "star06", "geo" },
					["rhn"] = { "star06", "star09" }, -- RHENVAR
					["star09"] = { "tat", "geo", "rhn" },
					["star11"] = { "tat", "kam", "star14" },
					["cdn"] = { "geo", "kam", "nab", "kas" }, -- Concord Dawn
					["star13"] = { "kas", "kam", "fel" },
					["star14"] = { "fel", "yav", "star11" },
					["ord"] = { "kas", "yav", "myg" }, -- Ord Ibanna
					--["star16"] = { "yav", "myg", "star14" },
					["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
					["star18"] = { "cor", "myg", "dea" }, -- JAKKU
					["dea"] = { "star20", "star18", "end" }, -- Death Star
					["star20"] = { "end", "dea", "star02" },
				}
			end
		end
		
		-- create the connectivity graph
		this.planetDestination = {
			["cor"] = { "end", "star18", "tantive" },
			["dag"] = { "star05", "star06", "nab" },
			["end"] = { "star20", "dea", "cor" },
			["fel"] = { "star13", "yav", "star14" },
			["geo"] = { "cdn", "tat", "star07", "star09" },
			["hot"] = { "star02", "pol" },
			["kas"] = { "cdn", "star13", "ord", "bes" },
			["kam"] = { "cdn", "star13", "tat", "star11" },
			["mus"] = { "star02", "star04", "star05" },
			["myg"] = { "star18", "bes", "ord" },
			["nab"] = { "star07", "cdn", "bes", "dag" },
			["pol"] = { "star04", "hot" },
			["tantive"] = { "cor", "bes" },
			["tat"] = { "star11", "geo", "kam", "star09" },
			["uta"] = { "star04", "star05", "star06" },
			["yav"] = { "ord", "fel", "star14" },
			["star02"] = { "hot", "mus", "star20" },
			--["star03"] = { "hot", "pol" },
			["star04"] = { "mus", "pol", "uta" },
			["star05"] = { "mus", "uta", "dag" }, -- CRAIT
			["star06"] = { "uta", "dag", "star07", "rhn" },
			["star07"] = { "nab", "star06", "geo" },
			["rhn"] = { "star06", "star09" }, -- RHENVAR
			["star09"] = { "tat", "geo", "rhn" },
			["star11"] = { "tat", "kam", "star14" },
			["cdn"] = { "geo", "kam", "nab", "kas" }, -- Concord Dawn
			["star13"] = { "kas", "kam", "fel" },
			["star14"] = { "fel", "yav", "star11" },
			["ord"] = { "kas", "yav", "myg" }, -- Ord Ibanna
			--["star16"] = { "yav", "myg", "star14" },
			["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
			["star18"] = { "cor", "myg", "dea" }, -- JAKKU
			["dea"] = { "star20", "star18", "end" }, -- Death Star
			["star20"] = { "end", "dea", "star02" },
		}
	else -- Only search if convopack isn't present
		
		BespinA = DoesFileExist("..\\..\\Addon\\BCC\\addme.script") -- Bespin Cloud City
		BespinB = DoesFileExist("..\\..\\Addon\\BPF\\addme.script") -- Bespin Platforms
		Bespin = BespinA + BespinB -- star17
		RhenVarA = DoesFileExist("..\\..\\Addon\\RVH\\addme.script") -- RhenVar Harbor
		RhenVarB = DoesFileExist("..\\..\\Addon\\RVC\\addme.script") -- RhenVar Citadel
		RhenVar = RhenVarA + RhenVarB -- star08
		TatooineA = DoesFileExist("..\\..\\Addon\\TTD\\addme.script") -- Tatooine Dune Sea
		TatooineB = DoesFileExist("..\\..\\Addon\\TTM\\addme.script") -- Tatooine Mos Eisley
		Tatooine = TatooineA + TatooineB
		KashyykA = DoesFileExist("..\\..\\Addon\\KSD\\addme.script") -- Kashyyk Docks
		KashyykB = DoesFileExist("..\\..\\Addon\\KSI\\addme.script") -- Kashyyk Islands
		Kashyyk = KashyykA + KashyykB
		NabooA = DoesFileExist("..\\..\\Addon\\NBP\\addme.script") -- Naboo Plains
		NabooB = DoesFileExist("..\\..\\Addon\\NBT\\addme.script") -- Naboo Theed
		Naboo = NabooA + NabooB
		Yavin = DoesFileExist("..\\..\\Addon\\Y4A\\addme.script") -- Yavin IV Arena
		Geonosis = DoesFileExist("..\\..\\Addon\\GNS\\addme.script") -- Geonosis Spire
		Kamino = DoesFileExist("..\\..\\Addon\\KTC\\addme.script")  -- Kamino Tipoca City

		-- Setup the connectivity graph between worlds and stars
		--HyperspaceLanes(Crait, Jakku, Bespin, RhenVar)
		print("ANF:HyperspaceLanes: Drawing connectivity graph...")
		if Crait == 1 then -- If Crait is a GO
			print("ANF:HyperspaceLanes: Crait Found! Adding to CGC...")
			if Jakku == 1 then -- If Jakku is a GO
			print("ANF:HyperspaceLanes: Jakku Found! Adding to CGC...")
				if Bespin == 1 or Bespin == 2  then -- If Bespin is a GO
					print("ANF:HyperspaceLanes: Bespin Found! Adding to CGC...")
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn"); -- RHN
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system"); -- RHN
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera"); -- RHN
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1"); -- RHN
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2"); -- RHN
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						DeleteEntity("star08_camera") -- RHN
						DeleteEntity("star08") -- RHN
						DeleteEntity("star08_fleet1") -- RHN
						DeleteEntity("star08_fleet2") -- RHN
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "dea", "cor" },
							["fel"] = { "star13", "yav", "star14" },
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "jak", "bes", "star15" },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" },
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11" },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea" }, -- JAKKU
							["dea"] = { "star20", "jak", "end" }, -- Death Star
							["star20"] = { "end", "dea", "star02" },
						}
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "jak", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" },
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea" }, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				else -- If Bespin is NOT a go
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn"); -- RHN
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system"); -- RHN
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera"); -- RHN
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1"); -- RHN
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2"); -- RHN
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star08_camera") -- RHN
						DeleteEntity("star08") -- RHN
						DeleteEntity("star08_fleet1") -- RHN
						DeleteEntity("star08_fleet2") -- RHN
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "jak", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea" }, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "jak", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RhenVar
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				end
			else -- If Jakku is NOT a go
				if Bespin == 1 or Bespin == 2  then -- If Bespin is a GO
					print("ANF:HyperspaceLanes: Bespin Found! Adding to CGC...")
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn"); -- RHN
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system"); -- RHN
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera"); -- RHN
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1"); -- RHN
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2"); -- RHN
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						DeleteEntity("star08_camera") -- RHN
						DeleteEntity("star08") -- RHN
						DeleteEntity("star08_fleet1") -- RHN
						DeleteEntity("star08_fleet2") -- RHN
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "star18", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
						
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "star18", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" },
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				else -- If Bespin is NOT a go
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn");
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system");
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera");
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1");
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2");
						DeleteEntity("star08_camera")
						DeleteEntity("star08")
						--DeleteEntity("star08_system")
						DeleteEntity("star08_fleet1")
						DeleteEntity("star08_fleet2")
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "star18", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star05"), "cra"); -- CRA
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star05"), "cra_system"); -- CRA
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star05_camera"), "cra_camera"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet1"), GetEntityMatrix("star05_fleet1"), "cra_fleet1"); -- CRA
						CreateEntity(GetEntityClass("star05_fleet2"), GetEntityMatrix("star05_fleet2"), "cra_fleet2"); -- CRA
						DeleteEntity("star05_camera") -- CRA
						DeleteEntity("star05") -- CRA
						DeleteEntity("star05_fleet1") -- CRA
						DeleteEntity("star05_fleet2") -- CRA
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "cra", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "cra" },
							["myg"] = { "star18", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" },
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "cra", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["cra"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" }, 
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				end
			end
		elseif Crait == 0 then -- If Crait is NOT a go
			if Jakku == 1 then -- If Jakku is a GO
			print("ANF:HyperspaceLanes: Jakku Found! Adding to CGC...")
				if Bespin == 1 or Bespin == 2  then -- If Bespin is a GO
					print("ANF:HyperspaceLanes: Bespin Found! Adding to CGC...")
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn"); -- RHN
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system"); -- RHN
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera"); -- RHN
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1"); -- RHN
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2"); -- RHN
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star08_camera") -- RHN
						DeleteEntity("star08") -- RHN
						DeleteEntity("star08_fleet1") -- RHN
						DeleteEntity("star08_fleet2") -- RHN
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "jak", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "jak", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				else -- If Bespin is NOT a go
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn");
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system");
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera");
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1");
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2");
						DeleteEntity("star08_camera")
						DeleteEntity("star08")
						--DeleteEntity("star08_system")
						DeleteEntity("star08_fleet1")
						DeleteEntity("star08_fleet2")
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "jak", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("tat"), GetEntityMatrix("star18"), "jak"); -- JAK
						CreateEntity(GetEntityClass("tat_system"), GetEntityMatrix("star18"), "jak_system"); -- JAK
						CreateEntity(GetEntityClass("tat_camera"), GetEntityMatrix("star18_camera"), "jak_camera"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet1"), GetEntityMatrix("star18_fleet1"), "jak_fleet1"); -- JAK
						CreateEntity(GetEntityClass("star18_fleet2"), GetEntityMatrix("star18_fleet2"), "jak_fleet2"); -- JAK
						DeleteEntity("star18_camera") -- JAK
						DeleteEntity("star18") -- JAK
						DeleteEntity("star18_fleet1") -- JAK
						DeleteEntity("star18_fleet2") -- JAK
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "jak", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "cor", "dea" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "jak", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["jak"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "jak", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				end
			else -- If Jakku is NOT a go
				if Bespin == 1 or Bespin == 2  then -- If Bespin is a GO
					print("ANF:HyperspaceLanes: Bespin Found! Adding to CGC...")
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn"); -- RHN
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system"); -- RHN
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera"); -- RHN
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1"); -- RHN
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2"); -- RHN
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						DeleteEntity("star08_camera") -- RHN
						DeleteEntity("star08") -- RHN
						DeleteEntity("star08_fleet1") -- RHN
						DeleteEntity("star08_fleet2") -- RHN
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "dea", "star18" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "star18", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" },
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					else -- If RhenVar is NOT a go
						CreateEntity(GetEntityClass("myg"), GetEntityMatrix("star17"), "bes"); -- BES
						CreateEntity(GetEntityClass("myg_system"), GetEntityMatrix("star17"), "bes_system"); -- BES
						CreateEntity(GetEntityClass("myg_camera"), GetEntityMatrix("star17_camera"), "bes_camera"); -- BES
						CreateEntity(GetEntityClass("star17_fleet1"), GetEntityMatrix("star17_fleet1"), "bes_fleet1"); -- BES
						CreateEntity(GetEntityClass("star17_fleet2"), GetEntityMatrix("star17_fleet2"), "bes_fleet2"); -- BES
						DeleteEntity("star17_camera") -- BES
						DeleteEntity("star17") -- BES
						DeleteEntity("star17_fleet1") -- BES
						DeleteEntity("star17_fleet2") -- BES
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "dea", "star18" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "bes" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "star18", "bes", "star15"  },
							["nab"] = { "star07", "star12", "bes", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "bes" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["bes"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				else -- If Bespin is NOT a go
					if RhenVar == 1 or RhenVar == 2 then -- If RhenVar is a GO
						print("ANF:HyperspaceLanes: RhenVar Found! Adding to CGC...")
						
						CreateEntity(GetEntityClass("hot"), GetEntityMatrix("star08"), "rhn");
						CreateEntity(GetEntityClass("hot_system"), GetEntityMatrix("star08"), "rhn_system");
						CreateEntity(GetEntityClass("hot_camera"), GetEntityMatrix("star08_camera"), "rhn_camera");
						CreateEntity(GetEntityClass("star08_fleet1"), GetEntityMatrix("star08_fleet1"), "rhn_fleet1");
						CreateEntity(GetEntityClass("star08_fleet2"), GetEntityMatrix("star08_fleet2"), "rhn_fleet2");
						DeleteEntity("star08_camera")
						DeleteEntity("star08")
						--DeleteEntity("star08_system")
						DeleteEntity("star08_fleet1")
						DeleteEntity("star08_fleet2")
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "dea", "star18" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07", "star09" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "star18", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "rhn" },
							["star07"] = { "nab", "star06", "geo" },
							["rhn"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "rhn" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					else -- If RhenVar is NOT a go
						print("ANF:HyperspaceLanes: No maps found! No extra maps will be added!")
						
						-- create the connectivity graph
						this.planetDestination = {
							["cor"] = { "end", "star18", "tantive" },
							["dag"] = { "star05", "star06", "nab" },
							["end"] = { "star20", "dea", "star18" },
							["fel"] = { "star13", "yav", "star14"},
							["geo"] = { "star12", "tat", "star07" },
							["hot"] = { "star02", "pol" },
							["kas"] = { "star12", "star13", "star15", "star17" },
							["kam"] = { "star12", "star13", "tat", "star11" },
							["mus"] = { "star02", "star04", "star05" },
							["myg"] = { "star18", "star17", "star15"  },
							["nab"] = { "star07", "star12", "star17", "dag" },
							["pol"] = { "star04", "hot" }, 
							["tantive"] = { "cor", "star17" },
							["tat"] = { "star11", "geo", "kam", "star09" },
							["uta"] = { "star04", "star05", "star06" },
							["yav"] = { "star15", "fel", "star14" },
							["star02"] = { "hot", "mus", "star20" },
							--["star03"] = { "hot", "pol" },
							["star04"] = { "mus", "pol", "uta" },
							["star05"] = { "mus", "uta", "dag" }, -- CRAIT
							["star06"] = { "uta", "dag", "star07", "star08" },
							["star07"] = { "nab", "star06", "geo" },
							["star08"] = { "star06", "star09" }, -- RHENVAR
							["star09"] = { "tat", "geo", "star08" },
							["star11"] = { "tat", "kam", "star14" },
							["star12"] = { "geo", "kam", "nab", "kas" },
							["star13"] = { "kas", "kam", "fel" },
							["star14"] = { "fel", "yav", "star11"  },
							["star15"] = { "kas", "yav", "myg" },
							--["star16"] = { "yav", "myg", "star14" },
							["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
							["star18"] = { "cor", "myg", "dea"}, -- JAKKU
							["dea"] = { "end", "star18", "star20" },
							["star20"] = { "end", "cor", "star02", "dea" }
						}
					end
				end
			end
		else -- NOTHING is a go
			print("ANF:HyperspaceLanes: Invalid/No maps found! No extra maps will be added!")
			
			-- create the connectivity graph
			this.planetDestination = {
				["cor"] = { "end", "star18", "tantive" },
				["dag"] = { "star05", "star06", "nab" },
				["end"] = { "star20", "dea", "star18" },
				["fel"] = { "star13", "yav", "star14"},
				["geo"] = { "star12", "tat", "star07" },
				["hot"] = { "star02", "pol" },
				["kas"] = { "star12", "star13", "star15", "star17" },
				["kam"] = { "star12", "star13", "tat", "star11" },
				["mus"] = { "star02", "star04", "star05" },
				["myg"] = { "star18", "star17", "star15"  },
				["nab"] = { "star07", "star12", "star17", "dag" },
				["pol"] = { "star04", "hot" }, 
				["tantive"] = { "cor", "star17" },
				["tat"] = { "star11", "geo", "kam" },
				["uta"] = { "star04", "star05", "star06" },
				["yav"] = { "star15", "fel", "star14" },
				["star02"] = { "hot", "mus", "star20" },
				--["star03"] = { "hot", "pol" },
				["star04"] = { "mus", "pol", "uta" },
				["star05"] = { "mus", "uta", "dag" }, -- CRAIT
				["star06"] = { "uta", "dag", "star07", "star08" },
				["star07"] = { "nab", "star06", "geo" },
				["star08"] = { "star06", "star09" }, -- RHENVAR
				["star09"] = { "tat", "geo", "star08" },
				["star11"] = { "tat", "kam", "star14" },
				["star12"] = { "geo", "kam", "nab", "kas" },
				["star13"] = { "kas", "kam", "fel" },
				["star14"] = { "fel", "yav", "star11"  },
				["star15"] = { "kas", "yav", "myg" },
				--["star16"] = { "yav", "myg", "star14" },
				["star17"] = { "tantive", "kas", "myg", "nab" }, -- BESPIN
				["star18"] = { "cor", "myg", "dea"}, -- JAKKU
				["dea"] = { "end", "star18", "star20" },
				["star20"] = { "end", "cor", "star02", "dea" }
			}
		end
		
		if Crait ~= nil or Jakku  ~= nil or Bespin ~= nil or RhenVar ~= nil then
			print("ANF:HyperspaceLanes: New Planets Present in CGC are: Crait " .. Crait .. " Jakku " .. Jakku .. 
			" Bespin " .. Bespin .. " RhenVar " .. RhenVar)
		end
	
	end
	

	print("ANF:HyperspaceLanes: All done! Exiting...")
	
	-- Setup Planet Values and Camera objects
	--PlanetMarket(Crait, Jakku, Bespin, RhenVar)
	
	print("ANF:PlanetMarket: Setting up Planet values and cameras...")
	--replacing this table from init_common, by [RDH]Zerted aka CAMERAS
	-- per-planet camera offsets
	
	if Convopack == 1 then
		print("ANF:PlanetMarket: Adding OG Convopack planet values")
		
		this.cameraOffset = {
			["cor"] = { 0, 1, 1 },	
			["dag"] = { 0, 1, 1 }, 
			["dea"] = {0, 1, 1},	
			["fel"] = { 0, 1, 1 },	
			["tat"] = { 0, 1, 1 }, 
			["tantive"] = { 0, 1, 1 },	
			["kas"] = { 0, 1, 1 },	
			["hot"] = { 0, 1, 1 },
			["kam"] = { 0, 1, 1 },
			["pol"] = { 0, 1, 1 },
			["myg"] = { 0, 1, 1 },
			["end"] = { 0, 1, 1 },
			["mus"] = { 0, 1, 1 },
			["uta"] = { 0, 1, 1 },
			["nab"] = { 0, 1, 1 },
			["geo"] = { 0, 1, 1 },
			["yav"] = { 0, 1, 1 },
			["cdn"] = { 0, 1, 1 },
			["bes"] = { 0, 1, 1 },
			["rhn"] = { 0, 1, 1 },
			["ord"] = { 0, 1, 1 },
		}
		
		-- resource value for each planet
		this.planetValue = {
			["cor"] = { victory = 200, defeat = 10, turn = 10 },
			["dag"] = { victory = 100, defeat = 20, turn = 3 },
			["end"] = { victory = 100, defeat = 20, turn = 3 }, 
			["dea"] = { victory = 100, defeat = 20, turn = 3},
			["fel"] = { victory = 100, defeat = 20, turn = 3 },
			["geo"] = { victory = 100, defeat = 20, turn = 3 },
			["hot"] = { victory = 100, defeat = 20, turn = 3 }, 
			["kas"] = { victory = 100, defeat = 20, turn = 3 },
			["kam"] = { victory = 100, defeat = 20, turn = 3 },
			["mus"] = { victory = 100, defeat = 20, turn = 6 },
			["myg"] = { victory = 100, defeat = 20, turn = 3 },
			["nab"] = { victory = 100, defeat = 20, turn = 3 },
			["pol"] = { victory = 200, defeat = 10, turn = 10 },
			["tat"] = { victory = 100, defeat = 20, turn = 3 }, 
			["tantive"] = { victory = 100, defeat = 20, turn = 3 },
			["uta"] = { victory = 100, defeat = 20, turn = 3 },
			["yav"] = { victory = 100, defeat = 20, turn = 6 },
			["cdn"] = { victory = 125, defeat = 25, turn = 3 },
			["bes"] = { victory = 125, defeat = 25, turn = 3 },
			["rhn"] = { victory = 125, defeat = 25, turn = 3 },
			["ord"] = { victory = 125, defeat = 25, turn = 3 },
		}
		
		if Jakku == 1 then
			this.cameraOffset["jak"] = {0,1,1}
			this.planetValue["jak"] = { victory = 125, defeat = 25, turn = 3}
		end
		if Crait == 1 then
			this.cameraOffset["cra"] = {0,1,1}
			this.planetValue["cra"] = { victory = 125, defeat = 25, turn = 3}
		end

	else 
		this.cameraOffset = {
			["cor"] = { 0, 1, 1 },	
			["dag"] = { 0, 1, 1 }, 
			["dea"] = {0, 1, 1},	
			["fel"] = { 0, 1, 1 },	
			["tat"] = { 0, 1, 1 }, 
			["tantive"] = { 0, 1, 1 },	
			["kas"] = { 0, 1, 1 },	
			["hot"] = { 0, 1, 1 },
			["kam"] = { 0, 1, 1 },
			["pol"] = { 0, 1, 1 },
			["myg"] = { 0, 1, 1 },
			["end"] = { 0, 1, 1 },
			["mus"] = { 0, 1, 1 },
			["uta"] = { 0, 1, 1 },
			["nab"] = { 0, 1, 1 },
			["geo"] = { 0, 1, 1 },
			["yav"] = { 0, 1, 1 },
		}
		
		-- resource value for each planet
		this.planetValue = {
			["cor"] = { victory = 200, defeat = 15, turn = 10 },
			["dag"] = { victory = 100, defeat = 25, turn = 3 },
			["end"] = { victory = 100, defeat = 25, turn = 3 }, 
			["dea"] = { victory = 100, defeat = 25, turn = 3},
			["fel"] = { victory = 100, defeat = 25, turn = 3 },
			["geo"] = { victory = 100, defeat = 25, turn = 3 },
			["hot"] = { victory = 100, defeat = 25, turn = 3 }, 
			["kas"] = { victory = 100, defeat = 25, turn = 3 },
			["kam"] = { victory = 100, defeat = 25, turn = 3 },
			["mus"] = { victory = 150, defeat = 20, turn = 6 },
			["myg"] = { victory = 100, defeat = 25, turn = 3 },
			["nab"] = { victory = 100, defeat = 25, turn = 3 },
			["pol"] = { victory = 200, defeat = 15, turn = 10 },
			["tat"] = { victory = 100, defeat = 25, turn = 3 }, 
			["tantive"] = { victory = 100, defeat = 25, turn = 3 },
			["uta"] = { victory = 100, defeat = 25, turn = 3 },
			["yav"] = { victory = 150, defeat = 20, turn = 6 },
		}
		
		if Jakku == 1 then
			this.cameraOffset["jak"] = {0,1,1}
			this.planetValue["jak"] = { victory = 125, defeat = 25, turn = 3}
		end
		if Crait == 1 then
			this.cameraOffset["cra"] = {0,1,1}
			this.planetValue["cra"] = { victory = 125, defeat = 25, turn = 3}
		end
		if Bespin > 0 then
			this.cameraOffset["bes"] = {0,1,1}
			this.planetValue["bes"] = { victory = 125, defeat = 25, turn = 3}
		end
		if RhenVar > 0 then
			this.cameraOffset["rhn"] = {0,1,1}
			this.planetValue["rhn"] = { victory = 125, defeat = 25, turn = 3}
		end
		
	end
	print("ANF:PlanetMarket: All done! Exiting...")
		
	-- Setup the missions for each world
	--PlanetMissions(Crait, Jakku, Geonosis, Kamino, Yavin, BespinA, BespinB,
	--	RhenVarA, RhenVarB, TatooineA, TatooineB, KashyykA, KashyykB, NabooA, NabooB)

	print("ANF:PlanetMissions: Setting up the missions for each planet")

	-- mission to launch for space!
	this.spaceMission = {
		["con"] = { "spa1f_ass", "spa8f_ass", "spa9f_ass" }
	}
	
	-- Stock Missions
	this.planetMission = {
		["cor"] = {
			["con"] = "cor1f_con",
		},
		["dag"] = {
			["con"] = "dag1f_con",
		},
		["dea"] = {
			["con"] = "dea1f_con",
		},
		["end"] = {
			["con"] = "end1f_con",
		},
		["fel"] = {
			["con"] = "fel1f_con",
		},
		["geo"] = {
			["con"] = "geo1f_con",
		},
		["hot"] = {
			["con"] = "hot1f_con",
		}, 
		["kam"] = {
			["con"] = "kam1f_con",
		},
		["kas"] = {
			["con"] = "kas2f_con",
		},
		["mus"] = {
			["con"] = "mus1f_con",
		},
		["myg"] = {
			["con"] = "myg1f_con",
		},
		["nab"] = {
			["con"] = "nab2f_con",
		},
		["pol"] = {
			["con"] = "pol1f_con",
		},
		["tat"] = {
			["con"] = {"tat2f_con", "tat3f_con"}
		},
		["tantive"] = {
			["con"] = "tan1f_con", 
		},
		["uta"] = {
			["con"] = "uta1f_con",
		},
		["yav"] = {
			["con"] = "yav1f_con",
		},
	}

	-- Attempt to append the table with our new missions--
	-- table.insert(array) is an alternative method...
	
	if Convopack == 1 then
		print("ANF:PlanetMissions: Adding OG Convopack missions...")
		
		this.planetMission["cdn"] = {
				["con"] = "CDNf_con"
		}
		
		this.planetMission["ord"] = {
				["con"] = "IBNf_con"
		}
		
		this.planetMission["kam"] = {
				["con"] = {"kam1f_con", "KM1f_con"}
		}
		
		this.planetMission["yav"] = {
				["con"] = {"yav1f_con", "YV2f_con"}
		}
		
		this.planetMission["bes"] = {
				["con"] = {"BS1f_con", "BS2f_con"}
		}
		
		this.planetMission["rhn"] = {
				["con"] = {"RH1f_con", "RNVf_con"}
		}
		
		this.planetMission["kas"] = {
				["con"] = {"AT5f_con", "AT6f_con", "kas2f_con"}
		}
		
		this.planetMission["tat"] = {
				["con"] = {"tat2f_con", "tat3f_con", "TA1f_con"}
		}
		
		this.planetMission["nab"] = {
				["con"] = {"nab2f_con", "AT4f_con", "NPTf_con" }
		}
		
	else -- Only add missions if OG Convopack is NOT detected
		-- Add Geonosis Missions
		if Geonosis == 1 then
			this.planetMission["geo"] = {
				["con"] = {"GNSf_con", "geo1f_con"}
			}
		end
		-- Add Kamino Missions
		if Kamino == 1 then
			this.planetMission["kam"] = {
				["con"] = {"KTCf_con", "kam1f_con"}
			}
		end
		-- Add Yavin Missions
		if Yavin == 1 then
			this.planetMission["yav"] = {
				["con"] = {"Y4Af_con", "yav1f_con"}
			}
		end
		-- Add Bespin Missions
		if BespinA == 1 then -- If BCC is GO
			if BespinB == 1 then -- If BPF is a GO
				this.planetMission["bes"] = {
					["con"] = {"BPFf_con", "BCCf_con"}
				}
			else -- If BPF is NOT a go
				this.planetMission["bes"] = {
					["con"] = "BCCf_con",
				}
			end
		else -- If BCC is NOT a go
			if BespinB == 1 then
				this.planetMission["bes"] = {
					["con"] = "BCCf_con",
				}
			end
		end
		-- Add RhenVar Missions
		if RhenVarA == 1 then -- If RVH is GO
			if RhenVarB == 1 then -- If RVC is a GO
				this.planetMission["rhn"] = {
					["con"] = {"RVCf_con", "RVHf_con"}
				}
			else -- If RVC is NOT a go
				this.planetMission["rhn"] = {
					["con"] = "RVHf_con",
				}
			end
		else -- If RVH is NOT a go
			if BespinB == 1 then
				this.planetMission["rhn"] = {
					["con"] = "RVCf_con",
				}
			end
		end
		-- Add Kashyyk Missions
		if KashyykA == 1 then -- If KSD is GO
			if KashyykB == 1 then -- If KSI is a GO
				this.planetMission["kas"] = {
					["con"] = {"KSDf_con", "KSIf_con", "kas2f_con"}
				}
			else -- If KSI is NOT a go
				this.planetMission["kas"] = {
					["con"] = {"KSDf_con", "kas2f_con"}
				}
			end
		else -- If KSD is NOT a go
			if KashyykB == 1 then
				this.planetMission["kas"] = {
					["con"] = {"KSIf_con", "kas2f_con"}
				}
			end
		end
		-- Add Tatooine Missions
		if TatooineA == 1 then -- If TTD is GO
			if TatooineB == 1 then -- If TTM is a GO
				this.planetMission["tat"] = {
					["con"] = {"TTDf_con", "TTMf_con", "tat2f_con", "tat3f_con"}
				}
			else -- If TTM is NOT a go
				this.planetMission["tat"] = {
					["con"] = {"TTDf_con", "tat2f_con", "tat3f_con"}
				}
			end
		else -- If TTD is NOT a go
			if TatooineB == 1 then
				this.planetMission["tat"] = {
					["con"] = {"TTMf_con", "tat2f_con", "tat3f_con"}
				}
			end
		end
		-- Add Naboo Missions
		if NabooA == 1 then -- If NBP is GO
			if NabooB == 1 then -- If NBT is a GO
				this.planetMission["nab"] = {
					["con"] = {"NBPf_con", "NBTf_con", "nab2f_con"}
				}
			else -- If NBT is NOT a go
				this.planetMission["nab"] = {
					["con"] = {"NBPf_con", "nab2f_con"}
				}
			end
		else -- If NBP is NOT a go
			if NabooB == 1 then
				this.planetMission["nab"] = {
					["con"] = {"NBTf_con", "nab2f_con"}
				}
			end
		end

		print("ANF:PlanetMissions: Here are the values of the variables, as follows: ")
		print("Crait: " .. Crait .. " Jakku: " .. Jakku .. " Geonosis: " .. Geonosis .. " Kamino: " .. Kamino ..
			" Yavin: " .. Yavin .. "\nBespinA: " .. BespinA .. " BespinB: " .. BespinB .. " RhenVarA: " .. RhenVarA ..
			" RhenVarB: " .. RhenVarB .. " KashyykA: " .. KashyykA .. " KashyykB: " .. KashyykB .. " NabooA: " .. 
			NabooA .. " NabooB: " .. NabooB .. "\nTatooineA: " .. TatooineA .. " TatooineB: " .. TatooineB)
	end
	
	---[[ 
	--Still need to check for ANF maps
	
	-- Add Crait Missions
	if Crait == 1 then
		this.planetMission["cra"] = {
			["con"] = "CRAf_con",
		}
	end
	-- Add Jakku Missions
	if Jakku == 1 then
		this.planetMission["jak"] = {
			["con"] = "JA1f_con",
		}
	end
	--]]
	
	print("ANF:PlanetMissions: All done! Exiting...")

		print("ifs_freeform_init_ANF: Finished")
	end
end
