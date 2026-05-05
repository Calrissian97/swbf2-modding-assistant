# Addme scripts
This document explains how addme scripts from addon mod-folders work to add their maps/missions to the game interface for selection and launching.

Sections:
- Addme.lua Overview (lines 10-11)
- Example Addme.lua (lines 13-46)

---

# Overview
Addme scripts are used by addons to add their maps/missions to the game interface to make them selectable. To add a custom era to an existing map, special handling of the mission tables is required. Notably, instead of compiling into lvl files these are munged into `.script` files and left unpacked (not packed into a `.lvl` file) inside each mod's addon folder (GameData/Addon/...).

# Example Addme.lua
```
-- recursively merges the second given table into the first given table
function MergeTables( mission, newFlags )
    --for each table entry,
    local array = type({})
    for key,value in pairs(newFlags) do
        --check for nested tables
        if type(value) == array then
            --mission must have this key as a table too
            if type(mission[key]) ~= array then
                mission[key] = {}
            end
            --merge these two tables recursively
            MergeTables(mission[key], value)
        else
            --the key is a simple variable, so simply store it
            mission[key] = value
        end
    end
end

--Search through the missionlist to find a map that matches mapName,
--then insert the new flags into said entry.
--Use this when you know the map already exists, but this content patch is just
--adding new gamemodes (otherwise you should just add whole new entries to the missionlist)
function AddNewGameModes(missionList, mapName, newFlags)
    for i, mission in missionList do
        if mission.mapluafile == mapName then
            MergeTables(mission, newFlags)
        end
    end
end
```
