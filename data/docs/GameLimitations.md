# Zero Engine Limitations
This document explains "hardcoded" limitations of the Zero Engine used for Star Wars Battlefront 2.

Sections:
- Animation Limitations (lines 17-19)
- Model Limitations (lines 21-23)
- Material Limitations (lines 25-27)
- Texture Limitations (lines 29-30)
- Game Entity Limitations (lines 32-52)
- Team Limitations (lines 54-59)
- World Limitations (lines 61-75)
- Sound Limitations (lines 77-81)
- Script Limitations (lines 83-84)

---

# Animations
- Maximum of 18 soldier animation banks.
- Maximum of 32 animations per world.

# Models
- Units consisting of more than 32 keyed nodes will crash your map.
- Units may have up to 30 bones in their skeleton, 32 including boneroot and dummyroot. A workaround is addon geometry (wookiee hair tentacles).

# Materials
- Too many bumpmapped-materials can sometimes cause framerate drops or even crashing (simple ports of the Rhen Var: Citadel map to SWBF2 will encounter this). It would seem SWBF1 was better-equipped to handle numerous props requiring this shading as opposed to SWBF2 which prefers larger or merged props.
- Too many animated materials can also dig too deep into the game's animation memory, causing errors/crashes.

# Textures
- Maximum texture size is 4096x4096.

# Classes
- Every dispensable turret on the map uses the same weapon as the last dispensable turret loaded from the lua. Workaround is having a side that loads all the dispensable turrets as classes (via req files), loading that side in the lua before the other sides, and having the various dispenser weapons dispense those already-loaded turrets.
- Vehicles can only have two weapons for each position, a primary and a secondary.
- Maximum of 8 unit slots per vehicle. 
- There are only two weapon channels. Primary (WeaponChannel = 0) and secondary (WeaponChannel = 1).
- Each unit can have up to 8 weapons. Any combination of primary and secondary weapon sections. If using WeaponName<int> and WeaponAmmo<int>, each channel can have only 4.
- Weapon Sections cannot be overriden, however WeaponName<int> and WeaponAmmo<int> can be overridden via SetClassProperty in lua.
- Certain changes made to a unit class via SetClassProperty in lua only take effect for new units spawned thereafter. Existing units will remain unchanged until respawned.
- You cannot fire a flyer's weapons while inside a Landing Region.
- Flyers cannot strafe (move side to side) as they did in SWBF1.
- Prone is deprecated and does not work in SWBF2.
- Maximum of 4 tentacles can be defined in the unit's ODF with a total of 20 bones (24 bones max).
- You can't modify the Droideka or Fambaa shield effect geometry.
- You can't change which bone the JetEffect property uses as the attach origin (always bone_ribcage).
- The limit for damage effects called for in the ODF is 10.
- Maximum of 16 ODFs can be used with the AttachODF property in a single entity's ODF.
- Indentation characters (tabs) **CANNOT** be used within the entered value of a VOSound parameter in an ODF.
- You cannot change command post team colors (outside of using shaderpatch). You *can* change neutral colors.
- A unit can not have a secondary weapon and no primary weapon. (com_weap_null can be assigned as primary as a workaround).
- Heroes can't have invisibility weapons due to constant "damage" by the hero timer.
- Ordnance always originates from bone_head for soldier entities.

# Teams
- Up to 9 selectable units per team + 1 hero, or 10 units with no hero.
- Maximum of 9 teams total (0-8), including the regular ATT and DEF teams (1 and 2).
- Maximum of 20 AI Goals. Going over this limit won't crash the map, but will cause severity 3 messages.
- Human characters can only spawn for teams 1 or 2, but you can give the *illusion* of up to 9 selectable teams.
- Total unit counts above ~300 tend to cause instabilities.

# Worlds
- Water can only be painted on one height level in ZeroEditor.
- Water above a unit's head will always damage a standard unit class. Non-standard units are Droideka's and Vehicles. These have modifiable Damage rates via WaterDamageInterval and WaterDamageAmount in their ODFs.
- Maximum of 16 Command entities (Command Posts + Command Vehicles). 
- Maximum of 64 simultaneously active regions (activated with ActivateRegion).
- Maximum of 1024 world objects.
- Maximum of 8 AI planning connections to a single hub.
- Maximum of 255 total AI planning connections.
- Maximum of 256 total AI planning hubs.
- ZeroEditor will crash when attempting to load models mapped to textures larger than 12MB in file size.
- Maximum terrain height is 327 and minimum is -327.
- SetWorldExtents(#) values 19000 or higher will crash your map.
- Only 50 lanes can be drawn between planets in galactic conquest.
- Having more than 26 doors in a map will cause the game to freeze and eventually crash during loading.
- SWBF2 has a 16 camera shot limit.

# Sounds
- Every sound bank file (*.asfx and *.sfx files) that is loaded into memory (through ReadDataFile()) must have a unique name.
- Sound LVL files containing soundspace region configurations must be loaded before world LVL files that contain soundspace regions.
- Each world can only fit ~32MB worth of sound effect samples.
- Between 445-450 max sound streams for global music.

# Scripts
- Creating more than 64 timers causes the game to freeze.
