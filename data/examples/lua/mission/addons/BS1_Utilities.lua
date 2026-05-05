-- World functions for Bespin: Platforms

-- Check if this is a multiplayer session
function IsMulti()
    if ScriptCB_InNetSession() == true then
        print("BS1:IsMulti: In multiplayer session.")
        return true
    else
        print("BS1:IsMulti: In singleplayer session.")
        return false
    end
end

--Decides the weather and time of the map depending on user settings
--and loads the appropriate loading screen, overwrites models
function SetEnvironment(weather)
	--Only look if weather hasn't been directly specified
	if weather == nil then
		--Check for text files, their presence will activate their respective weather/ToD
		local BF1Mode = ScriptCB_IsFileExist    ("..\\..\\addon\\BS1\\BF1.txt")
		local NightMode = ScriptCB_IsFileExist  ("..\\..\\addon\\BS1\\Night.txt")
		local NoonMode = ScriptCB_IsFileExist   ("..\\..\\addon\\BS1\\Noon.txt")
		local CloudyMode = ScriptCB_IsFileExist ("..\\..\\addon\\BS1\\Cloudy.txt")
		local EAMode = ScriptCB_IsFileExist     ("..\\..\\addon\\BS1\\EA.txt")
      local Random = ScriptCB_IsFileExist     ("..\\..\\addon\\BS1\\RandomVersion.txt")

		--If BF1 text file is present, load the corresponding file
		if BF1Mode == 1 then
			ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\BF1.lvl")
			return "BF1"
		
		--If Night text file is present, load the corresponding file(s)
		elseif NightMode == 1 then
			ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Night.lvl")
         ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\SIDE\\BES.lvl;dark")
			return "Night"
        
		--If Noon text file is present, load the corresponding file
		elseif NoonMode == 1 then
			ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Noon.lvl")
			return "Noon"
		
		--If Cloudy text file is present, load the corresponding file
		elseif CloudyMode == 1 then
			ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Cloudy.lvl")
			return "Cloudy"
            
      --If EA text file is present, load the corresponding file
		elseif EAMode == 1 then
			ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\EA.lvl")
			return "EA"

      --If Random text file is present, choose version (semi)randomly
      elseif Random == 1 then
         local versionNum = 0
         versionNum = math.random(0,3) --Generate random num b/w 0 and 3

         if versionNum == 0 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\BF1.lvl")
            return "BF1"
         elseif versionNum == 1 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Night.lvl")
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\SIDE\\BES.lvl;dark")
            return "Night"
         elseif versionNum == 2 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Noon.lvl")
            return "Noon"
         elseif versionNum == 3 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Cloudy.lvl")
            return "Cloudy"
         end

      --If not specified, default to BF1
		else
         ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\BF1.lvl")
         return "BF1"
        end
	
	--If a weather IS specified, blow a load right into the exhaust port
	elseif weather == "BF1" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\BF1.lvl")
		return weather
		
	elseif weather == "Night" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Night.lvl")
      ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\SIDE\\BES.lvl;dark")
		return weather

	elseif weather == "Noon" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Noon.lvl")
		return weather
	
	elseif weather == "Cloudy" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Cloudy.lvl")
		return weather
	
	elseif weather == "EA" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\EA.lvl")
		return weather

   elseif weather == "Random" then
         local versionNum = 0
         versionNum = math.random(0,3) --Generate random num b/w 0 and 3

         if versionNum == 0 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\BF1.lvl")
            return "BF1"
         elseif versionNum == 1 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Night.lvl")
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\SIDE\\BES.lvl;dark")
            return "Night"
         elseif versionNum == 2 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Noon.lvl")
            return "Noon"
         elseif versionNum == 3 then
            ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\Cloudy.lvl")
            return "Cloudy"
         end

   -- Default to BF1 if none/invalid selected
	else
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\LOAD\\BF1.lvl")
		return "BF1"
	end
end

--Loads the chosen environments assets
function LoadEnvironment(weather)
	--Initialize params
	weather = weather or "BF1"
	
	if weather == "Cloudy" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\BS1\\sky.lvl", "Cloudy")
		print("BS1:LoadEnvironment: Cloudy sky loaded")
		
	elseif weather == "Night" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\BS1\\sky.lvl", "Night")
		print("BS1:LoadEnvironment: Night sky loaded")
		
	elseif weather == "BF1" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\BS1\\sky.lvl", "BF1")
		print("BS1:LoadEnvironment: BF1 sky loaded")
	
	elseif weather == "Noon" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\BS1\\sky.lvl", "Noon")
		print("BS1:LoadEnvironment: Noon sky loaded")
        
	elseif weather == "EA" then
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\BS1\\sky.lvl", "EA")
		print("BS1:LoadEnvironment: EA sky loaded")
	
    else
		ReadDataFile("..\\..\\addon\\BS1\\data\\_LVL_PC\\BS1\\sky.lvl", "BF1")
		print("BS1:LoadEnvironment: BF1 sky loaded")
	end
	
	weather = nil
	return
end

-- Blocks or unblocks AI planning connections for central platform sniper perch
function SetCentralPlatformPlanning(enable)
   local enabled = ScriptCB_IsFileExist("..\\..\\addon\\BS1\\CentralPlatformSnipers.txt")
   if enable == true then
      UnblockPlanningGraphArcs("RampConn1")
      UnblockPlanningGraphArcs("RampConn2")
      print("BS1:Central Platform Snipers enabled")
   elseif enable == false then
      BlockPlanningGraphArcs("RampConn1")
      BlockPlanningGraphArcs("RampConn2")
      print("BS1:Central Platform Snipers disabled")
   else
      if enabled == 1 then
         UnblockPlanningGraphArcs("RampConn1")
         UnblockPlanningGraphArcs("RampConn2")
         print("BS1:Central Platform Snipers enabled")
      else
         BlockPlanningGraphArcs("RampConn1")
         BlockPlanningGraphArcs("RampConn2")
         print("BS1:Central Platform Snipers disabled")
      end
   end
end

--Announces captured/lost command posts to the players
--Params: Team1, Team2 are string team names e.g., "IMP", "ALL"; Team1Num, Team2Num are the actual team numbers
function AnnounceCPCapture(Team1, Team2, Team1Num, Team2Num)
   local Announce = ScriptCB_IsFileExist("..\\..\\addon\\BS1\\AnnounceCPs.txt")
   -- Only enable if specified
   if Announce == 1 then
      --Add default values to variables just in case
      Team1 = Team1 or "CIS"
      Team2 = Team2 or "REP"
      Team1Num = Team1Num or 1
      Team2Num = Team2Num or 2
      
      if Team1 == "REP" then
            REP_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.REP." .. cpname)
               end,
               Team1Num
            )
            
      elseif Team1 == "CIS" then
            CIS_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.CIS." .. cpname)
               end,
               Team1Num
            )
            
      elseif Team1 == "IMP" then
            IMP_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.IMP." .. cpname)
               end,
               Team1Num
            )
            
      elseif Team1 == "ALL" then
            ALL_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.ALL." .. cpname)
               end,
               Team1Num
            )
            
      elseif Team1 == "FO" then
            FO_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.FO." .. cpname)
               end,
               Team1Num
            )
            
      elseif Team1 == "RES" then
            RES_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.RES." .. cpname)
               end,
               Team1Num
            )
      end
      
      if Team2 == "REP" then
            REP_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.REP." .. cpname)
               end,
               Team2Num
            )
            
      elseif Team2 == "CIS" then
            CIS_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.CIS." .. cpname)
               end,
               Team2Num
            )
            
      elseif Team2 == "IMP" then
            IMP_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.IMP." .. cpname)
               end,
               Team2Num
            )
            
      elseif Team2 == "ALL" then
            ALL_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.ALL." .. cpname)
               end,
               Team2Num
            )
            
      elseif Team2 == "FO" then
            FO_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.FO." .. cpname)
               end,
               Team2Num
            )
            
      elseif Team2 == "RES" then
            RES_CAPTURE = OnFinishCaptureTeam(
               function(post)
                  local cpname = GetEntityName(post)
                  ShowMessageText("level.BS1.CPMESSAGE.CAP.RES." .. cpname)
               end,
               Team2Num
            )
      end
   end
end
