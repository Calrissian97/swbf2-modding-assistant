--This is the primary script for CGC
print("custom_gc_8: Entered ANF GC")

-- Read localization
ReadDataFile("..\\..\\addon\\ZZZ\\data\\_LVL_PC\\core.lvl")

-- Button Tag (Different for every GC)
local gcTag = "ANF"
local gcString = "level.ANF.GC.FO"

-- Load the setup scripts
ScriptCB_DoFile("ifs_freeform_init_ANF")
ScriptCB_DoFile("ifs_freeform_start_ANF")

if ifs_freeform_main then
	
end
if ScriptCB_DoFile then

	--check for possible loading errors
	if ANF_ScriptCB_DoFile then
		print("ANF: Warning: Someone else is using our ANF_ScriptCB_DoFile variable!")
	end
	
	--backup the current ScriptCB_DoFile function
	ANF_ScriptCB_DoFile = ScriptCB_DoFile

	--this is our new ScriptPostLoad function
	ScriptCB_DoFile = function(...)
		
		-- If the argument was "ifs_freeform_battle_mode" intercept and load our script directly after!
		---[[
		if arg[1] == "ifs_freeform_battle_mode" then
			ANF_ScriptCB_DoFile(arg[1])
			if gcTag == "ANF" then
				ANF_ScriptCB_DoFile("ANF_ifs_freeform_battle_mode")
				print("ANF: Our GC Battlemode has been patched through!")
				print("Calrissian97 Sends his Regards!")
			end
		--]]
		--[[
		elseif arg[1] == "metagame_state" then
				ANF_ScriptCB_DoFile(arg[1])
				if gcTag == "ANF" then
					ANF_ScriptCB_DoFile("ANF_metagame_state")
					print("ANF: Our GC Metagamestate has been patched through!")
				end
		--]]
		---[[
		elseif arg[1] == "ifs_freeform_main" then
				ANF_ScriptCB_DoFile(arg[1])
				if gcTag == "ANF" then
					ANF_ScriptCB_DoFile("ANF_ifs_freeform_main")
					print("ANF: Our GC Main has been patched through!")
				end
		--]]
		--[[
		elseif arg[1] == "ifs_meta_main" then
				ANF_ScriptCB_DoFile(arg[1])
				if gcTag == "ANF" then
					ANF_ScriptCB_DoFile("ANF_ifs_meta_main")
					print("ANF: Our GC MetaMain has been patched through!")
				end
		--]]
		else
			--make sure to forward the method call to the real ScriptCB_DoFile, so the game can function normally
			ANF_ScriptCB_DoFile(arg[1])
		end
	end
	
else
	print("ANF: Warning: No ScriptCB_DoFile() to take over")
	print("ANF_Remaster: Exiting custom_gc_8...")
	return
	
end

-- Startup Script
local start_gc = ifs_freeform_start_ANF

------------------------------ Button Section -------------------------------
--add a button to the shell for our custom Galactic Conquest
if custom_GetGCButtonList then
	print("custom_gc_8: Taking control of custom_GetGCButtonList()...")
	
	--check for possible loading errors
	if cgc8_custom_GetGCButtonList then
		print("custom_gc_8: Warning: Someone else is using our cgc8_custom_GetGCButtonList variable!")
		print("custom_gc_8: Exited")
		return
	end
	
	--backup the current custom_GetGCButtonList function
	cgc8_custom_GetGCButtonList = custom_GetGCButtonList

	--this is our new custom_GetGCButtonList function
	custom_GetGCButtonList = function()
	    print("custom_gc_8: custom_GetGCButtonList(): Entered")
	    
	    --get the button table from the real function
	    local list = cgc8_custom_GetGCButtonList()
	    
	    --add in the button for our Galactic Conqust
	    local ourButton = { tag = gcTag, string = gcString, }
		table.insert( list, 1, ourButton )	    
	    
	    print("custom_gc_8: custom_GetGCButtonList(): Exited")
	    return list
	end
else
	print("custom_gc_8: Warning: No custom_GetGCButtonList() to take over")
	print("custom_gc_8: Exited")
	return
end
---------------------------------------------------------------------------

--listen for when our Galactic Conquest button is clicked
if custom_PressedGCButton then
	print("custom_gc_8: Taking control of custom_PressedGCButton()...")
	
	--check for possible loading errors
	if cgc8_custom_PressedGCButton then
		print("custom_gc_8: Warning: Someone else is using our cgc8_custom_PressedGCButton variable!")
		print("custom_gc_8: Exited")
		return
	end
	
	--backup the current custom_GetGCButtonList function
	cgc8_custom_PressedGCButton = custom_PressedGCButton

	--this is our new custom_GetGCButtonList function
	custom_PressedGCButton = function( tag )
	    print("custom_gc_8: custom_PressedGCButton(): Entered")
	    
	    --not our conquest, so let the game process it normally
	    if tag ~= gcTag then
		    return cgc8_custom_PressedGCButton(tag)
	    end
	    
	-- Do specific work now
	    --it is our Galactic Conquest button, so get our game going
	    start_gc(ifs_freeform_main) --ANF_ifs_freeform_main
	    
	    print("custom_gc_8: custom_PressedGCButton(): Exited")
	    return true
	end
else
	print("custom_gc_8: Warning: No custom_PressedGCButton() to take over")
	print("custom_gc_8: Exited")
	return
end

print("custom_gc_8: Exited ANF GC")

