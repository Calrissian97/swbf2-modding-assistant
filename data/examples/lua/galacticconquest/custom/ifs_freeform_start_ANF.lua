-- Start the FO campaign

print("Entered ifs_freeform_start_ANF.lua")
function ifs_freeform_start_ANF(this)
	-- save scenario type
	this.scenario = "ANF"
	-- assigned teams
	local IMP = 2
	local ALL = 1

	-- ANF initialize
	ifs_freeform_init_ANF(this, IMP, ALL)
	-- set to versus play
	ifs_freeform_controllers(this, { [0] = IMP, [1] = IMP, [2] = IMP, [3] = IMP })

	-- ANF start
	this.Start = function(this)
	print("ifs_freeform_start_ANF: Start()")
		-- perform common start
		ifs_freeform_start_common(this)
		
		
	   	-- set team for each planet
   		this.planetTeam = {
			["cor"] = ALL,
			["dag"] = IMP,
			["dea"] = ALL,
			["end"] = ALL, 
			["fel"] = ALL,
			["geo"] = IMP,
			["hot"] = IMP,
			["kas"] = ALL,
			["kam"] = IMP,
			["mus"] = IMP,
			["myg"] = ALL,
			["nab"] = ALL,
			["pol"] = IMP,
			["tat"] = IMP,
			["tantive"] = ALL,
			["uta"] = IMP,
			["yav"] = ALL,
		}
		
		-- Initialize Variables for Installed Maps!
		local Crait, Jakku, Convopack, Bespin, BespinA, BespinB, RhenVar, RhenVarA, RhenVarB = 0,0,0,0,0,0,0,0,0
		
		Crait = ScriptCB_IsFileExist("..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\ANF\\CRA.lvl") -- star05
		Jakku = ScriptCB_IsFileExist("..\\..\\Addon\\ZZZ\\data\\_LVL_PC\\ANF\\JA1.lvl") -- star18
		
		Convopack = DoesFileExist("..\\..\\Addon\\BF1\\addme.script")
		if Convopack == 1 then
			-- Add OG Convopack maps...
			this.planetTeam["rhn"] = IMP
			this.planetTeam["bes"] = ALL
			this.planetTeam["cdn"] = IMP
			this.planetTeam["ord"] = ALL
		else
			-- Check to see what maps are installed (Marvel4 conversions)
			BespinA = ScriptCB_IsFileExist("..\\..\\Addon\\BCC\\addme.script") -- Bespin Cloud City 
			BespinB = ScriptCB_IsFileExist("..\\..\\Addon\\BPF\\addme.script") -- Bespin Platforms
			Bespin = BespinA + BespinB -- star17
			RhenVarA = ScriptCB_IsFileExist("..\\..\\Addon\\RVH\\addme.script") -- RhenVar Harbor
			RhenVarB = ScriptCB_IsFileExist("..\\..\\Addon\\RVC\\addme.script") -- RhenVar Citadel
			RhenVar = RhenVarA + RhenVarB -- star08

			if Bespin ~= 0 then
				this.planetTeam["bes"] = ALL
			end
			if RhenVar ~= 0 then
				this.planetTeam["rhn"] = IMP
			end
		end
		
		---[[
		-- Add ANF maps for starting
		if Crait ~= 0 then
			this.planetTeam["cra"] = IMP
		end
		if Jakku ~= 0 then
			this.planetTeam["jak"] = ALL
		end
		--]]
		
		-- create starting fleets for each team
		this.planetFleet = {}
		for team, start in pairs(this.planetStart) do
			local planet = start[math.random(table.getn(start))]
			this.planetFleet[planet] = team
		end
	end
	print("ifs_freeform_start_ANF: Finished")
end