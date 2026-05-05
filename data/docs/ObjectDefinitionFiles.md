# Object Definition Files
This file explains ODF files and how game objects are defined in Star Wars Battlefront 2. It also lists all valid ODF properties for each specific class.

Sections:
 - ODF Overview (lines 26-41)
 - ODF ClassLabels Reference (lines 43-287)
 - ODF Inheritance System (lines 289-296)
 - Vehicle and Infantry ODF Structure (lines 298-344)
 - ODF File Schema (lines 346-355)
 - Controllable Objects and Piloted Properties (lines 357-421)
 - Vehicle, Flyer, and Trackable Properties (lines 423-493)
 - Weapon Class Properties (lines 495-622)
 - Weapon Class Sub-classes (lines 624-870)
 - Explosion Class Properties (lines 872-921)
 - Ordnance Class Properties and Sub-classes (lines 923-1123)
 - GameObject Class Properties (lines 1125-1173)
 - Geometry and Building Properties (lines 1175-1496)
 - Turret, Station, and Droid Properties (lines 1498-1711)
 - Flyer and Hover Vehicle Properties (lines 1713-1933)
 - Item, Mine, and Pickup Properties (lines 1935-2014)
 - Remote Terminal, Soldier (units), and Walker Properties (lines 2016-2272)
 - Light, Visual Effect, Sound, and Vehicle Spawn Properties (lines 2274-2499)

 ---

# ODF Overview
Entities in Battlefront 2 are defined via ODF files, which inherit properties depending on their entity class. For example an ODF with a "animatedprop" class label will inherit class properties from the "prop" class.

## Classes and hierarchies
ODF files contain information that defines an object's presence in the editor as well as in the game. 
At the top of every ODF are lines that at least start with this:
```
[GameObjectClass]
ClassLabel = "someclasslabel"
[Properties]
```
The GAMEOBJECTCLASS section define the properties needed by zeroeditor to view and manipulate the object.
CLASSLABEL refers to the object's functional class. This is for use in the game primarily, but in some cases it is used to expose an object's properties within the editor.
GEOMETRYNAME is the mesh file reference that ultimately makes an object visible in the editor. 
PROPERTIES is where the beginning of the in game properties are defined. 
In addition to GAMEOBJECTCLASS there are other classtypes that are defined in ODFs that are not viewed in the editor. These include WEAPONCLASS, ORDNANCECLASS, and EXPLOSIONCLASS. These headers are applied to ODFs that are typically called by other ODFs as child objects. For example a weapon is always attached to a unit, vehicle or building, and an explosion is always attached to a type of ordnance or an object. Some ODFs may also have properties that should be unique to each instance. These properties will have a line that appears like this: `[InstanceProperties]` and all properties below this line will have their default values overriden by those set inside zeroeditor.

# ODF ClassLabels
There are over 60 ClassLabels in Battlefront 2. Understanding the inheritance hierarchy is key to efficient ODF modding.

## Classlabel Hierarchy Visualization
```
entityclass (Base ClassType)
|
├── gameobjectclass (ClassType)
|   |
|   ├── asteroid
|   |
|   ├── building
|   |   |
|   |   ├── animatedbuilding
|   |   |   |
|   |   |   ├── commandpost
|   |   |   |
|   |   |   └── armedanimatedbuilding
|   |   |       |
|   |   |       └── commandarmedanimatedbuilding
|   |   |
|   |   ├── armedbuilding
|   |   |   |
|   |   |   └── armedbuildingdynamic
|   |   |
|   |   ├── defensegridturret
|   |   |
|   |   ├── destructablebuilding
|   |   |
|   |   ├── portableturret
|   |   |
|   |   └── powerupstation
|   |   |
|   |   └── trap
|   |
|   ├── cloth
|   |
|   ├── cloudcluster
|   |
|   ├── droid
|   |
|   ├── dusteffect
|   |
|   ├── flyer
|   |   |
|   │   ├── commandflyer
|   |   |
|   │   └── carrier
|   |
|   ├── godray
|   |
|   ├── grasspatch 
|   |
|   ├── hologram
|   |
|   ├── hover
|   |   |
|   │   └── commandhover
|   |
|   ├── item
|   |   |
|   │   ├── flag
|   |   |
|   │   ├── mine
|   |   |
|   │   └── powerupitem
|   |
|   ├── leafpatch
|   |
|   ├── light
|   |
|   ├── prop
|   |   |
|   |   ├── door
|   |   |
|   |   └── animatedprop
|   |
|   ├── remoteterminal
|   |
|   ├── rotatingmodel
|   |
|   ├── rumbleeffect
|   |
|   ├── soldier
|   |
|   ├── soundambiencestatic
|   |
|   ├── soundambiencestreaming
|   |
|   ├── vehiclepad (Deprecated?)
|   |
|   ├── vehiclespawn
|   |
|   ├── walker
|   |   |
|   |   ├── commandwalker
|   |   |
|   |   └── walkerdroid
|   |
|   └── water (Deprecated?)
|
├── explosionclass (ClassType)
|
├── ordnanceclass (ClassType)
|   |
│   ├── beam
|   |
|   ├── beacon
|   |
│   ├── bolt
|   |
│   ├── bullet
|   |
│   ├── emitterordnance
|   |
│   ├── fatray
|   |
│   ├── grapplinghook (Deprecated in BF2)
|   |
│   ├── haywire
|   |
|   ├── meleethrowordnance
|   |
│   ├── missile
|   |
│   ├── shell
|   |
│   ├── sticky
|   |
│   └── towcable
|
└── weaponclass (ClassType)
    |
    ├── binoculars (Deprecated?)
    |
    ├── cannon
    |
    ├── catapult (Deprecated in BF2)
    |
    ├── destruct
    |
    ├── detonator
    |
    ├── disguise (Deprecated in BF2)
    |
    ├── dispenser
    |
    ├── grapplinghookweapon (Deprecated in BF2)
    |
    ├── grenade
    |
    ├── launcher
    |
    ├── melee
    |
    ├── meleethrow
    |
    ├── remote
    |
    ├── repair
    |
    ├── shield
    |
    └── towcableweapon
```

## ClassLabel Reference
| ClassLabel | Inherits From | Description |
| :--- | :--- | :--- |
| **animatedbuilding** | `building` | building subclass with animation properties |
| **animatedprop** | `prop` | prop subclass with animation properties |
| **armedanimatedbuilding** | `animatedbuilding` | animatedbuilding subclass with weapon properties |
| **armedbuilding** | `building` | building subclass with weapon properties |
| **armedbuildingdynamic** | `armedbuilding` | deprecated? armedbuilding subclass with team-color properties |
| **asteroid** | `gameobjectclass` | destructible entity that may spawn more asteroids upon destruction |
| **beacon** | `ordnanceclass` | used by orbital strike weapon |
| **beam** | `ordnanceclass` | continuously firing laser ordnance |
| **binoculars** | `weaponclass` | deprecated? binoculars weapon |
| **bolt** | `ordnanceclass` | laser bolt ordnance |
| **building** | `gameobjectclass` | similar to prop with additional properties such as health |
| **bullet** | `ordnanceclass` | non-laser bolt ordnance |
| **cannon** | `weaponclass` | firing weapon that projects a damaging and/or pushing ordnance |
| **carrier** | `flyer` | deprecated flyer subclass, once used by carrier classes to deploy walkers during prototyping |
| **catapult** | `weaponclass` | deprecated, once used on BF1 Endor for ewok weapons |
| **cloth** | `gameobjectclass` | cloth simulation entity; collides with cloth collision primitives in msh |
| **cloudcluster** | `gameobjectclass` | deprecated? cluster of dusteffect entities |
| **commandarmedanimatedbuilding** | `armedanimatedbuilding` | armedanimatedbuilding subclass with soldier-spawning properties |
| **commandflyer** | `flyer` | flyer subclass with soldier-spawning properties |
| **commandhover** | `hover` | hover subclass with soldier-spawning properties |
| **commandpost** | `animatedbuilding` | contestable team-aligned entity with unit and vehicle spawning properties |
| **commandwalker** | `walker` | walker subclass with soldier-spawning properties |
| **defensegridturret** | `building` | building subclass specifically for defending command posts |
| **destruct** | `weaponclass` | self-destruct weapon that damages enemies within a radius |
| **destructablebuilding** | `building` | building subclass with health and destroyed geometry properties |
| **detonator** | `weaponclass` | weapon that produces a remotely-detonated weapon when triggered twice |
| **disguise** | `weaponclass` | switches unit model to first unit of opposing team (deprecated) |
| **dispenser** | `weaponclass` | dispenses entities such as ammo/health item powerupitems or portableturrets |
| **door** | `prop` | prop subclass with proximity-based animation properties |
| **droid** | `gameobjectclass` | controllable entity with weapon and physics properties |
| **dusteffect** | `gameobjectclass` | textured billboard particle effects with no collision |
| **emitterordnance** | `ordnanceclass` | ordnance that emits a propagating particle effect with additional properties |
| **explosion** | `explosionclass` | damages and/or pushes other entities |
| **fatray** | `ordnanceclass` | ordnance with volume and effect properties |
| **flag** | `item` | item subclass for a carryable entity |
| **flyer** | `gameobjectclass` | flying vehicle with landing/takeoff, weapons, rolling, flipping, and animation properties |
| **godray** | `gameobjectclass` | fake volumetric lighting effect with no collision |
| **grapplinghook** | `ordnanceclass` | deprecated ordnance similar to the towcable |
| **grapplinghookweapon** | `weaponclass` | deprecated weapon for pulling units |
| **grasspatch** | `gameobjectclass` | game-animated foliage entity |
| **grenade** | `weaponclass` | weapon for projecting timed explosive ordnance |
| **haywire** | `ordnanceclass` | timed ordnance that disables vehicles and forces pilots to exit |
| **hologram** | `gameobjectclass` | entity with geometry, flicker, rotate, light, and beam properties with no collision |
| **hover** | `gameobjectclass` | hovering vehicle with jumping, weapons, animation, and hovering properties |
| **item** | `gameobjectclass` | base class for mines, powerupitems, and flags |
| **launcher** | `weaponclass` | weapon that projects a missile ordnance |
| **leafpatch** | `gameobjectclass` | game-animated foliage entity |
| **light** | `gameobjectclass` | light entity, no geometry or collision |
| **melee** | `weaponclass` | melee weapon |
| **meleethrow** | `weaponclass` | throwable melee weapon |
| **meleethrowordnance** | `ordnanceclass` | ordnance used for meleethrow weapons |
| **mine** | `item` | dispensed item that destructs on repair, explodes on close enemy proximity |
| **missile** | `ordnanceclass` | ordnance that can lock onto and turn towards enemies |
| **portableturret** | `building` | building subclass for deployable turrets by dispenser weapons |
| **powerupitem** | `item` | pickup entity granting effects on collision |
| **powerupstation** | `building` | building subclass that grants an entity an effect when nearby |
| **prop** | `gameobjectclass` | entity with health and geometry properties |
| **remote** | `weaponclass` | weapon allowing for deployment and control of a controllable entity remotely |
| **remoteterminal** | `gameobjectclass` | enterable terminal to control linked entities remotely |
| **repair** | `weaponclass` | weapon that adds health or disables enemy vehicles |
| **rotatingmodel** | `gameobjectclass` | rotating geometry |
| **rumbleeffect** | `gameobjectclass` | shakes camera and triggerse controller rumble |
| **shell** | `ordnanceclass` | ordnance with gravity? |
| **shield** | `weaponclass` | weapon that produces a shield to protect the wielding entity until depleted |
| **soldier** | `gameobjectclass` | controllable infantry unit entity |
| **soundambiencestatic** | `gameobjectclass` | in-memory sound-playing entity |
| **soundambiencestreaming**| `gameobjectclass` | disk-streamed sound-playing entity |
| **sticky** | `ordnanceclass` | explosive ordnance that may stick to certain entities upon collision |
| **towcable** | `ordnanceclass` | ordnance that forms a segmented "cable" that may stick to certain entities |
| **towcableweapon** | `weaponclass` | weapon that projects a towcable ordnance |
| **trap** | `building` | triggers damage and animation upon approach by an enemy entity |
| **vehiclepad** | `gameobjectclass` | deprecated vehicle spawning platform? |
| **vehiclespawn** | `gameobjectclass` | spawning entity for specified vehicle class(es) |
| **walker** | `gameobjectclass` | vehicle class that walks with additional properties |
| **walkerdroid** | `walker` | walker subclass used for droideka |
| **water** | `gameobjectclass` | deprecated? only seen in yavin world assets |

# ODF Hierarchy
We used a hierarchy system in Battlefront II that allowed us to keep commonly used functions within one ODF file. This benefit to this system is that it allowed us to make sweeping changes to everything linked to this one file in one shot.
For instance, every faction’s rocket launcher class weapon was linked to a 'parent' rocket launcher. We knew we wanted to keep all of the rocket launcher classes balanced the same, for the most part, so there was no need to change how much damage each rocket would be able to inflict from one faction to another. Rather than giving each of the faction’s ODF files its own unique `MaxDamage` function, we instead placed `MaxDamage` within the parent file. When we decided that rocket launcher classes were doing too little damage, this let us change one file rather than having to update four files. Since the parent was changed, everything that linked to the parent would change as well. As you could imagine, this allowed us to save a lot of time.
imp_weap_inf_rocket_launcher_ord.odf. in ...sides/imp has a `ClassParent = com_weap_inf_rocket_launcher_ord` property below the class label. com_weap_inf_rocket_launcher_ord.odf in ...sides/Common has the parent properties, while the child has only parameters needed to distinguish itself. Any property put into the child file will overwrite the property in the parent file.
For a more complicated example, see rep_inf_rifleman.odf in ...sides/rep.
Notice its `ClassParent`, rep_inf_default_rifleman.odf. We separated the two files to allow two people to edit various aspects of the Republic assault trooper without stepping on each others toes. The rep_inf_rifleman file adjusts the visual properties of the soldier; the armor he wears, etc., while rep_inf_default_rifleman allows someone else to adjust the weapon properties. In this case, rep_inf_default_rifleman is the parent which is found in the same folder. Parent files don’t have to be within a specific folder, they just need to exist within the data directory. In this case, it’s not found within the Common folder because this particular hierarchy has four steps. The file it links to next, rep_inf_default.odf, is also found within the same folder. All of the default Republic ODF infantry files (these files control the weapon loadouts for each class) can share several of the same functions. The ones that need to be unique are found within each of the specific unit’s ODF file. The ones that can be shared among them will be found in rep_inf_default.
Since a lot of the Republic soldiers share similar properties (most notably sounds, animations, etc.), it made sense to group them up into a single parent file. Notice though, within this parent file, there is a link to yet another parent file. This file links to the Common folder (not the ...sides/Common folder), where you’ll find com_inf_default.odf.
We did this for the same reason we did it to the rocket launcher files. All of the infantrymen have similar properties. They fire the same types of weapons (not visually, but rather numerically they are similar), have the same range, move at the same speed, etc. There’s no need to copy and paste all of this information multiple times.

# Vehicle ODF Files
I hope to give you a better idea of how to manipulate the vehicle ODF files in this section. Just note that vehicles can change from one to another. Some have multiple seating, some are hovers, some walk, others fly, and some have unique abilities. It would take a book to give you an idea of how to get every one of them working, so let’s just start with something simple and hopefully you can take it from there.
Let's use the CIS Snailtank as an example, cis_tread_snailtank.odf in ...sides/cis/odf.
We’re going to start from the top and go down. I’m going to skip to the functions that clearly define the vehicle. I might describe sections in chunks for ease of understanding.
`ClassLabel` – The type of vehicle this is. This is used to determine whether or not it’s a walker, a hover, a flyer, etc. This definition is important since various vehicles have properties the other type wont. For instance, imperial walkers, along with any other walker vehicle, rely heavily on animations. Hovers can get over obstacles other ground based vehicles can’t. Flyers can… well, fly. Changing the ClassLabel will cause you problems if you don’t add in the necessary functions to make the new ClassLabel work.
`GeometryName` – This is the actual mesh that’s being called in through the ODF.
`VehicleType` – This plays into the collision system and how the vehicle will interact with the world.
`ReserveOneForPlayer` – Determines whether or not an AI unit can jump into the vehicle.
`MapTexture`, `HealthTexture` – The 2D image displayed on your HUD.
`VehiclePosition` – Where the player’s character will sit once they’ve entered the vehicle.
`MapScale` – How close you are zoomed in to the mini-map.
`Explosion`, `ExplosionCritical`, `ExplosionDestruct` – Various states of destruction. You will call the appropriate ODF file depending on the cause of “death” to the vehicle.
`FirstPersonFOV` – What your frame of view will be when seated inside the vehicle.
`CockpitTension`, `CollisionScale`, `CollisionThreshold` – Various functions that deal with the vehicle’s collision against other vehicles, objects, etc.
`MaxHealth` – The vehicle’s maximum health value.
`HealthType` – This determines whether it can be healed by a fusion cutter or not, and other conditions.
`HitLocation` – The collision primitive node name of its critical hit point. The number at the end determines its multiplier. For instance, the “4” means this location causes 4x the normal damage.
`TimeRequiredToEject` – How long it will take to hack someone out of the vehicle.
`EjectResistance` – The higher this resistance it, the more it opposes the the hacking attempt, thus making the `TimeRequiredToEject` higher and regenerate back to full quicker.
`TimeTilReboard` – After the person is hacked out, how long it takes for anyone to be allowed to re-enter the vehicle.
`SetAltitude`, `GravityScale`, `LiftSpring`, `LiftDamp` – These adjust the hover properties of the vehicle and how they collide with the world.
`Acceleration`, `Deceleration`, `Traction`, `ForwardSpeed`, `ReverseSpeed`, `StrafeSpeed` – Adjust the speed values of the vehicle in its various states of movement.
`FloatsOnWater` – Whether or not it can float on water as a hover vehicle type.
`EnergyBar`, `EnergyOverheat`, `EnergyAutoRestore`, `EnergyBoostDrain`, `BoostSpeed`, `BoostAcceleration`, `BoostFOV` – These values adjust the vehicle’s energy, and how quickly it uses this value, regenerates it, boost speed and the frame of view when boosting.
From `AddSpringBody` down to `OmegaZDamp`, these values play into where the “collision spheres” are located on the hover vehicle. Hovers use a procedurally created collision system, which are simply spheres placed at different X,Y, Z coordinates of the vehicle.
`SpinRate`, `TurnRate`, `TurnFilter`, `PitchRate`, `LevelSpring`, `LevelDamp` – These affect the control of the vehicle through a peripheral, such as a mouse, joystick, etc.
`EyePointOffset`, `TrackCenter`, `TrackOffset`, `TiltValue`, `NormalDirection` – Camera placement parameters that use an X, Y, Z orientation system.
`PitchLimits`, `YawLimits` – The limitations of how far the camera can pitch or yaw until it hits a “wall”.
`WHEELSECTION` – This section controls the Snailtanks’s tread animation.
`WEAPONSECTION` – A vehicle can have two weapon sections. Each will call its own weapon ODF file and have its own properties. These properties will control where the ordnance is firing from, how many guns there are that fire the ordnance, the ammo count, etc.
`FLYERSECTION` – NOTE that the Snailtank doesn’t have a `FLYERSECTION` since it’s a one-man vehicle. Untrue to its name, any vehicle that can support a passenger has a `FLYERSECTION`. These use functions found through the regular vehicle’s ODF file, so check out a vehicle (such as the CIS’s AAT, the Imperial AT-ST, etc.) that has multiple positions for an example on how it’s set up.
`WakeEffect` – The water animation played when the vehicle is touching water.
`CHUNKSECTION` – These sections define the vehicle when it has exploded. They determine what geometry is used, how they will disperse, etc.
`AISizeType` – This plays into the collision system and AI planning of how the vehicle will interact with the world.
`DamageStartPercent`, `DamageStopPercent`, `DamageEffect`, `DamageAttachPoint` – The damage effects played at various health levels of the vehicle.
`EngineSound` down to `FoleyFXGroup` will manipulate the sounds the vehicles will use, the music you’ll hear and the sound effects that can play while inside them.

# Infantry ODF Files
Infantry units use a lot of the hierarchy system we’ve set up for SWBFII. Bear with me as we jump through them all.
Let’s use the CIS Battledroid for our example, cis_inf_rifleman.odf in ...sides/cis/odf.
This odf file specifically deals with the way our infantry unit will look. These functions will call in the mesh to be used, the type of unit it is, and where its head collision is found (used for critical headshots). This file is pretty straightforward.
Let’s move to the next file, cis_inf_default_rifleman.odf in the same folder.
This is where the weapons are found and specific class VO (voice over sounds) functions are found. From here it links to specific weapon ODF files and the specific VO used when the player uses AI commands.
After that we move to another parent file, cis_inf_default.odf, in the same directory.
Here’s a file that’s shared among the CIS infantry units. This section is mainly reserved to call the CHUNKSECTION (explosion effects) and universal sounds each of the CIS infantry units will make. Changing something here will change the properties in all of the CIS infantry units.
Last, but not least, we have our last file, com_inf_default.odf in ...Common/odfs.
This file covers all of the infantry units (minus ones like the Droideka, which is a completely different entity and much more like a vehicle). Changing something here will change every infantry unit. You’ll be able to control their speeds when running, strafing and crouching, the camera at these different positions, the energy they have and the energy cost for various abilities. It will also affect the drop rate of the health, ammo and special canisters, and what will drop from them. Most of the function names are self-explanatory, and others share the same properties as the ones found in the Vehicle ODF documentation.

# Schema
```
[ClassTypeHere]
ClassLabel = "ClassLabelHere"
ClassParent   = "ClassParentODFHere" // optional parent class to inherit properties from
GeometryName  = "MshFilenameHere.msh" // required to display the object within the zeroeditor
GeometryScale = FloatValue // required to display correct scaling of the object within zeroeditor if scaled via msh.option file
[Properties]
PropertyNameHere = "PropertyValueHere" // Unique class properties
```

# Controllable Objects
Controllable objects support camera views and first person models. These classes are controllable:
```
Droid
Droideka
Flyer
Hover
RemoteTerminal
Soldier
Walker
MountedTurret
PassengerSlot
```

# Valid Properties
Note: If no value type is given, it's default value type is a string value, e.g. `AutoAimSize = "1.0"`. When values are "0" or "1", 0 is disabled, 1 is enabled. Values in <> brackets are arbitrary, multiple values in "" quotes are all possible values.

# Piloted Controllable Object Properties
```
ThirdPersonFOV: "<int>" // Third Person Field of View (degrees)
FirstPersonFOV: "<int>" // First Person Field of View (degrees)
ForceMode: "0", "1", "2" // Whether to force "1" third person, "2" first person, or "0" neither
VehiclePosition: "<localizationStr>" // Localization string of vehicle position
CockpitTension: "<int>" // "Tightness" of cockpit during accel/deccel
NumBobPoints: "<int>" // Number of points of "path" of camera-bob?
BobVector: "<float> <float> <float>" // Vector of camera bobbing motion?
BobSlope: "<int>" // "Steepness" of acceleration curve of bobbing?
BobOrient: "<int>" // Multiplier or toggle of bobbing affecting camera orientation?
BobRSlope: "<int>" // "Steepness" of curve for bobbing affecting camera rotations?
BobTime: "<float> // Duration of a camera-bobbing cycle?
ShakeScale: "<float>" // Multiplier for camera shake intensity?
PilotPosition: "<nodeName>" // Name of node on vehicle model to constrain pilot to
AnimatedPilotPosition
Pilot9Pose: "<animName>" // Animation for piloting unit (9-pose animation)
PilotAnimation: "<animName>" // Animation of pilot (single pose animation)
PilotType: "none", "self", "vehicle", "remote", "vehicleself" // Type of pilot for controlling vehicle
IsPilotExposed: "0", "1" // Whether the piloting unit can be shot
PilotDeath: "fly", "fall" // Death animation to play on unit
CapturePosts: "0", "1" // Whether the entity can capture command posts
NoEnterVehicles: "0", "1" // Whether the entity can enter vehicles
IgnoreHintNodes: "0", "1" // Whether AI entity should ignore hintnodes
ControlsUnit: "0", "1" // Whether unit can use first primary and secondary weapons while inside piloted object
AnimatesUnitAsTurret: "0", "1" // Whether unit animates when inside piloted object (deprecated?)
```

# Piloted Controllable Object with Weapon Properties
```
AimerPitchLimits: "<int>" // Y-axis looking limits in degrees
AimerPitchRate: "<int>" // Y-axis looking rate in degrees per second
AimerYawLimits: "<int>" // X-axis looking limits in degrees
AimerYawRate: "<int>" // X-axis looking rate in degrees per second
AimerRestDirection: "<int> <int> <int>" // Default looking-direction in X Y Z
BarrelOffset: "<int> <int> <int>" // Offset of the barrel
AimerOffset: "<int> <int> <int>" // Offset of the aimer
AimerNodeName: "<nodeName>" // Named node of the model used for aiming
NextBarrel: "-" // Signifies start of next barrel section of a object's weapon section in an ODF
BarrelNodeName: "<nodeName>" // Named node of the model used as barrel for recoiling when firing
BarrelLength: "<float>" // Length of the barrel
BarrelRecoil: "<float>" // Amount of recoiling the barrel node will perform upon firing
FirePointName: "<nodeName>" // Named node of the model where ordnance spawns (synonymous with FireNodeName)
FireNodeName: "<nodeName>" // Named node of the model where ordnance spawns (synonymous with FirePointName)
HierarchyLevel: "0", "1" // Weapon-related, maybe if multiple barrels fire at once
FireOutsideLimits: "0", "1" // Whether the weapon can fire beyond the aimer limits
NextAimer: "-" // Signifies start of next aimer section of a object's weapon section in an ODF
```

# Vehicle Entity Properties
```
EngineSound: "<soundPropertyName>" // Parameterized engine sound
TurnOnSound: "<soundPropertyName>" // Sound played when entering vehicle
TurnOffSound: "<soundPropertyName>" // Sound played when exiting vehicle
TurningOffSound: "<soundPropertyName>" // Sound played shortly after exiting a vehicle (TurnOffTime)
WindUpSound: "<soundPropertyName>" // Deprecated?
TakeoffSound: "<soundPropertyName>" // Sound played when vehicle takesoff (flyers)
WindDownSound: "<soundPropertyName>" // Deprecated?
LandSound: "<soundPropertyName>" // Sound played when vehicle lands (flyers)
BoostSound: "<soundPropertyName> <float> <int>" // Sound played when vehicle boosts, float is speed ratio, int is accel or deccel
TurnOffTime: "<float>" // Time it takes for vehicle to turn off after exited
VehicleCollisionSound: "<soundPropertyName>" // Sound triggered when vehicle collides with something
Cockpit1stPersonSound: "<soundPropertyName>" // Sound triggered every frame when the player is in first person 
Cockpit3rdPersonSound: "<soundPropertyName>" // Sound triggered every frame when the player is in third person
ProximityMinDist: "<float>" // Distance at which proximity audio reaches maximum volume
ProximityMaxDist: "<float>" // Distance at which proximity audio becomes inaudible
Music: "<musicPropertyName>" // Default music property played when the vehicle is occupied
AllMusic: "<musicPropertyName>" // Team-specific music override for the Rebel Alliance
ImpMusic: "<musicPropertyName>" // Team-specific music override for the Galactic Empire
RepMusic: "<musicPropertyName>" // Team-specific music override for the Galactic Republic
CISMusic: "<musicPropertyName>" // Team-specific music override for the CIS
MusicSpeed: "<float>" // Playback speed multiplier for the music stream
MusicDelay: "<float>" // Delay in seconds before the music property starts playing
```

# Path-Follower Entities (Flyers)
```
PathFollowerClass: "<string>" // Identifier used to match with 'PathFollowerClass' ODF property in flyer ODFs
PathFollowerClass_CTF: "<string>" // Identifier override for Capture the Flag game modes
PathFollowerSpeed: "<float>" // Speed multiplier when following a spline path
PathFollowerTurnSpeed: "<float>" // Turn rate multiplier when following a spline path
PathFollowerAcceleration: "<float>" // Acceleration scalar for spline path traversal
PathFollowerRollAcceleration: "<float>" // Roll acceleration when navigating path curves
PathFollowerLookAhead: "<float>" // Distance in meters the AI evaluates ahead of its position to calculate banking
PathFollowerRollTolerance: "<float>" // Maximum roll angle before the AI attempts to level out
PathFollowerRollSpeed: "<float>" // Constant roll speed during path navigation
PathFollowerRollAccelerationLag: "<float>" // Smoothing factor for roll transitions
PathFollowerRollTurnFactor: "<float>" // Influence of turn rate on roll intensity
PathFollowerRollSpeedFactor: "<float>" // Influence of current speed on roll intensity
PathFollowerRollDampening: "<float>" // Resistance applied to roll oscillations
PathFollowerBranchPaths: "<int>" // Number of potential branch paths evaluated at a node
PathFollowerBranchRange: "<float>" // Search radius for finding valid branchable paths
PathFollowerBranchMaxAngle: "<float>" // Maximum angle deviation allowed for a branch to be valid
PathFollowerMinBranchDist: "<float>" // Minimum distance required between current position and potential branch
PathFollowerFlyerVsFlyer: "<float>" // Logic weight for AI air-to-air combat engagement during pathing
SquadronFormation: "<string>" // ID of the formation path used by grouped entities
SquadronSlideTime: "<float>" // Time in seconds for a unit to transition into its formation slot
SquadronMemberID: "<int>" // Assigned slot index within the formation
SquadronDistance: "<float>" // Minimum distance maintained between members of a squadron
SquadronMaxAngle: "<float>" // Maximum angular variance allowed within the formation
```

# Trackable Entity Properties
```
IconTexture: "<textureName>" // Sprite used for the unit icon on the HUD and radar
HealthTexture: "<textureName>" // Background texture for the health bar displayed over the unit
MapTexture: "<textureName>" // Icon used for the unit on the fullscreen and mini-map
HUDModel: "<meshName>" // 3D model displayed on the HUD (typically for vehicle seating)
MapScale: "<float>" // Size multiplier for the unit's icon on the map
MapSpeedMin: "<float>" // Speed threshold where map icon behavior transitions to static
MapSpeedMax: "<float>" // Speed threshold for maximum map icon scaling
MapViewMin: "<float>" // Minimum range for the unit's detection view cone
MapViewMax: "<float>" // Maximum range for the unit's detection view cone
MapTargetFadeRate: "<float>" // Speed at which the unit icon fades after losing line-of-sight
MapRangeOverall: "<float>" // Constant detection radius on the map
MapRangeShooting: "<float>" // Range at which the unit is revealed on the map when firing
MapRangeViewCone: "<float>" // Range of the directional visual detection cone
MapViewConeAngle: "<float>" // Width of the visual detection cone in degrees
RemoveFromMapWhenDead: "0", "1" // Whether to hide the icon immediately upon entity destruction
```

# Weapon Classtype Class Properties
Defines properties to be inherited by all weapon subclasses.
```
NextCharge: "<float>" // Defines the transition threshold for multi-stage ordnance charging, properties defined under this line override previous charge/base weapon values
IconTexture: "<textureName>" // HUD icon representing the equipped weapon
ReticuleTexture: "<textureName>" // Texture for the crosshair displayed when aiming
ScopeTexture: "<textureName>" // Full-screen overlay used when zoomed in
OrdnanceName: "<odfName>" // ODF property for the projectile or entity produced
AmmoPerShot: "<int>" // Ammunition units consumed per trigger pull
HeatPerShot: "<float>" // Heat added to the gauge per shot (0.0 to 1.0)
HeatRecoverRate: "<float>" // Units of heat removed per second when not firing
MagReloadTime: "<float>" // Time in seconds to reload a single magazine or charge cell
ReloadTime: "<float>" // Total time in seconds to perform a full weapon reload
ZoomMin: "<float>" // Starting field of view multiplier for zooming
ZoomMax: "<float>" // Maximum field of view multiplier for zooming
ZoomRate: "<float>" // Speed at which the zoom FOV transitions
ZoomTurnDivisorMin: "<float>" // Turnrate reduction at minimum zoom
ZoomTurnDivisorMax: "<float>" // Turnrate reduction at maximum zoom
ZoomFirstPerson: "0", "1" // Whether to force first-person view when zooming
RecoilStrengthHeavy: "<float>" // Rumble effect of large motor intensity for heavy firing states
RecoilStrengthLight: "<float>" // Rumble effect of small motor intensity for standard firing states
RecoilLengthLight: "<float>" // Duration of recoil animation for standard shots
RecoilLengthHeavy: "<float>" // Duration of recoil animation for heavy shots
RecoilDelayLight: "<float>" // Delay before recoil begins for standard shots
RecoilDelayHeavy: "<float>" // Delay before recoil begins for heavy shots
RecoilDecayLight: "<float>" // Speed at which recoil resets for standard shots
RecoilDecayHeavy: "<float>" // Speed at which recoil resets for heavy shots
MaxChargeStrengthHeavy: "<float>" // Damage/Force multiplier at full heavy charge
MaxChargeStrengthLight: "<float>" // Damage/Force multiplier at standard heavy charge
ChargeRateHeavy: "<float>" // Rumble effect of large motor intensity for heavy charge states
ChargeRateLight: "<float>" // Rumble effect of small motor intensity for standard charge states
ChargeDelayLight: "<float>" // Delay before charging begins for standard shots
ChargeDelayHeavy: "<float>" // Delay before charging begins for heavy shots
TimeAtMaxCharge: "<float>" // How long a full charge can be held before auto-firing
TriggerSingle: "0", "1" // 0-Automatic Fire, 1-Single Fire
ExtremeRange: "<float>" // Maximum theoretical distance the weapon can hit targets
LockOnRange: "<float>" // Distance threshold for acquiring a target lock
AutoAimSize: "<float>" // Radius of the auto-aim assist volume
LockOnAngle: "<float>" // Maximum angle from center for acquiring a lock
LockOffAngle: "<float>" // Angle threshold where an existing lock is lost
MinRange: "<float>" // Minimum effective range from hostile entity for AI weapon selection
OptimalRange: "<float>" // Distance AI must be from hostile entity for high priority weapon selection
MaxRange: "<float>" // Maximum effective range from hostile entity for AI weapon selection
TargetEnemy: "0", "1" // Whether the weapon targets enemy units
TargetNeutral: "0", "1" // Whether the weapon targets neutral units
TargetFriendly: "0", "1" // Whether the weapon targets allied units (for repairs/healing/buffs)
TargetAll: "0", "1" // Convenience flag to target all entities
TargetPerson: "0", "1" // Whether the weapon can target Units
TargetAnimal: "0", "1" // Whether the weapon can target Animals
TargetDroid: "0", "1" // Whether the weapon can target droids/droidekas
TargetVehicle: "0", "1" // Whether the weapon can target piloted vehicles
TargetBuilding: "0", "1" // Whether the weapon can target buildings
TargetBuildingDead: "0", "1" // Whether the weapon can target destroyed buildings
TargetBuildingUnbuilt: "0", "1" // Whether the weapon can target unbuilt buildings
TargetMine: "0", "1" // Whether the weapon can target deployed explosives
AITargetAll: "0", "1" // Convenience flag to all AI targeting all entities of any HealthType
AITargetPerson: "0", "1" // Whether AI can target units
AITargetAnimal: "0", "1" // Whether AI can target animals
AITargetDroid: "0", "1" // Whether AI can target droids/droidekas
AITargetVehicle: "0", "1" // Whether AI can target vehicles
AITargetBuilding: "0", "1" // Whether AI can target buildings
AITargetBuildingDead: "0", "1" // Whether AI can target destroyed buildings
AITargetBuildingUnbuilt: "0", "1" // Whether AI can target unbuilt buildings
AITargetMine: "0", "1" // Whether AI can target mines
GeometryName: "<meshName>" // 3D model used for the weapon in the world
WeaponName: "<string>" // Display name or localization key for the weapon
HUDTag: "<string>" // Identifier for matching with HUD oconfiguration
HighResGeometry: "<meshName>" // Detailed 3D model used for first-person views
CustomAnimationBank: "<string>" // Custom weapon animation bank to use
AnimationBank: "<string>" // Standard character animation bank (e.g., rifle, pistol)
FirePointName: "<nodeName>" // Model node where the ordnance originates
FireSound: "<soundPropertyName>" // Sound played when the weapon fires
FireSoundStop: "<soundPropertyName>" // Sound played when a continuous firing stream ends
ReloadSound: "<soundPropertyName>" // Sound played during the reload cycle
FireLoopSound: "<soundPropertyName>" // Sound looped while the trigger is held (for rapid-fire)
FireEmptySound: "<soundPropertyName>" // Sound played when trying to fire with no ammo
ChargeSound: "<soundPropertyName>" // Sound played while the weapon is charging
ChargedSound: "<soundPropertyName>" // Sound played when the weapon reaches full charge
ChargeSoundStop: "<soundPropertyName>" // Sound played when charging is cancelled
ChargeSoundPitch: "<float>" // Pitch variance applied to the charge sound
WeaponChangeSound: "<soundPropertyName>" // Sound played when switching to this weapon
OverheatSound: "<soundPropertyName>" // Sound played when the weapon reaches max heat
OverheatSoundPitch: "<float>" // Pitch variance applied to the overheat sound
OverheatStopSound: "<soundPropertyName>" // Sound played when the weapon cools below the threshold
ClankLeftWalkSound: "<soundPropertyName>" // Foley sound for left footstep during walk
ClankRightWalkSound: "<soundPropertyName>" // Foley sound for right footstep during walk
ClankLeftRunSound: "<soundPropertyName>" // Foley sound for left footstep during run
ClankRightRunSound: "<soundPropertyName>" // Foley sound for right footstep during run
JumpSound: "<soundPropertyName>" // Foley sound played when the character jumps
LandSound: "<soundPropertyName>" // Foley sound played when the character lands
RollSound: "<soundPropertyName>" // Foley sound played during a dodge roll
ProneSound: "<soundPropertyName>" // Foley sound played when going prone (deprecated?)
SquatSound: "<soundPropertyName>" // Foley sound played when crouching
StandSound: "<soundPropertyName>" // Foley sound played when standing up
BarrageMin: "<int>" // Minimum shots per burst during AI firing
BarrageMax: "<int>" // Maximum shots per burst during AI firing
BarrageDelay: "<float>" // Delay between bursts during AI firing
SniperScope: "0", "1" // Whether to enable sniper HUD when zooming
FlashRadius: "<float>" // Radius of the muzzle flash light effect
FlashWidth: "<float>" // Width of the muzzle flash billboard
FlashLength: "<float>" // Length of the muzzle flash billboard
FlashColor: "<colorRGBA>" // Color of the muzzle flash billboard
FlashLightColor: "<colorRGB>" // Color of the dynamic light produced by firing
FlashLightRadius: "<float>" // Reach of the dynamic light produced by firing
FlashLightDuration: "<float>" // How long the dynamic firing light persists
MuzzleFlashEffect: "<fxName>" // Particle effect spawned at the muzzle
ChargeUpEffect: "<fxName>" // Particle effect spawned while charging
MuzzleFlashModel: "<meshName>" // 3D model used for muzzle flash
FireAnim: "<animName>" // Specific animation sequence to play when firing
MuzzleFlash: "small_muzzle_flash", "med_muzzle_flash", "large_muzzle_flash" // Muzzle flash effect sizes
EnergyDrain: "<float>" // Stamina/Energy units consumed per shot
AutoPitchScreenDist: "<float>" // Range for vertical auto-aim tracking
AutoTurnScreenDist: "<float>" // Range for horizontal auto-aim tracking
TargetLockMaxDistance: "<float>" // Distance limit for maintaining a lock-on
TargetLockMaxDistanceLose: "<float>" // Distance where a lock-on is automatically broken
ScoreForMedalsType: "<int>" // Medal category assigned to kills with this weapon
MedalsTypeToUnlock: "<int>" // Medal requirement to access this weapon
MedalsTypeToLock: "<int>" // Medal state that restricts weapon access
InstantPlayFireAnim: "0", "1" // Whether to bypass animation blending for firing
OffhandWeapon: "0", "1" // Whether the weapon is held in the character's left hand
ReticuleInAimingOnly: "0", "1" // Hides the reticule unless the player is zoomed in
DisplayRefire: "0", "1" // Displays a cooldown bar on the HUD
AIBubbleCircle: "0", "1" // Uses a circular assist bubble for AI targeting
AIBubbleSizeMultiplier: "<float>" // Scale for the AI targeting assist volume
AIBubbleScaleDistDivider: "<float>" // Distance-based scaling factor for the targeting bubble
AIBubbleScaleClamp: "<float>" // Minimum size limit for the targeting bubble
NoFirstPersonFireAnim: "0", "1" // Disables recoil animations in first-person view
```

## WeaponAreaEffect ClassLabel Properties
```
FireType: "Repeat", "Charge", "Hold" // Method of firing trigger logic
EffectType: "Push", "Pull", "Choke", "Stun", "Mindtrick" // Type of Force/Area effect applied
AreaType: "Sphere", "Cylinder", "Arc", "Ray" // Shape of the effect's influence volume
InitialSalvoDelay: "<float>" // Delay before the first salvo starts
AreaRange: "<float>" // Distance of the effect's reach
AreaRadius: "<float>" // Width/radius of the effect's influence
AreaHeight: "<float>" // Vertical height of the area (for Cylinder)
MaxTargets: "<int>" // Maximum number of entities affected simultaneously
EffectDamage: "<float>" // Damage inflicted by the area effect
EffectStrength: "<float>" // Magnitude of the push/pull force
EffectFalloff: "<float>" // Rate at which strength decreases with distance
EnergyDrainRate: "<float>" // Energy consumed per second while active
ChargeMaxTime: "<float>" // Time to reach full charge (for Charge type)
ChargeMinStrength: "<float>" // Minimum strength multiplier at zero charge
ThrustFactor: "<float>" // Movement speed multiplier during effect use
TargetLock: "0", "1" // Whether the effect uses targeting locks
SoldierAnimation: "<animName>" // Animation played by the soldier during use
```

## Cannon ClassLabel Properties
```
ShotDelay: "<float>" // Minimum time between discrete shots
MaxPressedTime: "<float>" // Max time trigger can be held for charge/barrage
MaxSpread: "<float>" // Legacy unit for total shot variance
PitchSpread: "<float>" // Vertical shot scatter in degrees
YawSpread: "<float>" // Horizontal shot scatter in degrees
StandStillSpread: "<float>" // Scatter while standing and idle
StandMoveSpread: "<float>" // Scatter while standing and moving
StandAimSpread: "<float>" // Scatter while standing and aiming
CrouchStillSpread: "<float>" // Scatter while crouching and idle
CrouchMoveSpread: "<float>" // Scatter while crouching and moving
CrouchAimSpread: "<float>" // Scatter while crouching and aiming
ProneStillSpread: "<float>" // Scatter while prone and idle
ProneMoveSpread: "<float>" // Scatter while prone and moving
ProneAimSpread: "<float>" // Scatter while prone and aiming
KickSpread: "<float>" // Instant spread added per shot
SpreadPerShot: "<float>" // Degrees of spread added per shot/salvo
SpreadRecover: "<float>" // Degrees of spread recovered per second
SpreadRecoverRate: "<float>" // Degrees per second spread resets
SpreadThreshold: "<float>" // Degrees of spread ignored
SpreadLimit: "<float>" // Maximum cumulative spread in degrees
KickStrength: "<float>" // Magnitude of physical recoil push on aiming
KickBuildup: "<float>" // Rate at which recoil builds up
SalvoCount: "<int>" // Number of salvos per trigger pull
ShotsPerSalvo: "<int>" // Number of ordnance projectiles per salvo
SalvoDelay: "<float>" // Delay between salvos in a burst
InitialSalvoDelay: "<float>" // Delay before the first salvo of a burst
ShotPatternCount: "<int>" // Number of points in a repetitive shot pattern (number of ordnance)
ShotPatternPitchYaw: "<float> <float>" // Relative pitch/yaw offsets for pattern of ordnance
WarmUpTime: "<float>" // Seconds before weapon begins firing (spool up)
CoolDownTime: "<float>" // Seconds after firing stops before heat recovery
WarmUpSoundStartPitch: "<float>" // Starting pitch for warmup audio
WarmUpSoundFadeInTime: "<float>" // Fade in duration for warmup sound
WarmUpSoundFadeOutTime: "<float>" // Fade out duration for warmup sound
BarrelSoundFadeInTime: "<float>" // Fade in duration for barrel rotation sound
BarrelSoundFadeOutTime: "<float>" // Fade out duration for barrel rotation sound
CoolDownSoundEndPitch: "<float>" // Ending pitch for cooldown audio
CoolDownSoundFadeInTime: "<float>" // Fade in duration for cooldown sound
CoolDownSoundFadeOutTime: "<float>" // Fade out duration for cooldown sound
WarmUpSound: "<soundPropertyName>" // Audio played during spool up
BarrelSound: "<soundPropertyName>" // Audio played while barrels are rotating
CoolDownSound: "<soundPropertyName>" // Audio played during spool down
SecondaryOrdnance: "<odfName>" // Name of alternate ordnance type (deprecated?)
SecondaryOrdnanceName: "<odfName>" // Name of alternate ordnance type
SecondaryOrdnancePeriod: "<int>" // Interval for firing secondary ordnance  
```

## Launcher ClassLabel Properties
```
Ordnance: "<odfName>" // Name of the ordnance class to launch 
OrdnanceName: "<odfName>" // Name of the ordnance class to launch
LockTime: "<float>" // Time in seconds to acquire a target lock-on
TrackingSound: "<soundPropertyName>" // Sound played while acquiring/holding a lock
ClearLockOnFire: "0", "1" // Whether to drop the lock-on immediately after firing
```

## TowCable ClassLabel Properties
```
WindSound: "<soundPropertyName>" // Sound looped while the cable is attached and reeling
DetatchSound: "<soundPropertyName>" // Sound played when the cable is released or broken
```

## Destruct ClassLabel Properties
```
MaxPressedTime: "<float>" // Time required to hold the trigger for self-destruct
ExplosionClass: "<odfName>" // The explosion class triggered upon detonation
SelfDestructSoundPitch: "<float>" // Pitch variance for the self-destruct countdown
// Orbital Strike
AimAzimuth: "<float>" // Orbital strike horizontal aim offset
AimElevation: "<float>" // Orbital strike vertical aim offset
AimDistance: "<float>" // Distance from user for orbital strike impact
SalvoCount: "<int>" // Number of shells in the orbital strike barrage
SalvoDelay: "<float>" // Delay between orbital shells
InitialSalvoDelay: "<float>" // Delay before first orbital shell
ScatterDistance: "<float>" // Random radius for orbital shell variance
StrikeOrdnance: "<odfName>" // Ordnance used for orbital strike
StrikeOrdnanceName: "<odfName>" // Ordnance used for orbital strike
```

## Disguise ClassLabel Properties
`TimeToChange: "<float>" // Seconds required to complete the model swap`

## Dispenser ClassLabel Properties
```
HideOnFire: "0", "1" // Whether to temporarily hide the player model when dispensing
Ordnance: "<odfName>" // Entity to dispense (legacy)
OrdnanceName: "<odfName>" // Entity to dispense
Velocity: "<float>" // Ejection speed of the dispensed item
ShotDelay: "<float>" // Minimum time between dispense actions
MaxPressedTime: "<float>" // Maximum charge time for variable velocity
MinStrength: "<float>" // Velocity multiplier at zero charge
MaxStrength: "<float>" // Velocity multiplier at full charge
InitialSalvoDelay: "<float>" // Delay before item is created
InitialSalvoDelayProne: "<float>" // Delay override while prone
MaxItems: "<int>" // Maximum simultaneous items allowed in the world
FirePointExtraOffset: "<float> <float> <float>" // Coordinate offset for ejection point
```

## Detonator ClassLabel Properties
```
PlantedHash: "<int>" // Internal identifier for tracking planted items (deprecated?)
TriggerAll: "0", "1" // Whether to trigger all planted items or just one
```

## Remote ClassLabel Properties
```
SwitchImmediately: "0", "1" // Whether to automatically enter the remote entity on spawn
AllowDestruct: "0", "1" // Whether the user can trigger a self-destruct for the remote
Velocity: "<float>" // Initial velocity of spawned remote entity
MaxPressedTime: "<float>" // Max time held for charging throw strength
MinStrength: "<float>" // Velocity scale at minimum charge
MaxStrength: "<float>" // Velocity scale at maximum charge
```

## Grenade ClassLabel Properties
```
ShotDelay: "<float>" // Time between throws
InitialSalvoDelay: "<float>" // Delay before grenade leaves the hand
InitialSalvoDelayUnderhand: "<float>" // Delay for secondary/underhand throws
InitialSalvoDelayProne: "<float>" // Delay override while prone
ShotElevate: "<float>" // Vertical angle added to the throw arc
MaxPressedTime: "<float>" // Max time held for charging throw strength
HideOnFire: "0", "1" // Whether to hide the model during throw (deprecated?)
ForceFireAnimation: "0", "1" // Whether to bypass stance checks for throwing
```

## Invisibility ClassLabel Properties
```
InvisibilityTrigger: "0", "1", "2" // Trigger logic: "0" Press, "1" Toggle, "2" Hold
InvisibilityPersistTime: "<float>" // Seconds effect remains after deactivation
InvisibilityMax: "<float>" // Maximum transparency level (0.0 to 1.0)
InvisibilityMin: "<float>" // Minimum transparency level (0.0 to 1.0)
SpeedForInvisibilityMax: "<float>" // Speed threshold for maximum stealth
SpeedForInvisibilityMin: "<float>" // Speed threshold for minimum stealth
InvisibilityIncRate: "<float>" // Rate at which invisibility increases
InvisibilityDecRate: "<float>" // Rate at which invisibility decreases
FlickerAmplitude: "<float>" // Intensity of transparency "glitching"
FlickerTimeMin: "<float>" // Minimum time between flicker events
FlickerTimeMax: "<float>" // Maximum time between flicker events
InitialSalvoDelay: "<float>" // Delay before effect activates
InitialEnergyDrain: "<float>" // Flat energy cost to activate stealth
```

## Laser ClassLabel Properties
```
ShotDelay: "<float>" // Time between shots
SalvoTime: "<float>" // Duration of a laser burst
```

## Melee ClassLabel Properties
```
Explosion: "<odfName>" // Explosion triggered on impact
ExplosionName: "<odfName>" // Explosion triggered on impact
HitEffect: "<fxName>" // Effect spawned on contact (clears defaults)
AddHitEffect: "<fxName>" // Appends an effect to the random contact pool
HitSound: "<soundPropertyName>" // Audio played on successful hit
DeflectEffect: "<fxName>" // Effect spawned when blocking ordnance
DeflectSound: "<soundPropertyName>" // Audio played when blocking ordnance
TurnOnDuration: "<float>" // Seconds for lightsaber activation animation
OnSound: "<soundPropertyName>" // Looped audio while weapon is active
TurnOnSound: "<soundPropertyName>" // Audio played during activation
TurnOffSound: "<soundPropertyName>" // Audio played during deactivation
NumDamageEdges: "<int>" // Number of damaging edges (lightsabers/blades/etc)
DamageEdgeLength: "<float>" // Length of a damage edge from fire point
LightSaberLength: "<float>" // Length of the lightsaber blade effect
DamageEdgeWidth: "<float>" // Width of a damage edge from fire point
LightSaberWidth: "<float>" // Width of the lightsaber blade geometry
LightSaberTexture: "<textureName>" // Diffuse texture for the blade core
LightSaberGlowTexture: "<textureName>" // Texture used for the outer glow shell
LightSaberTrailColor: "<int> <int> <int> <int>" // RGBA color of the motion trail
CustomAnimationBank: "<string>" // Custom melee animation bank
ComboAnimationBank: "<string>" // Defines anim bank, weapon type, and combo file
GeometryName: "<meshName>" // Handle/Hilt model
FirePointName: "<nodeName>" // Hardpoint for blade origin on main hand
OffhandGeometryName: "<meshName>" // Weapon model for left hand
OffhandFirePointName: "<nodeName> <attachNode>" // Blade origin and attachment node for offhand
AttachedFirePoint: "<bone> <dirXYZ> <offsetXYZ>" // Procedural blade definition
```

## MeleeThrow ClassLabel Properties
```
PrimaryWeaponIndex: "<int>" // Index of the melee weapon to throw when using this ordnance
InitialSalvoDelay: "<float>" // Delay before the melee weapon is thrown
Velocity: "<float>" // Speed of the thrown melee weapon projectile
ReturnDuration: "<float>" // Seconds before the weapon returns to the user's hand
RotationRate: "<float>" // Spin speed of the thrown weapon in degrees per second
DamageLength: "<float>" // Length of the damage detection ray
DamageWidth: "<float>" // Width of the damage detection ray
LightOdf: "<odfName>" // Light ODF attached to the thrown melee weapon
LightColor: "<int> <int> <int> <int>" // RGBA color of the attached light
LightRadius: "<float>" // Radius of the attached light in meters
OnSound: "<soundPropertyName>" // Looped audio played while the weapon is in flight
```

## Repair ClassLabel Properties
```
ShotDelay: "<float>" // Time between repair pulses
SoldierHealth: "<float>" // Healing per pulse for units (legacy)
SoldierAmmo: "<float>" // Ammo restored per pulse for units (legacy)
PersonHealth: "<float>" // Healing per pulse for Units
PersonAmmo: "<float>" // Ammo restored per pulse for Units
AnimalHealth: "<float>" // Healing per pulse for Animals
AnimalAmmo: "<float>" // Ammo restored per pulse for Animals
DroidHealth: "<float>" // Healing per pulse for droids/droidekas
DroidAmmo: "<float>" // Ammo restored per pulse for droids/droidekas
VehicleHealth: "<float>" // Repair per pulse for vehicles
VehicleAmmo: "<float>" // Ammo restored per pulse for vehicles
BuildingHealth: "<float>" // Repair per pulse for buildings
BuildingAmmo: "<float>" // Ammo restored per pulse for buildings
BuildingRebuild: "<float>" // Progress added to destroyed buildings per pulse
BuildingBuild: "<float>" // Progress added to unbuilt buildings per pulse
MineHealth: "<float>" // Repair per pulse for mines (legacy)
```

## Shield
```
MaxShield: "<float>" // Maximum capacity of the energy shield
AddShield: "<float>" // Shield capacity added on activation
AddShieldOff: "<float>" // Shield capacity removed on deactivation
ShieldOffset: "<float> <float> <float>" // Center position of the shield sphere
ShieldRadius: "<float> <float> <float>" // XYZ radius dimensions of the shield
ShieldEffect: "<fxName>" // Visual effect used for the shield shell
ShieldSound: "<soundPropertyName>" // Sound played while shield is active
ShieldOffSound: "<soundPropertyName>" // Sound played when shield breaks or stops
```

# ExplosionClass Classtype
## Explosion ClassLabel Properties
```
Damage: "<float>" // Primary damage dealt at the epicenter
MaxDamage: "<float>" // Maximum damage potential (linear falloff toward outer radius)
HealthScale: "<float>" // Legacy multiplier for damage against Units/Animals/Droids
ArmorScale: "<float>" // Legacy multiplier for damage against Vehicles/Buildings
PersonScale: "<float>" // Damage multiplier applied specifically to Units
AnimalScale: "<float>" // Damage multiplier applied specifically to Animals
DroidScale: "<float>" // Damage multiplier applied specifically to Droids
VehicleScale: "<float>" // Damage multiplier applied specifically to Vehicles
BuildingScale: "<float>" // Damage multiplier applied specifically to Buildings
ShieldScale: "<float>" // Damage multiplier applied against energy shields
DamageRadiusInner: "<float>" // Radius within which 100% damage is applied
DamageRadiusOuter: "<float>" // Radius at which damage reaches 0%
DamageRadius: "<float>" // Legacy single-radius parameter for damage falloff
Shake: "<float>" // Magnitude of camera shake (0.0 to 1.0)
ShakeRadiusInner: "<float>" // Radius for maximum camera shake
ShakeRadiusOuter: "<float>" // Radius at which camera shake ceases
ShakeRadius: "<float>" // Legacy single-radius parameter for camera shake
ShakeLength: "<float>" // Duration of the camera shake effect in seconds
Push: "<float>" // Magnitude of the physics impulse applied to entities
PushRadiusInner: "<float>" // Radius within which maximum push force is applied
PushRadiusOuter: "<float>" // Radius at which push force reaches 0
PushRadius: "<float>" // Legacy single-radius parameter for physics push
PushDeadOnly: "0", "1" // Whether the push only affects ragdolls/wreckage
HurtOwner: "0", "1" // Whether the explosion damages the person who triggered it
Effect: "<fxName>" // Particle effect file spawned upon detonation
WaterEffect: "<fxName>" // Particle effect spawned if detonation occurs in water
ShieldEffect: "<fxName>" // Particle effect spawned if hitting an energy shield
Decal: "<textureName>" // Scorch mark texture applied to surfaces at impact
SoundProperty: "<soundPropertyName>" // Audio played at the moment of explosion
ChunkGeometryName: "<meshName>" // 3D model used for debris chunks
ChunkTerrainCollisions: "<int>" // Number of times debris pieces bounce on terrain
ChunkTerrainEffect: "<fxName>" // Particle effect spawned when debris hits the ground
ChunkTrailEffect: "<fxName>" // Particle effect trailed by flying debris
ChunkSmokeEffect: "<fxName>" // Smoke effect attached to stationary debris
ChunkPhysics: "FULL", "LEAF", "STATIC", "SIMPLE" // Physics calculation model for debris
ChunkOmega: "<float> <float> <float>" // Angular velocity (spin) for debris chunks
ChunkSpeed: "<float>" // Initial ejection speed of debris chunks
ChunkGravity: "<float> <float> <float>" // Directional gravity vector for debris
NumChunks: "<int>" // Maximum number of debris pieces to spawn
ChunkStartDistance: "<float>" // Offset distance from epicenter where chunks appear
ChunkInitialCollisionSound: "<soundPropertyName>" // Sound played on first debris impact
ChunkScrapeCollisionSound: "<soundPropertyName>" // Sound played as debris slides on surfaces
VisibleRadius: "<float>" // Maximum distance the explosion visual remains visible
LightColor: "<int> <int> <int>" // RGB color (0-255) for the dynamic light flash
LightRadius: "<float>" // Distance the dynamic light flash reaches
LightDuration: "<float>" // Duration of the dynamic light flash in seconds
```

# OrdnanceClass Classtype Class Properties
Defines properties to be inherited by all ordnance subclasses.
```
LifeSpan: "<float>" // Time in seconds before the projectile is automatically destroyed
DamageTransitionDelay: "<float>" // Delay in seconds before transitioning to final damage values
DamageTransitionPeriod: "<float>" // Duration of the transition from initial to final damage
DamageFinalDamage: "<float>" // Final damage value reached after the transition period
Explosion: "<odfName>" // Name of the explosion ODF triggered on impact or expiration
ExplosionImpact: "<odfName>" // Explosion ODF triggered specifically upon collision with an object
ExplosionName: "<odfName>" // Name of the explosion ODF triggered on impact or expiration
ExplosionExpire: "<odfName>" // Explosion ODF triggered specifically when LifeSpan elapses
Damage: "<float>" // Impact damage inflicted on a direct hit
MaxDamage: "<float>" // Maximum radius damage at the epicenter of the impact explosion
HealthScale: "<float>" // Legacy multiplier for damage against living/droid units
ArmorScale: "<float>" // Legacy multiplier for damage against vehicles/buildings
PersonScale: "<float>" // Damage multiplier applied specifically to Units
AnimalScale: "<float>" // Damage multiplier applied specifically to Animals
DroidScale: "<float>" // Damage multiplier applied specifically to Droids
VehicleScale: "<float>" // Damage multiplier applied specifically to Vehicles
BuildingScale: "<float>" // Damage multiplier applied specifically to Buildings
ShieldScale: "<float>" // Damage multiplier applied specifically against shields
TrailEffect: "<fxName>" // Particle effect ODF attached to the projectile during flight
ExplosionEffect: "<fxName>" // Visual effect ODF spawned upon detonation
OrdnanceSound: "<soundPropertyName>" // Looped audio played while the projectile is in flight
CollisionSound: "<soundPropertyName>" // Audio played when the projectile hits an object
CollisionWaterSound: "<soundPropertyName>" // Audio played when the projectile hits water
CollisionShieldSound: "<soundPropertyName>" // Audio played when the projectile hits a shield
BonusAmplification: "<float>" // Damage multiplier increase for enhanced blasters bonus 
BonusColor: "<int> <int> <int> <int>" // RGBA color applied to the projectile when amplified
```

## Beam ClassLabel Properties
```
BeamWidth: "<float>" // Visual width of the continuous beam effect
BeamTexture: "<textureName>" // Core texture used for the beam
BeamColor: "<int> <int> <int> <int>" // RGBA color of the beam core
BeamGlowWidth: "<float>" // Width of the outer glow shell around the beam
BeamGlowTexture: "<textureName>" // Texture used for the outer glow effect
BeamGlowColor: "<int> <int> <int> <int>" // RGBA color of the outer glow effect
PassThrough: "0", "1" // Whether the beam penetrates through multiple entities
OrdnanceEffect: "red_blaster_bolt", "green_blaster_bolt", etc. // Laser beam effect
ImpactEffect: "<fxName>" // Visual effect particle effect spawned at the point of contact
```

## Bullet ClassLabel Properties
```
GeometryName: "<meshName>" // 3D model used for the projectile geometry
Velocity: "<float>" // Travel speed in meters per second
OrdnanceEffect: "<fxName>" // Particle effect ODF attached to the bullet
ImpactEffectSoft: "<fxName>" // Effect spawned when hitting "Soft" targets (Units/Animals)
ImpactEffectRigid: "<fxName>" // Effect spawned when hitting "Rigid" targets (Vehicles)
ImpactEffectStatic: "<fxName>" // Effect spawned when hitting Static objects (Buildings/Walls)
ImpactEffectTerrain: "<fxName>" // Effect spawned when hitting the ground
ImpactEffectWater: "<fxName>" // Effect spawned when hitting water
ImpactEffectShieldSmall: "<fxName>" // Effect spawned when hitting personal shields
ImpactEffectShieldLarge: "<fxName>" // Effect spawned when hitting vehicle/building shields
ImpactDecalTerrain: "<textureName>" // Scorch mark texture left on the ground
ImpactDecalStatic: "<textureName>" // Scorch mark texture left on static objects
LightOdf: "<odfName>" // Light ODF attached to the projectile
LightColor: "<int> <int> <int> <int>" // RGBA color of the attached dynamic light
LightRadius: "<float>" // Radius of the attached dynamic light in meters
EndLightColor: "<int> <int> <int> <int>" // Final RGBA color for the light after fading
FadeLightColor: "0", "1" // Whether to fade the light toward EndLightColor
```

## FatRay ClassLabel Properties
```
RayRadius: "<float>" // Radius of the damaging cylinder/ray volume
MaxDamage: "<float>" // Maximum damage at the start of the ray
MinDamage: "<float>" // Minimum damage at the end of the ray
DamageDeduction: "<float>" // Amount damage decreases per meter of travel
MaxPush: "<float>" // Maximum physics impulse magnitude at the start
MinPush: "<float>" // Minimum physics impulse magnitude at the end
PushDeduction: "<float>" // Amount push force decreases per meter of travel
```

## GrapplingHook ClassLabel Properties (Deprecated)
`SoldierAnimation: "<animName>" // Animation played by the unit while grappling`

## Laser ClassLabel Properties
```
LaserLength: "<float>" // Visual length of the laser bolt
GlowLength: "<float>" // Length of the outer glow
BlurLength: "<float>" // Length of the motion blur streak
LaserWidth: "<float>" // Visual width of the laser bolt
FadeOutTime: "<float>" // Seconds the bolt remains visible until fading out
LaserTexture: "<textureName>" // Core texture for the laser bolt
LaserGlowColor: "<int> <int> <int> <int>" // RGBA color of the glow sprite
EndLaserGlowColor: "<int> <int> <int> <int>" // Final RGBA color for the glow bolt
OrdnanceEffect: "red_blaster_bolt", "green_blaster_bolt", etc. // Laser effect
```

## Meleethrowordnance ClassLabel Properties
```
Velocity
LifeSpan: "<float>" // Maximum time before returning
ReturnDuration
RotationRate: "<int>" // Rotations per second
DamageWidth
DamageLength
Push
```

## Missile ClassLabel Properties
```
ScaleTime: "<float>" // Time in seconds for the missile to scale up on launch
TurnRate: "<float>" // Maximum tracking turn speed in degrees per second
WaverRate: "<float>" // Frequency of flight path oscillation
WaverTurn: "<float>" // Intensity/amplitude of flight path oscillation
LockedOnSound: "<soundPropertyName>" // Audio played while a missile lock is active
MinSpeed: "<float>" // Minimum flight velocity
Acceleration: "<float>" // Flight acceleration
```

## Shell ClassLabel Properties
`Gravity: "<float>" // Gravity strength on ordnance`


## Sticky ClassLabel Properties
```
CollisionWaterSound: "<soundPropertyName>" // Audio played when hitting water
CollisionFoliageSound: "<soundPropertyName>" // Audio played when hitting foliage
CollisionOtherSound: "<soundPropertyName>" // Audio played when hitting surfaces
StartTimerOnContact: "0", "1" // If 1, the fuse begins after the ordnance sticks
AlignVertical: "0", "1" // Whether to orient vertically upon sticking
StickAll: "0", "1" // Whether the ordnance sticks to all HealthTypes
StickPerson: "0", "1" // Whether it sticks to Units
StickAnimal: "0", "1" // Whether it sticks to Animals
StickDroid: "0", "1" // Whether it sticks to Droids
StickVehicle: "0", "1" // Whether it sticks to Vehicles
StickBuilding: "0", "1" // Whether it sticks to Buildings
StickBuildingDead: "0", "1" // Whether it sticks to destroyed Buildings
StickBuildingUnbuilt: "0", "1" // Whether it sticks to unbuilt Buildings
StickTerrain: "0", "1" // Whether it sticks to the ground
Rebound: "<float>" // Coefficient of restitution (bounciness factor)
Friction: "<float>" // Friction resistance applied when sliding on surfaces
```

## Beacon ClassLabel Properties
```
AimAzimuth: "<float>" // Horizontal aim offset for orbital strike targeting
AimElevation: "<float>" // Vertical aim offset for orbital strike targeting
AimDistance: "<float>" // Distance from the beacon for orbital impacts
SalvoCount: "<int>" // Total number of orbital shells in a barrage
SalvoDelay: "<float>" // Delay between individual orbital shell impacts
ScatterDistance: "<float>" // Random variance radius for orbital shell placement
Ordnance: "<odfName>" // Name of ordnance to drop
OrdnanceName: "<odfName>" // Name of ordnance to drop
```

## Haywire ClassLabel Properties
Inherits properties from Sticky.
`DisableTime: "<float>" // Seconds a vehicle remains disabled by the haywire effect`

## TowCable ClassLabel Properties
```
InitialCableLength: "<float>" // Starting length of the first cable segment
CableLength: "<float>" // Maximum total extension of the cable before breaking off
```

## EmitterOrdnance ClassLabel Properties
```
StunTime: "<float>" // Duration of the stun effect in seconds (deprecated?)
Damage: "<float>" // Damage inflicted per pulse or tick
Push: "<float>" // magnitude of physics impulse applied per pulse
ConeLength: "<float>" // Reach of the emitter influence volume
ConeAngle: "<float>" // Width angle of the emitter volume in degrees
MaxTargets: "<int>" // Maximum number of entities affected per pulse
Effect: "<fxName>" // Primary particle effect ODF produced
StunAnimation: "<animName>" // Animation forced on stunned units (deprecated?)
LightningEffect: "<fxName>" // Visual effect used for lightning arcs
LightningEffectScale: "<float>" // Size multiplier for the lightning arcs
NoTargetLightningEffectCount: "<int>" // Number of arcs spawned when no target is present
NoTargetLightningEffectRandomSpread: "<float>" // Random variance for no-target arcs
MaxDamage: "<float>" // Maximum cumulative damage potential
DamageThreshold: "<float>" // Minimum damage required for chaining logic?
MaxJumpDistance: "<float>" // Maximum range for lightning chain jumps
JumpDeduction: "<float>" // Damage reduction multiplier per chain jump
FirstRadius: "<float>" // Initial search radius for finding chain targets
NoChaining: "0", "1" // Whether to disable electrical chain-jump behavior
Radius: "<float>" // Sphere radius of the emitter's influence
BuffOffenseTimer: "<float>" // Duration of the offensive damage buff
BuffOffenseMult: "<float>" // Damage multiplier for offensive buff
BuffDefenseTimer: "<float>" // Duration of the defensive armor buff
BuffDefenseMult: "<float>" // Damage reduction multiplier for defensive buff
BuffHealthTimer: "<float>" // Duration of the health regeneration buff
BuffHealthRate: "<float>" // Health units restored per second
DebuffDamageTimer: "<float>" // Duration of the damage-over-time debuff
DebuffDamageRate: "<float>" // Damage units taken per second
PlayEffectOnOwner: "0", "1" // Whether the particle effect displays on the user
PlayEffectOnOwnerAimer: "0", "1" // Whether the effect follows the user's aiming logic
Explosion: "<odfName>" // Explosion ODF triggered by the emitter
SmolderEffectTimer: "<float>" // Duration units "smolder" after contact
SmolderVanishDeath: "0", "1" // Whether units vanish after smoldering death
SmolderBone: "<bone>" // Skeleton bone where the smolder effect attaches
SmolderEffect: "<fxName>" // Particle effect ODF for smoldering units
SmolderDamageRate: "<float>" // Damage units taken per second while smoldering
AffectFriends: "0", "1" // Whether the emitter affects allied units
AffectEnemies: "0", "1" // Whether the emitter affects hostile units
ApplyOnOwnerIfOnOthers: "0", "1" // Whether the user receives the buff if allies are affected
```

# GameObjectClass Classtype Class Properties
```
Team: "<int>" // Team index (0=Neutral, 1=Attacking, 2=Defending, 3-9=Locals or other.)
PerceivedTeam: "<int>" // Team index reported to AI and player HUD elements
CurHealth: "<float>" // Current health value of entity
MaxHealth: "<float>" // Maximum health capacity of the entity
AddHealth: "<float>" // Health added per second
CurShield: "<float>" // Current shield value of entity
MaxShield: "<float>" // Maximum shield value of entity
AddShield: "<float>" // Shield added per second
DisableTime: "<float>" // Seconds the entity remains disabled by Haywire grenade or fusion cutter splicing
PhysicsActive: "0", "1" // Whether the entity's physics simulation is enabled
HealthType: "Person", "Animal", "Droid", "Vehicle", "Building", "Mine" // Healthtype Classification
HealthTypeForLockOn: "Person", "Animal", "Droid", "Vehicle", "Building", "Mine" // Lock acquisition classification
HideHealthBar: "0", "1" // Hides the entity's health meter from the player's HUD
PilotSkillRepairScale: "<float>" // Multiplier for repair speed
ScanningRange: "<float>" // Minimap detection cone length in meters
TransmitRange: "<float>" // Radius for sharing scanned enemies with allied units
ReserveOneForPlayer: "0", "1" // Prevents AI from taking the last available vehicle at a CP
AvailableForAnyTeam: "0", "1" // Allows a unit from any team to interact with the entity
HurtSound: "<soundPropertyName>" // Audio played when taking non-lethal damage
HurtFallSound: "<soundPropertyName>" // Audio played when taking falling damage
DeathSound: "<soundPropertyName>" // Audio played upon entity death
DamageRegionSound: "<soundPropertyName>", "<soundPropertyName> <damageRegionName>" // Audio played when inside a damage region, can specify a particular region
AISizeType: "SOLDIER", "HOVER", "SMALL", "MEDIUM", "HUGE", "FLYER" // Classification for AI planning
AINoRepair: "0", "1" // Prevents AI units from attempting to repair this entity
DamageStartPercent: "<float>" // Health percentage threshold to trigger damage effects
DamageStopPercent: "<float>" // Health percentage threshold to stop this damage effect
DamageEffect: "<fxName>" // Particle effect spawned when the entity's health reaches a damage percentage threshold
DamageEffectScale: "<float>" // Size multiplier for the damage effect
DamageInheritVelocity: "<float>" // Ratio (0.0-1.0) of entity speed inherited by damage particles
DamageAttachPoint: "<nodeName>" // Model node where damage effects are anchored
DamageAttachOffset: "<float> <float> <float>" // XYZ positional offset for damage effects
DamageEffectSound: "<soundPropertyName>" // Audio looped while damage effects are active
VOSound: "<voProperty>" // Voice-over script trigger for various events
VOUnitType: "<int>" // Identifier for unit voiceover
VORadius: "<float>" // Radius for unit voiceovers
SwitchClassRadius: "<float>" // Proximity required to change classes at a command post
IsNotTargetableByPlayer: "0", "1" // Prevents human players from targeting
LockOnMinDist: "<float>" // Minimum range required to acquire a weapon lock
LockOnMaxDist: "<float>" // Maximum range for acquiring a weapon lock
LockOnMaxTrackDist: "<float>" // Maximum distance a maintained lock remains valid
PointsToUnlock: "<int>" // Score required to make this entity selectable
DisabledEffect: "<fxName>" // Visual effect applied when the entity is disabled
AICollisionRadius: "<float>" // Radius used for AI obstacle avoidance logic
RadiusDamageSizeScale: "<float>" // Scale factor of the entity damage radius
VehicleType: "SCOUT", "LIGHT", "MEDIUM", "HEAVY", "FIGHTER", "TRANSPORT", "CAPITOL", "REMOTETERMINAL", "ATAT" // Vehicle classification
FoleyFXGroup: "terrain_foley", "wood_foley", "stone_foley", "metal_foley", "water_foley", "dirt_foley" // Foley sounds to associate with this entity
```

## CloudCluster ClassLabel Properties
```
ODF: "<odfName>" // Name of dusteffect ODF to spawn
NumDustObjectsInEffects: <int> // Number of dusteffect objects to spawn
HorizontalSpread: <int> // Horizontal spread of dust objects
VerticalSpread: <int> // Vertical spread of dust objects
```

## DustEffect ClassLabel Properties
```
Texture: "<textureName>" // Billboard texture used for the dust particles
CameraDistance: "<float>" // Offset distance from the camera for particle center
SpawnSound: "<soundPropertyName>" // Audio played when particles are created
MinPos: "<float> <float> <float>" // Minimum spawning position of dusteffect
MaxPos: "<float> <float> <float>" // Maximum spawning position of dusteffect
MinVel: "<float> <float> <float>" // Minimum spawning velocity of dusteffect
MaxVel: "<float> <float> <float>" // Maximum spawning velocity of dusteffect
MinSize: "<float>" // Minimum size of dusteffect particles
MaxSize: "<float>" // Maximum size of dusteffect particles
MinLifeTime: "<float>" // Minimum lifespan of dusteffect particles in seconds
MaxLifeTime: "<float>" // Maximum lifespan of dusteffect particles in seconds
Alpha: "<float> // Alpha of spawned dusteffect particles (0.0-1.0)
Color: "<int> <int> <int>" // RGB color of the dusteffect particles
NumParticles: "<int>" // Number of particles to spawn for this dusteffect entity
MaxDistance: "<float> // Maximum distance at which dusteffect particles are rendered
MinDistance: "<float> // Minimum distance at which dusteffect particles are rendered
RadiusFadeMin: "<float>" // Distance at which particles begin to fade in
RadiusFadeMax: "<float>" // Distance at which particles reach their full opacity
HeightScale: "<float>" // Scale factor for vertical stretching of particles based on camera angle?
Texture: "textureName" // Billboard texture used for the dust particles
CameraDistance: "<float>" // Offset distance from the camera for particle center?
```

## Cloth ClassLabel Properties
```
winddirection: "<float> <float>" // Directional vector for wind force (phi theta)
windspeed: "<float>" // Acceleration magnitude applied by wind
dampening: "<float>" // Resistance to cloth particle motion (default 0.5)
drag: "<float>" // Air resistance coefficient (default -2.0)
particlemass: "<float>" // Simulated weight of cloth particles (default 1.0)
maxacceleration: "<float>" // Magnitude clamp for cloth particle movement (default 20)
attachedmesh: "<mshName>" // The model the cloth entity is attached to
priority: "<float>" // Processing priority (lower values are culled under performance load)
crossconstraint: "0", "1" // Enables shearing-prevention constraints from model data
bendconstraint: "0", "1" // Enables shape-retention constraints from model data
stretchconstraint: "0", "1" // Enables size-retention constraints from model data
hardedge: "0", "1" // Uses hard-edge alpha clipping instead of blending
transparent: "0", "1" // Enables standard alpha transparency blending
```

## EntityGeometry ClassLabel Properties
```
IsVisible: "0", "1" // Whether the 3D geometry is rendered
IsCollidable: "0", "1" // Whether the entity processes collisions
CHUNKSECTION: "CHUNK<int>" // Defines an ODF section for physically-simulated debris chunks
CHUNK: "<int>" // Debris chunk identifier (deprecated?)
LODPriorityMod: "<float>" // Priority modifier for distance-based LOD switching
GeometryName: "<mshName>" // Primary 3D model for the entity
ChunkGeometryName: "<mshName>" // 3D model used for the debris chunk (must not have .msh.option!)
ChunkNodeName: "<nodeName>" // Model node where the debris piece originates
ChunkTerrainCollisions: "<int>" // Maximum bounces before debris piece stops bouncing on terrain
ChunkTerrainEffect: "<fxName>" // Particle effect spawned on debris impact with ground
ChunkTrailEffect: "<fxName>" // Particle effect trailed by the debris piece in flight
ChunkSmokeEffect: "<fxName>" // Particle effect attached to debris
ChunkSmokeNodeName: "<nodeName>" // Model node for smoke effect attachment
ChunkTrailNodeName: "<nodeName>" // Model node for trail effect attachment
ChunkPhysics: "FULL", "LEAF", "STATIC", "COCKPIT", "SIMPLE" // Physics calculation model for this chunk
ChunkOmega: "<float> <float> <float>" // Starting angular spin velocity for debris
ChunkSpeed: "<float>" // Initial ejection velocity upon destruction
ChunkGravity: "<float> <float> <float>" // Gravity vector for debris chunks
ChunkLinearDamping: "<float>" // Resistance to linear motion
ChunkAngularDamping: "<float>" // Resistance to angular spin
ChunkDeathSpeed: "<float>" // Speed threshold below which the chunk is removed
ChunkVelocityFactor: "<float>" // Multiplier for inheriting parent velocity
ChunkUpFactor: "<float>" // Vertical bias added to ejection velocity
ChunkBounciness: "<float>" // Coefficient of restitution for debris bounces
ChunkStickiness: "<float>" // Friction multiplier for sliding debris
ChunkSimpleFriction: "<float>" // Static friction for SIMPLE physics chunks
ChunkLifetime: "<float>" // Time in seconds before debris disappears
ChunkInitialCollisionSound: "<soundPropertyName>" // Audio played on first ground impact
ChunkScrapeCollisionSound: "<soundPropertyName>" // Audio played while chunk is sliding
ChunkKeepSoldierCollision: "0", "1" // Whether debris should collide with units
//primDef = "sphere, <float>(X) <float>(Y) <float>(Z) <float>(radius)", "box, <float>(width) <float>(height) <float>(depth) <float>(radius)", "aacylinder, <float>(X) <float>(Y) <float>(Z) <float>(radius) <float>(height)", "cylinder, <float>(X) <float>(Y) <float>(Z) <float>(radius) <float>(height)"
TerrainCollisionPrim: "<primDef>" // Manual collision primitive definition for ground collision
BuildingCollisionPrim: "<primDef>" // Manual collision primitive definition for static objects
VehicleCollisionPrim: "<primDef>" // Manual collision primitive definition for vehicles
SoldierCollisionPrim: "<primDef>" // Manual collision primitive definition for units
OrdnanceCollisionPrim: "<primDef>" // Manual collision primitive definition for projectiles
TargetableCollisionPrim: "<primDef>" // Manual collision primitive definition for lock-on targeting
TargetableCollision: "<nodeName>", "none", "clear" // Custom lock-on targeting mesh
TerrainCollision: "<nodeName>", "none", "clear" // Use node in msh for terrain collisions
BuildingCollision: "<nodeName>", "none", "clear" // Use node in msh for building collisions
VehicleCollision: "<nodeName>", "none", "clear" // Use node in msh for vehicle collisions
SoldierCollision: "<nodeName>", "none", "clear" // Use node in msh for unit collisions
OrdnanceCollision: "<nodeName>", "none", "clear" // Use node in msh for ordnance collisions
HitLocation: "<nodeName> <float>" // Specific collision primitive damage multiplier (Critical Hit)
Lighting: "dynamic", "static" // Dynamic = Accepts shadowregion lighting, world lighting
MaxShadowLength: "<float>" // Maximum distance a shadow is projected
DeathOnFlyerLand: "0", "1" // Instantly kills flyer vehicles that land on this entity
DenyFlyerLand: "0", "1" // Prevents flyer vehicles from landing on this entity
TargetPointOffset: "<float> <float> <float>" // Offset for auto-aim and AI aiming?
```

## Prop ClassLabel Properties
```
GeometryName: "<mshName>" // Primary 3D model mesh
TerrainCollisionPrim: "<primDef>" // Manual collision primitive definition for ground collision
BuildingCollisionPrim: "<primDef>" // Manual collision primitive definition for static objects
VehicleCollisionPrim: "<primDef>" // Manual collision primitive definition for vehicles
SoldierCollisionPrim: "<primDef>" // Manual collision primitive definition for units
OrdnanceCollisionPrim: "<primDef>" // Manual collision primitive definition for projectiles
TargetableCollisionPrim: "<primDef>" // Manual collision primitive definition for lock-on targeting
TargetableCollision: "<nodeName>", "none", "clear" // Custom lock-on targeting mesh
TerrainCollision: "<nodeName>", "none", "clear" // Use node in msh for terrain collisions
BuildingCollision: "<nodeName>", "none", "clear" // Use node in msh for building collisions
VehicleCollision: "<nodeName>", "none", "clear" // Use node in msh for vehicle collisions
VehicleCollisionOnly: "<nodeName>", "none", "clear" // Use node in msh for vehicle collisions only?
SoldierCollision: "<nodeName>", "none", "clear" // Use node in msh for unit collisions
OrdnanceCollision: "<nodeName>", "none", "clear" // Use node in msh for ordnance collisions
DestroyedGeometryName: "<mshName>" // Mesh swapped in after entity destruction
LowResModel: "<mshName>" // Separate low-detail msh used for LODing
GeometryColorMin: "<int> <int> <int> <int>" // Random tint variation floor (RGBA)
GeometryColorMax: "<int> <int> <int> <int>" // Random tint variation ceiling (RGBA)
SoundOffset: "<float> <float> <float>" // XYZ offset for audio origin
SoundWhenMoving: "<soundPropertyName>" // Audio looped while the prop is in motion
SoundProperty: "<soundPropertyName>" // Primary audio property
StartMovementSound: "<soundPropertyName>" // Audio played when movement begins
StopMovementSound: "<soundPropertyName>" // Audio played when movement ends
Lighting: "dynamic", "static" // Dynamic = Accepts shadowregion lighting, world lighting
DeathOnFlyerLand: "0", "1" // Kills flyers attempting to land on this prop
DenyFlyerLand: "0", "1" // Prevents flyers from landing on this prop
AttachEffect: "<fxName>" // Particle effect attached to the prop
AttachOdf: "<odfName>" // ODF entity attached to the prop
AttachToHardPoint: "<nodeName>" // Model node used as attachment anchor
MaxDistance: "<float>" // Distance limit for rendering?
ClothODF: "<odfName>" // Associated cloth simulation entity
```

## Door ClassLabel Properties
```
OpenTrigger: "<nodeName> <float>" // Proximity distance of unit to node to trigger opening
OpenRatio: "<float>" // Maximum percentage of door travel
IsLocked: "0", "1" // Prevents proximity-based opening
AnimationName: "<animBank>" // Animation bank of the door
Animation: "<animName>" // Animation to be played when a unit triggers the door
AnimationTrigger: "<nodeName> <radius>" // Door will be triggered upon unit reaching a radius from a node
OpenSound: "<soundPropertyName>" // Audio played during the opening sequence
CloseSound: "<soundPropertyName>" // Audio played during the closing sequence
LockedSound: "<soundPropertyName>" // Audio played when approached while locked
```

## AnimatedProp ClassLabel Properties
```
AnimationName: "<animBank>" // Animation bank of the prop
Animation: "<animName>" // Animation to play
AttachTrigger: "die" // Trigger death when unit is attached?
AnimationTrigger: "<animName> <nodeName> <float>" // Animation to play when a unit is within a radius of a node
DisableForCloneWars: "0", "1" // Disables animation during clone wars missions
TrackDeathOnAttach: "0", "1" // Camera tracks unit entity when attached to prop?
IdleDelay: "<float>" // Delay in seconds before playing animation when triggered
KillSoldierSound: "<soundPropertyName>" // Audio played when prop kills a unit
AnimationTriggerSound: "<soundPropertyName>" // Audio played when the animation starts
```

## Asteroid ClassLabel Properties
```
GeometryName: "<mshName>" // Primary 3D model
SoldierCollision: "<nodeName>", "none", "clear" // Collision mesh for unit entities
OrdnanceCollision: "<nodeName>", "none", "clear" // Collision mesh for projectiles
MinSpeed: "<float>" // Minimum drift velocity
MaxSpeed: "<float>" // Maximum drift velocity
MinOmega: "<float> <float> <float>" // Minimum random XYZ rotation speed (spin)
MaxOmega: "<float> <float> <float>" // Maximum random XYZ rotation speed (spin)
Collidable: "0", "1" // Whether the asteroid processes collisions
ExplosionBreak: "<odfName>" // Explosion ODF triggered when splitting into child asteroids
Explosion: "<fxName>" // Primary explosion particle effect or ODF?
ExplosionName: "<fxName>" // Primary explosion particle effect or ODF?
ExplosionDestruct: "<odfName>" // Explosion ODF triggered on health depletion
ChildAsteroid: "<odfName> <nodeName>" // Name of child asteroid ODF spawned at node when broken
```

## Building ClassLabel Properties
```
GeometryName: "<mshName>" // Primary 3D model
DestroyedGeometryName: "<mshName>" // Mesh swapped in after building destruction
UnbuiltGeometryName: "<mshName>" // Mesh used for the blueprint or unbuilt state
Explosion: "<odfName>" // Secondary explosion ODF?
ExplosionName: "<odfName>" // Primary explosion ODF
ExplosionOffset: "<float> <float> <float>" // Epicenter offset for the explosion
RespawnTime: "<float>" // Seconds before a destroyed building regenerates
UnbuiltHoloOdf: "<odfName>" // Hologram blueprint ODF for construction
BuiltSound: "<soundPropertyName>" // Audio played when building construction completes
BuildingSound: "<soundPropertyName>" // Looped sound property
AutoBarrierEnable: "0", "1" // Automatically creates an AI barrier based on dimensions
AutoBarrierRemoveOnDeath: "0", "1" // Removes the auto-barrier when the building is killed
ColorizeByTeam: "0", "1" // Tints the building geometry with owning team color
AutoBarrierSize: "<float> <float> <float>" // Dimensions for the auto-generated barrier
```

## AnimatedBuilding ClassLabel Properties
```
AnimationName: "<animBank>" // Animationbank used by the building
IdleAnimation: "<animName>" // Looped animation played while the building is healthy
DeathAnimation: "<animName>" // Animation played during the destruction event
EnableDeathExplosions: "0", "1" // Triggers explosions during the death animation
DeathEffect: "<fxName>" // Particle effect spawned upon building destruction
```

## CommandPost ClassLabel Properties
```
Label: "<string>" // Localization key for the command post's name
CaptureRegion: "<regionName>" // Name of the region entity used for capturing the CP
ControlRegion: "<regionName>" // Name of the region entity used to control nearby entities
KillRegion: "<regionName>" // Name of the region entity where units are instantly killed
SpawnPath: "<pathName>" // Name of the path entity used for unit-spawning
SpawnRegion: "<regionName>" // Name of the region entity for spawning units (alternative to SpawnPath?)
AllyPath: "<pathName>" // Name of the path entity for allied team unit-spawning specific to this CP
TurretPath: "<pathName>" // Name of the path entity for AI turrets (deprecated?)
AllyCount: "<int>" // Number of allied team units to spawn at this CP
Radius: "<float>" // Spherical radius around the CP for various interactions
HUDIndex: "<int>" // Index for HUD display of this CP
HUDIndexDisplay: "0", "1" // Whether to display the HUD index for this CP
VO_All_AllCapture: "<soundPropertyName>" // Voiceover when Alliance captures for Alliance
VO_All_AllLost: "<soundPropertyName>" // Voiceover when Alliance loses for Alliance
VO_All_AllInDispute: "<soundPropertyName>" // Voiceover when Alliance CP is contested for Alliance
VO_All_AllSaved: "<soundPropertyName>" // Voiceover when Alliance CP is secured for Alliance
VO_All_AllInfo: "<soundPropertyName>" // Voiceover for Alliance CP information for Alliance
VO_All_ImpCapture: "<soundPropertyName>" // Voiceover when Imperial captures for Alliance
VO_All_ImpLost: "<soundPropertyName>" // Voiceover when Imperial loses for Alliance
VO_All_ImpInDispute: "<soundPropertyName>" // Voiceover when Imperial CP is contested for Alliance
VO_All_ImpSaved: "<soundPropertyName>" // Voiceover when Imperial CP is secured for Alliance
VO_All_ImpInfo: "<soundPropertyName>" // Voiceover for Imperial CP information for Alliance
VO_Imp_AllLost: "<soundPropertyName>" // Voiceover when Alliance loses for Imperial
VO_Imp_AllInDispute: "<soundPropertyName>" // Voiceover when Alliance CP is contested for Imperial
VO_Imp_AllSaved: "<soundPropertyName>" // Voiceover when Alliance CP is secured for Imperial
VO_Imp_AllInfo: "<soundPropertyName>" // Voiceover for Alliance CP information for Imperial
VO_Imp_ImpCapture: "<soundPropertyName>" // Voiceover when Imperial captures for Imperial
VO_Imp_ImpLost: "<soundPropertyName>" // Voiceover when Imperial loses for Imperial
VO_Imp_ImpInDispute: "<soundPropertyName>" // Voiceover when Imperial CP is contested for Imperial
VO_Imp_ImpSaved: "<soundPropertyName>" // Voiceover when Imperial CP is secured for Imperial
VO_Imp_ImpInfo: "<soundPropertyName>" // Voiceover for Imperial CP information for Imperial
VO_Rep_RepCapture: "<soundPropertyName>" // Voiceover when Republic captures for Republic
VO_Rep_RepLost: "<soundPropertyName>" // Voiceover when Republic loses for Republic
VO_Rep_RepInDispute: "<soundPropertyName>" // Voiceover when Republic CP is contested for Republic
VO_Rep_RepSaved: "<soundPropertyName>" // Voiceover when Republic CP is secured for Republic
VO_Rep_RepInfo: "<soundPropertyName>" // Voiceover for Republic CP information for Republic
VO_Rep_CISCapture: "<soundPropertyName>" // Voiceover when CIS captures for Republic
VO_Rep_CISLost: "<soundPropertyName>" // Voiceover when CIS loses for Republic
VO_Rep_CISInDispute: "<soundPropertyName>" // Voiceover when CIS CP is contested for Republic
VO_Rep_CISSaved: "<soundPropertyName>" // Voiceover when CIS CP is secured for Republic
VO_Rep_CISInfo: "<soundPropertyName>" // Voiceover for CIS CP information for Republic
VO_CIS_RepCapture: "<soundPropertyName>" // Voiceover when Republic captures for CIS
VO_CIS_RepLost: "<soundPropertyName>" // Voiceover when Republic loses for CIS
VO_CIS_RepInDispute: "<soundPropertyName>" // Voiceover when Republic CP is contested for CIS
VO_CIS_RepSaved: "<soundPropertyName>" // Voiceover when Republic CP is secured for CIS
VO_CIS_RepInfo: "<soundPropertyName>" // Voiceover for Republic CP information for CIS
VO_CIS_CISCapture: "<soundPropertyName>" // Voiceover when CIS captures for CIS
VO_CIS_CISLost: "<soundPropertyName>" // Voiceover when CIS loses for CIS
VO_CIS_CISInDispute: "<soundPropertyName>" // Voiceover when CIS CP is contested for CIS
VO_CIS_CISSaved: "<soundPropertyName>" // Voiceover when CIS CP is secured for CIS
VO_CIS_CISInfo: "<soundPropertyName>" // Voiceover for CIS CP information for CIS
ValueBleed_Alliance: "<float>" // Contribution to Alliance reinforcement bleed
ValueBleed_CIS: "<float>" // Contribution to CIS reinforcement bleed
ValueBleed_Empire: "<float>" // Contribution to Empire reinforcement bleed
ValueBleed_Republic: "<float>" // Contribution to Republic reinforcement bleed
ValueBleed_Neutral: "<float>" // Contribution to Neutral reinforcement bleed
ValueBleed_Locals: "<float>" // Contribution to Locals reinforcement bleed
Value_ATK_Alliance: "<float>" // Strategic importance for Alliance AI when attacking
Value_ATK_CIS: "<float>" // Strategic importance for CIS AI when attacking
Value_ATK_Empire: "<float>" // Strategic importance for Empire AI when attacking
Value_ATK_Republic: "<float>" // Strategic importance for Republic AI when attacking
Value_ATK_Locals: "<float>" // Strategic importance for Locals AI when attacking
Value_DEF_Alliance: "<float>" // Strategic importance for Alliance AI when defending
Value_DEF_CIS: "<float>" // Strategic importance for CIS AI when defending
Value_DEF_Empire: "<float>" // Strategic importance for Empire AI when defending
Value_DEF_Republic: "<float>" // Strategic importance for Republic AI when defending
Value_DEF_Locals: "<float>" // Strategic importance for Locals AI when defending
SoldierBan: "0", "1" // Whether to prevent Soldier size AI from moving to this CP
HoverBan: "0", "1" // Whether to prevent Hover size AI from moving to this CP
SmallBan: "0", "1" // Whether to prevent Small size AI from moving to this CP
MediumBan: "0", "1" // Whether to prevent Medium size AI from moving to this CP
HugeBan: "0", "1" // Whether to prevent Huge size AI from moving to this CP
FlyerBan: "0", "1" // Whether to prevent Flyer size AI from moving to this CP
AISpawnWeight: "<float>" // Multiplier for AI preference to spawn here
NeutralizeTime: "<float>" // Seconds required to neutralize the command post
CaptureTime: "<float>" // Seconds required to capture the neutralized command post
HoloOdf: "<odfName>" // ODF for the 3D team hologram icon
HoloImageGeometry: "<mshName>" // Geometry for the CP hologram
HoloTurnOnTime: "<float>" // Time in seconds for holo to fade in
ChargeSound: "<soundPropertyName>" // Sound looped while capturing
CapturedSound: "<soundPropertyName>" // Sound played on successful capture
DischargeSound: "<soundPropertyName>" // Sound played when ownership is lost?
LostSound: "<soundPropertyName>" // Sound played when the CP is neutralized
DisputeSound: "<soundPropertyName>" // Sound played when the CP is contested
AmbientSound: "<soundPropertyName>" // Constant ambient audio at the CP
SoundPitchDev: "<float>" // Random pitch deviation for CP audio
CaptureMusic: "<musicPropertyName>" // Music played for capturing team
LostMusic: "<musicPropertyName>" // Music played for losing team
SpawnPointNames: "<string>" // List of specific SpawnPath node names to use?
SpawnPointCount: "<int>" // Number of spawn points for allied paths?
SpawnPointLocation: "<float> <float> <float> <float>" // XYZ+Rotation offset for spawn points
```

## ArmedBuilding ClassLabel Properties
```
NoAIBoard: "0", "1" // Whether AI units can interact
BUILDINGSECTION: "BODY", "TURRET1", "TURRET2"... // Separator in ODF for building segment properties
TURRETSECTION: "TURRET1", "TURRET2"... // Separator in ODF for weapon/aiming/turret properties
TurretNodeName: "<nodeName>" // Node in msh the turret will move when aiming
TurretYawSound: "<soundPropertyName>" // Sound played when moving turret horizontally
TurretYawSoundPitch: "<float>" // Sound pitch for turret yaw
TurretPitchSound: "<soundPropertyName>" // Sound played when moving turret vertically
TurretPitchSoundPitch: <float> // Sound pitch for turret pitch
TurretAmbientSound: "<soundPropertyName>" // Ambient sound emitted by turret
TurretActivateSound    = "<soundPropertyName>" // Sound emitted when turret is entered
TurretDeactivateSound  = "<soundPropertyName>" // Sound emitted when turret is exited
TurretStartSound: "<soundPropertyName>" // Sound emitted when turret is entered? Seemingly unusued
TurretStopSound: "<soundPropertyName>" // Sound emitted when turret is exited? Seemingly unused
```

## ArmedAnimatedBuilding ClassLabel Properties
Inherits all properties from both ArmedBuilding and AnimatedBuilding.

## DefenseGridTurret ClassLabel Properties
`RespawnTime: "<float>" // Seconds before a destroyed turret respawns`

## PortableTurret ClassLabel Properties
```
LifeTime: "<float>" // Total lifetime in seconds before the portable turret despawns
Gravity: "<float>" // Gravity multiplier applied to the turret when thrown or falling
Rebound: "<float>" // Bounce coefficient when colliding with surfaces
Friction: "<float>" // Sliding friction applied when turret contacts the ground
CollisionSound: "<soundPropertyName>" // Sound played when turret collides with solid objects
CollisionWaterSound: "<soundPropertyName>" // Sound played when turret collides with water surfaces
CollisionOtherSound: "<soundPropertyName>" // Sound played when turret collides with non-standard materials (metal, foliage, etc.)
```

## Trap ClassLabel Properties
```
GeometryName: "<mshName>" // Mesh used for the trap's visible model
UnbuiltGeometryName: "<mshName>" // Mesh used for the blueprint or unbuilt state
DestroyedGeometryName: "<mshName>" // Mesh swapped in after the trap is triggered or destroyed
MaxHealth: "<float>" // Health value of the trap, if it can be damaged or destroyed
AnimationName: "<animBank>" // Animationbank used by trap
BuildAnimation: "<animName>" // Animation played while the trap is being constructed
BuildPoint: "<nodeName>" // Node where the trap is built
BuildModelOdf: "<odfName>" // ODF for the trap's unbuilt model
TriggerAnimation: "<animName>" // Animation played when the trap is triggered
TriggerNode: "<nodeName>" // Node used as the origin for trigger detection or effects
TriggerOffset: "<float> <float> <float>" // XYZ offset applied to the trigger node
TriggerRadius: "<float>" // Radius around the trigger node that activates the trap
TriggerTeam: "all", "imp", "rep", "cis" // Which team can activate the trap
RayTriggerWidth: "<float>" // Width of a ray-based trigger volume
RayTriggerMinSpeed: "<float>" // Minimum speed required to activate the trap
ResetTeam: "all", "imp", "rep", "cis" // Team allowed to reset the trap
MinEnemyRadius: "<float>" // Minimum enemy proximity required to activate the trap?
DeathTime: "<float>" // Time in seconds before the trap despawns after activation
DeathEffect: "<fxName>" // Particle effect played when the trap is destroyed
DeathEffectOffset: "<float> <float> <float>" // XYZ offset for the death effect
TriggerSound: "<soundPropertyName>" // Sound played when the trap is triggered
BuiltCollision: "0", "1" // Whether the trap has collision when fully built
TriggerCollision: "0", "1" // Whether collision is enabled during trigger state
HideUnbuiltModel: "0", "1" // Whether to hide the trap model before construction completes
DeathOnCollision: "0", "1" // Whether the trap kills entities upon colliding
```

## PowerupStation ClassLabel Properties
```
EffectRegion: "<regionName>" // Region where the station applies its effects?
Radius: "<float>" // Effective radius for applying healing, ammo, or buff effects
PowerupDelay: "<float>" // Delay between each powerup tick or recharge pulse
SoldierHealth: "<float>" // Amount of health restored to soldier-class units
SoldierAmmo: "<float>" // Amount of ammo restored to soldier-class units
SoldierEnergy: "<float>" // Amount of energy restored to soldier-class units
PersonHealth: "<float>" // Health restored to entities with Person healthtype
PersonAmmo: "<float>" // Ammo restored to entities with Person healthtype
PersonEnergy: "<float>" // Energy restored to entities with Person healthtype
AnimalHealth: "<float>" // Health restored to entities with Animal healthtype
AnimalAmmo: "<float>" // Ammo restored to entities with Animal healthtype
AnimalEnergy: "<float>" // Energy restored to entities with Animal healthtype
DroidHealth: "<float>" // Health restored to entities with Droid healthtype
DroidAmmo: "<float>" // Ammo restored to entities with Droid healthtype
DroidEnergy: "<float>" // Energy restored to entities with Droid healthtype
VehicleHealth: "<float>" // Health restored to entities with Vehicle healthtype
VehicleAmmo: "<float>" // Ammo restored to entities with Vehicle healthtype
VehicleEnergy: "<float>" // Energy restored to entities with Vehicle healthtype
BuildingHealth: "<float>" // Health restored to entities with Building healthtype
BuildingAmmo: "<float>" // Ammo restored to entities with Building healthtype
BuildingEnergy: "<float>" // Energy restored to entities with Building healthtype
BuffOffenseTimer: "<float>" // Duration of offensive buff applied by the station
BuffOffenseMult: "<float>" // Multiplier for offensive buff (damage increase)
BuffDefenseTimer: "<float>" // Duration of defensive buff applied by the station
BuffDefenseMult: "<float>" // Multiplier for defensive buff (damage reduction)
BuffHealthTimer: "<float>" // Duration of health regeneration buff
BuffHealthRate: "<float>" // Rate of health regeneration during buff
DebuffDamageTimer: "<float>" // Duration of damage-over-time debuff
DebuffDamageRate: "<float>" // Rate of damage applied by debuff
PowerupSound: "<soundPropertyName>" // Sound played when the station activates or grants powerups
AmbientSound: "<soundPropertyName>" // Constant looping sound emitted by the station
IdleRotateSpeed: "<float>" // Rotation speed of idle animation elements
IdleWaitTime: "<float>" // Delay between idle animation cycles
IdleWobbleNode: "<nodeName>" // Node used for idle wobble animation
IdleWobbleFactor: "<float>" // Strength of wobble motion
IdleWobbleLeftFoot: "<float>" // Left-foot wobble amplitude
IdleWobbleRightFoot: "<float>" // Right-foot wobble amplitude
ActiveRotateNode: "<nodeName>" // Node rotated when the station is actively powering up
ActiveSpinNode: "<nodeName>" // Node spun during active state (charging or buffing)
```

## Droid ClassLabel Properties
```
GeometryName: "<mshName>" // Mesh used for the droid's visual model
FLYERSECTION: "BODY" // Separator for ODF to define properties specific to that vehicle position
SetAltitude: "<float>" // Fixed altitude offset applied to the droid's position
GravityScale: "<float>" // Multiplier for gravity affecting the droid
LiftSpring: "<float>" // Vertical spring force for hover stabilization
LiftDamp: "<float>" // Damping applied to vertical hover movement
NoCombatInterrupt: "0", "1" // Whether AI will ignore combat interruptions
Acceleration: "<float>" // Forward acceleration rate
Acceleraton: "<float>" // Legacy typo version of Acceleration
MaxSpeed: "<float>" // Maximum forward movement speed
MaxStrafeSpeed: "<float>" // Maximum sideways movement speed
MaxTurnSpeed: "<float>" // Maximum yaw rotation speed
MaxPitchSpeed: "<float>" // Maximum pitch rotation speed
PitchLimits: "<float> <float>" // Min/max pitch angle limits
LevelSpring: "<float>" // Spring force used to keep droid level?
LevelDamp: "<float>" // Damping applied to leveling behavior?
CollisionThreshold: "<float> <float> <float> // Theshold below collision won't deal damage. (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionScale: "<float> <float> <float>" // Multiplier for collision damage taken (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionInflict: "<float>" // Damage inflicted on others when colliding
WeaponSection: "<int>" // ODF section header for unique weapon configurations
WeaponName: "<odfName>" // ODF name of the weapon class
WeaponAmmo: "<int>" // Ammo count for the weapon
WeaponShareAmmo: "0", "1" // Whether ammo is shared with other weapons
WeaponShareHeat: "0", "1" // Whether heat is shared with other weapons
WeaponChannel: "<int>" // Weapon firing channel index
Explosion: "<fxName>" // Explosion particle effect triggered on destruction
ExplosionName: "<odfName>" // ODF name of explosion class
EnergyAutoRestore: "<float>" // Rate at which energy regenerates automatically
AmbientSound: "<soundPropertyName>" // Looping ambient sound for the droid
Ambient2Sound: "<soundPropertyName>" // Secondary ambient sound layer
DestructTrackOffset: "<float>" // Offset for destruction animation track
DestructTiltValue: "<float>" // Tilt amount applied during destruction sequence
DestructChargeEffect: "<fxName>" // Effect played during destruction charge-up
```

## WalkerDroid ClassLabel Properties
```
MouseTurnDecay: "<float>" // Rate at which mouse-based turning slows when input stops
FirstPerson: "<pathAndNameOfFPM>" // First person model, listed as path to lvl and model name e.g., CIS\cisdrde;cis_1st_droideka
GeometryName: "<mshName>" // Mesh used for the walker’s upright model
UprightLowResModel: "<mshName>" // Low‑res LOD model for upright mode
BallLowResModel: "<mshName>" // Low‑res LOD model for ball mode
VehicleType: "<string>" // Classification used by AI and collision systems
NoCombatInterrupt: "0", "1" // Whether AI ignore combat interruptions
AnimationName: "<animBank>" // Animation bank controlling walker animations
Acceleration: "<float>" // Forward acceleration rate in upright mode
Acceleraton: "<float>" // Legacy typo version of Acceleration
MaxSpeed: "<float>" // Maximum upright movement speed
MaxTurnSpeed: "<float>" // Maximum turning rotation speed in upright mode
MaxYawSpeed: "<float>" // Maximum yaw rotation speed
YawLimits: "<float> <float>" // Min/max yaw angle limits
MaxPitchSpeed: "<float>" // Maximum pitch rotation speed
UnrollTime: "<float>" // Time required to transition from ball to upright mode
RollTime: "<float>" // Time required to transition from upright to ball mode
PitchLimits: "<float> <float>" // Min/max pitch angle limits
CollisionThreshold: "<float> <float> <float> // Theshold below collision won't deal damage. (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionScale: "<float> <float> <float>" // Multiplier for collision damage taken (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionInflict: "<float>" // Damage inflicted on others when colliding
WeaponSection: "<int>" // ODF section header for weapon configurations
WeaponName: "<odfName>" // ODF name of weapon class
WeaponAmmo: "<int>" // Ammo count for the weapon
WeaponShareAmmo: "0", "1" // Whether ammo is shared with other weapons
WeaponShareHeat: "0", "1" // Whether heat is shared with other weapons
WeaponChannel: "<int>" // Weapon firing channel index
Explosion: "<fxName>" // Explosion particle effect triggered on destruction
ExplosionName: "<odfName>" // ODF name of explosion class
TEMP_AnimationSpeed: "<float>" // Deprecated animation property?
StompEffect: "<fxName>" // Effect played when walker stomps the ground
AttachNodeName: "<nodeName>" // Node used for attaching flag items
NoDeathExplosions: "0", "1" // Whether to disable explosion effects on death
DeathDustEffect: "<fxName>" // Dust effect played during destruction
DeathDustDelay: "<float>" // Delay before dust effect triggers
DeathDustOffset: "<float> <float> <float>" // XYZ offset for dust effect
DeathShakeDelay: "<float>" // Delay before camera shake begins on death
DeathShakeForce: "<float>" // Strength of camera shake effect
DeathShakeDuration: "<float>" // Duration of camera shake effect
DeathShakeRadius: "<float>" // Radius within which shake is applied
JumpSound: "<soundPropertyName>" // Sound played when jumping
LandSound: "<soundPropertyName>" // Sound played when landing
Footstep0Sound: "<soundPropertyName>" // Footstep sound variant 0
Footstep1Sound: "<soundPropertyName>" // Footstep sound variant 1
Footstep2Sound: "<soundPropertyName>" // Footstep sound variant 2
HydraulicSound: "<soundPropertyName>" // Hydraulic movement sound
HydraulicSoundHeight: "<float>" // Height threshold for hydraulic sound triggering?
StoppedTurnSpeed: "<float>" // Turn speed when walker is stationary
ForwardTurnSpeed: "<float>" // Turn speed while moving forward
TurnThreshold: "<float>" // Minimum speed required before turning changes behavior
MaxTerrainAngle: "<float>" // Maximum slope angle the walker can traverse
WaterDamageInterval: "<float>" // Time between water damage ticks
WaterDamageAmount: "<float>" // Damage applied per water tick
BallRadius: "<float>" // Collision radius in ball mode
BallMoveSpeed: "<float>" // Movement speed in ball mode
BallStoppedTurnSpeed: "<float>" // Turn speed when stationary in ball mode
BallTurnSpeed: "<float>" // Turn speed while rolling
BallSprintTurnSpeed: "<float>" // Turn speed while sprinting in ball mode
BallSlippage: "<float>" // Lateral slip factor while rolling
BallMaxLean: "<float>" // Maximum lean angle while rolling
BallAcceleration: "<float>" // Acceleration rate in ball mode
BallRollingFriction: "<float>" // Friction applied while rolling
MaxBallAngle: "<float>" // Maximum tilt angle allowed in ball mode
SprintTimeForBowling: "<float>" // Time required sprinting before bowling attack activates
BowlingPush: "<float>" // Force applied during bowling impact
BallSprintSpeedBoost: "<float>" // Additional speed gained while sprinting in ball mode
BallJumpHeight: "<float>" // Jump height in ball mode
BallJumpForwardBoost: "<float>" // Forward boost applied during ball jump
EnergyRestore: "<float>" // Energy restored while moving
EnergyRestoreIdle: "<float>" // Energy restored while idle
EnergyDrainSprint: "<float>" // Energy drained while sprinting
EnergyCostJump: "<float>" // Energy cost for jumping
EnergyCostBowling: "<float>" // Energy cost for bowling attack
WakeEffect: "<fxName>" // Effect played when walker is wading through water
CAMERASECTION: "STAND", "STANDZOOM", "CROUCH", "SPLITSTAND", "SPLITSTANDZOOM", "SPLITCROUCH" // Camera configuration sections
UprightWaterDamageHeight: "<float>" // Water height at which upright mode takes damage
BallWaterDamageHeight: "<float>" // Water height at which ball mode takes damage
HealthGainEffect: "<fxName>" // Effect played when gaining health
AmmoGainEffect: "<fxName>" // Effect played when gaining ammo
EnergyGainEffect: "<fxName>" // Effect played when gaining energy
BuffHealthEffect: "<fxName>" // Effect played when receiving health buff
BuffOffenseEffect: "<fxName>" // Effect played when receiving offense buff
BuffDefenseEffect: "<fxName>" // Effect played when receiving defense buff
DebuffEffect: "<fxName>" // Effect played when receiving a debuff
DropItemClass: "<odfName>" // ODF name of dropped powerupitem class upon death
DropItemProbability: <float> // 0.0-1.0 probability to drop this particular powerupitem
NextDropItem: "-" // ODF Signifier that next DropItem properties apply to a new DropItem
PointsToUnlock: <int> // How many points human players must attain before this unit is selectable from spawn selection screen
```

## Flyer ClassLabel Properties
```
FLYERSECTION: "BODY", "TURRET1", "TURRET2"... // Section header for each vehicle position
GeometryName: "<mshName>" // Mesh used for the flyer’s visual model
FirstPerson: "<pathAndNameOfFPM>" // First person model, listed as path to lvl and model name e.g., CIS\cisdrde;cis_1st_droideka
NoCombatInterrupt: "0", "1" // Whether actions ignore combat interruptions
SoldierCollision: "<nodeName>", "none", "clear" // Whether soldiers collide with the flyer
OrdnanceCollision: "nodeName", "none", "clear" // Whether projectiles collide with the flyer
VehicleType: "<string>" // Classification used by AI and collision systems
AnimationName: "<animBank>" // Animation bank controlling flyer animations
Acceleration: "<float>" // Forward acceleration rate
Acceleraton: "<float>" // Legacy typo version of Acceleration
BoostAcceleration: "<float>" // Acceleration applied during boost
MinSpeed: "<float>" // Minimum forward speed
MidSpeed: "<float>" // Mid-range cruising speed
MaxSpeed: "<float>" // Maximum forward speed
BoostSpeed: "<float>" // Maximum speed while boosting
StrafeSpeed: "<float>" // Lateral strafe speed
PitchRate: "<float>" // Rate of pitch rotation
PitchFilter: "<float>" // Smoothing filter for pitch input
PitchFilterDecel: "<float>" // Deceleration filter for pitch changes
TurnRate: "<float>" // Rate of yaw rotation
TurnFilter: "<float>" // Smoothing filter for yaw input
TurnFilterDecel: "<float>" // Deceleration filter for yaw changes
PitchBuildupMultiplier: "<float>" // Multiplier for pitch acceleration buildup
TurnBuildupMultiplier: "<float>" // Multiplier for turn acceleration buildup
ThrustPitchAngle: "<float>" // Angle applied when accelerating upward/downward
StrafeRollAngle: "<float>" // Roll angle applied when strafing
BankAngle: "<float>" // Maximum banking angle
BankFilter: "<float>" // Smoothing filter for banking
LevelFilter: "<float>" // Smoothing filter for auto-leveling
LevelFilterLanding: "<float>" // Leveling filter used during landing
RollRate: "<float>" // Rate of roll rotation
RollRateAccel: "<float>" // Acceleration of roll rotation
TakeoffHeight: "<float>" // Height flyer will reach while ramping up turnrate when taking off
TakeoffTime: "<float>" // Time required to complete takeoff
TakeoffSpeed: "<float>" // Speed applied during takeoff
LandingTime: "<float>" // Time required to complete landing
LandingSpeed: "<float>" // Speed applied during landing
LandedHeight: "<float>" // Height at which flyer rests when landed
CollisionThreshold: "<float> <float> <float> // Theshold below collision won't deal damage. (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionScale: "<float> <float> <float>" // Multiplier for collision damage taken (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionInflict: "<float>" // Damage inflicted on others when colliding
WeaponSection: "<string>" // Section header for weapon configuration
WeaponName: "<odfName>" // ODF name of weapon class
WeaponAmmo: "<int>" // Ammo count for the weapon
WeaponShareAmmo: "0", "1" // Whether ammo is shared with other weapons
WeaponShareHeat: "0", "1" // Whether heat is shared with other weapons
WeaponChannel: "<int>" // Weapon firing channel index
ExplosionCritical: "<odfName>" // Explosion class used when flyer is critically damaged
Explosion: "<fxName>" // Particle effect played upon flyer death
ExplosionName: "<odfName>" // Explosion class to spawn upon final flyer death
ExplosionDestruct: "<odfName>" // Explosion class to spawn upon flyer death
ThrustEffect: "<fxName>" // Engine thrust particle effect
ThrustEffectMinScale: "<float>" // Minimum scale of thrust effect
ThrustEffectMaxScale: "<float>" // Maximum scale of thrust effect
ThrustEffectScaleStart: "<float>" // Speed at which thrust effect begins scaling
ThrustAttachPoint: "<nodeName>" // Node where thrust effect attaches
ThrustAttachOffset: "<float> <float> <float>" // XYZ offset for thrust effect
ContrailEffect: "<fxName>" // Contrail effect played at high speeds
ContrailAttachPoint: "<nodeName>" // Node in msh where contrail attaches
ContrailAttachOffset: "<float> <float> <float>" // XYZ offset for contrail effect
ContrailEffectMinSpeed: "<float>" // Minimum speed for contrail to appear
ContrailEffectMaxSpeed: "<float>" // Maximum speed for contrail to appear
ContrailEffectMinScale: "<float>" // Minimum contrail scale
ContrailEffectMaxScale: "<float>" // Maximum contrail scale
BlurEffect: "<float>" // Intensity of blur effect when flying at high speeds
BlurStart: "<float>" // Speed at which blur begins
FinAnimation: "<animName>" // Animation for fin movement
PassengerSlots: "<int>" // Number of passenger seats (max 8 units per vehicle)
FOVEffect3rd: "<int>" // FOV change in 3rd-person mode
FOVEFFectMinCamOffset3rd: "<float> <float> <float>" // Min camera offset during FOV effect
FOVEFFectMaxCamOffset3rd: "<float> <float> <float>" // Max camera offset during FOV effect
FOVEffect1st: "<int>" // FOV change in 1st-person mode
EnergyAutoRestore: "<float>" // Rate at which energy regenerates automatically
EnergyBoostDrain: "<float>" // Energy drained while boosting
EnergyTrickDrainSingleTap: "<float>" // Energy cost for single-tap trick
EnergyTrickDrainDoubleTap: "<float>" // Energy cost for double-tap trick
TrickRollSpeed: "<int>" // Speed of roll trick animation
TrickFlipSpeed: "<int>" // Speed of flip trick animation
TrickFlipCameraDetach: "<float>" // Camera detachement intensity during flip trick
TrickSideRollCameraDetach: "<float>" // Camera detachement intensity during side roll
TrickSideRollStrafeSpeed: "<int>" // Strafe speed during side roll trick
MomentumFilter: "<float>" // Smoothing filter for momentum changes?
FreeFlyTime: "<float>" // Time AI can spend flying off a followed entity-path when damaged
TrickTimeMid: "<float>" // Midpoint timing for trick animations?
TrickTimeRange: "<float>" // Allowed timing variance for tricks?
CircleATATFrequency: "<float>" // Frequency of circling behavior around AT-ATs
SquadronMaxAngle: "<float>" // Max angle deviation for squadron formation
SquadronDistance: "<float>" // Distance maintained in squadron formation
TimeRequiredToEject: "<float>" // Splicing time before pilot is ejected from disabled vehicle
EjectResistance: "<float>" // Resistance to haywire/vehicle disabling?
TimeTilReboard: "<float>" // Time before pilot can re-enter after vehicle is disabled
NeverCrashWhenUnpiloted: "0", "1" // Whether flyer will die when unpiloted?
GuidedMissile: "<odfName>" // Guided missile ODF?
GuidedMissileDamage: "<float>" // Damage dealt by guided missile?
GuidedMissileDamageBoost: "<float>" // Additional damage during boost?
PersonScale: "<float>" // Damage scaling vs person units
AnimalScale: "<float>" // Damage scaling vs animal units
DroidScale: "<float>" // Damage scaling vs droid units
VehicleScale: "<float>" // Damage scaling vs vehicles
BuildingScale: "<float>" // Damage scaling vs buildings
ShieldScale: "<float>" // Damage scaling vs shields
GuidedMissileDeathCamPause: "<float>" // Pause before death camera activates?
GuidedMissileDeathCamPullbackSpeed: "<float>" // Speed of camera pullback?
GuidedMissileDeathCamMinDistance: "<float>" // Minimum camera distance?
GuidedMissileBoostExplosionSpeedThreshold: "<float>" // Speed threshold for boosted explosion?
TrickSound: "<soundPropertyName>" // Sound played during trick maneuvers
FlipSound: "<soundPropertyName>" // Sound played during flip tricks
MoveTensionX: "<float>", "<float> <float>" // Camera move tension on X axis, single float for both left/right or two for separate
MoveTensionY: "<float>", "<float> <float>" // Camera move tension on Y axis, single float for both up/down or two for separate
MoveTensionZ: "<float>", "<float> <float>" // Camera move tension on X axis, single float for both forward/backwards or two for separate
AimTension: "<float>" // How far from center reticle may move (Default is 20.0, lower is further from center)
```

## Carrier ClassLabel Properties (Deprecated)
```
CargoNodeName: "<nodeName>" // Node where carried entities attach to the vehicle
CargoNodeOffset: "<float> <float> <float>" // XYZ offset applied to the cargo attachment point
PickupSound: "<soundPropertyName>" // Sound played when the carrier picks up an entity
DropoffSound: "<soundPropertyName>" // Sound played when the carrier drops off an entity
```

## Hover ClassLabel Properties
```
HOVERSECTION: "BODY", "TURRET1", "TURRET2"... // Section header for hover vehicle configuration
GeometryName: "<mshName>" // Mesh used for the hover vehicle’s visual model
FirstPerson: "<pathAndNameOfFPM>" // First person model, listed as path to lvl and model name e.g., CIS\cisdrde;cis_1st_droideka
FPModelAttachedtoCam: "0", "1" // Whether FP model is attached to camera node
NoCombatInterrupt: "0", "1" // Whether actions ignore combat interruptions
SoldierCollision: "nodeName", "none", "clear" // Whether soldiers collide with the hover vehicle
OrdnanceCollision: "nodeName", "none", "clear" // Whether projectiles collide with the hover vehicle
TerrainCollision: "nodeName", "none", "clear" // Whether terrain collision is enabled
SetSpringBody: "<nodeName>" // Node used as the primary spring
AddSpringBody: "<nodeName>" // Additional spring reference node
BodySpringLengthRadiusMultiplier: "<float>" // Multiplier for spring length based on radius
BodyVelocitySpringFactor: "<float>" // Spring force applied based on velocity
BodyVelocityDampFactor: "<float>" // Damping applied to velocity-based spring force
BodyOmegaXSpringFactor: "<float>" // Spring force applied to X-axis angular velocity
BodyOmegaXDampFactor: "<float>" // Damping applied to X-axis angular velocity
BodyOmegaZSpringFactor: "<float>" // Spring force applied to Z-axis angular velocity
BodyOmegaZDampFactor: "<float>" // Damping applied to Z-axis angular velocity
BodySpringLength: "<float>" // Base spring length for hover suspension
VelocitySpring: "<float>" // Spring force applied based on linear velocity
VelocityDamp: "<float>" // Damping applied to linear velocity
OmegaXSpring: "<float>" // Spring force applied to X-axis rotation
OmegaXDamp: "<float>" // Damping applied to X-axis rotation
OmegaZSpring: "<float>" // Spring force applied to Z-axis rotation
OmegaZDamp: "<float>" // Damping applied to Z-axis rotation
NoRandomSpring: "0", "1" // Disables random spring jitter
VehicleType: "<string>" // Classification used by AI and collision systems
SetAltitude: "<float>" // Target hover altitude above ground
GravityScale: "<float>" // Multiplier for gravity affecting the hover vehicle
LiftSpring: "<float>" // Vertical lift force for hovering
LiftDamp: "<float>" // Damping applied to vertical lift
Acceleration: "<float>" // Forward acceleration rate
Deceleration: "<float>" // Braking deceleration rate
Traction: "<float>" // Ground traction factor
ForwardSpeed: "<float>" // Maximum forward speed
ReverseSpeed: "<float>" // Maximum reverse speed
StrafeSpeed: "<float>" // Maximum lateral strafe speed
BoostSpeed: "<float>" // Maximum speed while boosting
BoostAcceleration: "<float>" // Acceleration applied during boost
BoostFOV: "<int>" // FOV increase during boost
BoostTurnMultiplier: "<float>" // Turn rate multiplier while boosting
SpinRate: "<float>" // Rate of spin rotation (yaw spin)
TurnRate: "<float>" // Standard yaw turn rate
TurnFilter: "<float>" // Smoothing filter for turn input
PitchRate: "<float>" // Rate of pitch rotation
PitchLimits: "<float> <float>" // Min/max pitch angle limits
ThrustPitchAngle: "<float>" // Pitch angle applied when accelerating
StrafeRollAngle: "<float>" // Roll angle applied when strafing
BankAngle: "<float>" // Angle at which unit will lean into turns
BankFilter: "<float>" // Smoothing filter for banking
LevelSpring: "<float>" // Spring force used to auto-level the hover
LevelDamp: "<float>" // Damping applied to leveling behavior
CollisionThreshold: "<float> <float> <float> // Theshold below collision won't deal damage. (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionScale: "<float> <float> <float>" // Multiplier for collision damage taken (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionInflict: "<float>" // Damage inflicted on others when colliding
WeaponSection: "<int>" // Section header for weapon configuration
WeaponName: "<odfName>" // Weapon class ODF used for this weapon
WeaponAmmo: "<int>" // Ammo count for the weapon
WeaponShareAmmo: "0", "1" // Whether ammo is shared with other weapons
WeaponShareHeat: "0", "1" // Whether heat is shared with other weapons
WeaponChannel: "<int>" // Weapon firing channel index
Explosion: "<fxName>" // Explosion particle effect triggered on destruction
ExplosionName: "<odfName>" // Explosion class spawned upon vehicle death
AttachNodeName: "<nodeName>" // Node used for attaching flag items
WakeEffect: "<fxName>" // Effect played around hover
WaterEffect: "<fxName>" // Effect played when interacting with water
BlurEffect: "<float>" // Motion blur effect intensity
BlurStart: "<float>" // Speed at which blur begins
GroundedSound: "<soundPropertyName>" // Sound played when contacting ground
GroundedHeight: "<float>" // Height threshold for grounded state
AnimationName: "<animBank>" // Animation bank of vehicle
MovingTurnOnly: "0", "1" // Whether vehicle can turn only when moving forwards or backwards
FloatsOnWater: "0", "1" // Whether the hover floats on water
FinAnimation: "<animName>" // Animation for fin movement (maybe 9-pose animation)
SuspensionNodeName: "<nodeName>" // Node used for suspension animation
SuspensionLeftArmNodeName: "<nodeName>" // Left suspension arm node
SuspensionRightArmNodeName: "<nodeName>" // Right suspension arm node
SuspensionMaxOffset: "<float>" // Maximum suspension travel distance
SuspensionMidOffset: "<float>" // Midpoint suspension offset
PassengerSlots: "<int>" // Number of passenger seats (max 8 units per vehicle)
EnergyAutoRestore: "<float>" // Rate at which energy regenerates automatically
EnergyBoostDrain: "<float>" // Energy drained while boosting
TimeRequiredToEject: "<float>" // Time required for splicing pilot out of vehicle
EjectResistance: "<float>" // Resistance to splicing and ejecting pilot?
TimeTilReboard: "<float>" // Time before pilot can re-enter after vehicle is disabled?
JumpTimeMin: "<float>" // Minimum jump charge time
JumpTimeMax: "<float>" // Maximum jump charge time
JumpForce: "<float>" // Upward force applied during jump
JumpEnergyPerSec: "<float>" // Energy drained per second while charging jump
JumpMinSpeedMult: "<float>" // Minimum speed multiplier applied during jump
WheelSection: "<string>" // Section header for animated textures on wheels
WheelTexture: "<textureName>" // Texture used for wheel animation
WheelVelocToU: "<float>" // Velocity-to-U texture scroll factor
WheelVelocToV: "<float>" // Velocity-to-V texture scroll factor
WheelOmegaToU: "<float>" // Angular velocity-to-U scroll factor
WheelOmegaToV: "<float>" // Angular velocity-to-V scroll factor
```

## Item ClassLabel Properties
```
GeometryName: "<mshName>" // Mesh used for the item's visual model
LifeSpan: "<float>" // Time in seconds before the item despawns
NoLifeSpanDisplay: "0", "1" // Whether the lifespan countdown is hidden
Gravity: "<float>" // Gravity multiplier applied to the item
Rebound: "<float>" // Bounce coefficient when colliding with surfaces
Friction: "<float>" // Sliding friction applied when item contacts the ground
LightOdf: "<odfName>" // ODF for a light object attached to the item
LightColor: "<r> <g> <b> <a>" // RGBA color of the attached light
LightRadius: "<float>" // Radius of the light emitted by the item
CollisionSound: "<soundPropertyName>" // Sound played when colliding with solid objects
CollisionWaterSound: "<soundPropertyName>" // Sound played when colliding with water
CollisionOtherSound: "<soundPropertyName>" // Sound played when colliding with non-standard materials
TrailEffect: "<fxName>" // Particle effect trailing behind the item while moving
```

## Mine ClassLabel Properties
```
Explosion: "<fxName>" // Explosion particle effect when mine dies?
ExplosionName: "<odfName>" // Explosion class ODF when mine dies?
ExplosionTrigger: "<odfName>" // Explosion class ODF when mine is triggered
ExplosionExpire: "<odfName>" // Explosion class ODF when mine expires
ExplosionDeath: "<odfName>" // Explosion class ODF when mine is killed
TriggerContact: "0", "1" // Whether the mine detonates on direct physical contact
TriggerRadius: "<float>" // Radius around the mine that triggers detonation
SuppressRadius: "<float>" // Radius if friendlies are within will suppress the mine from triggering
TickSound: "<soundPropertyName>" // Repeating sound played while the mine is active
TickSoundPitch: "<float>" // Pitch multiplier applied to the ticking sound
```

## Flag ClassLabel Properties
```
SoldierAttachBone: "<boneName>" // Bone on soldier skeleton where the flag attaches
DroidekaAttachBone: "<boneName>" // Bone on droideka skeleton where the flag attaches
GeometryName: "<mshName>" // Mesh used for the flag when placed in the world
CarriedGeometryName: "<mshName>" // Mesh used for the flag when carried by a unit
DroppedInLandingZoneGeometryName: "<mshName>" // Mesh used when dropped inside a landing zone
HomeRegion: "<regionName>" // Region where the flag returns when reset or captured?
AllowTeamPickup: "all", "imp", "rep", "cis" // Which team(s) may pick up the flag?
AllowAIPickup: "0", "1" // Whether AI units are allowed to pick up the flag?
CarriedOffset: "<float> <float> <float>" // XYZ offset applied when attached to a carrier
CarriedColorize: "<r> <g> <b> <a>" // Color tint applied to the carried flag
DroppedColorize: "<r> <g> <b> <a>" // Color tint applied to the dropped flag
PickupSound: "<soundPropertyName>" // Sound played when the flag is picked up
DropSound: "<soundPropertyName>" // Sound played when the flag is dropped
AmbientSound: "<soundPropertyName>" // Looping ambient sound emitted by the flag
```

## PowerupItem ClassLabel Properties
```
SoldierHealth: "<float>" // Amount of health restored to soldier-class units
SoldierAmmo: "<float>" // Amount of ammo restored to soldier-class units
SoldierEnergy: "<float>" // Amount of energy restored to soldier-class units
PersonHealth: "<float>" // Health restored to entities with Person healthtype
PersonAmmo: "<float>" // Ammo restored to entities with Person healthtype
PersonEnergy: "<float>" // Energy restored to entities with Person healthtype
AnimalHealth: "<float>" // Health restored to entities with Animal healthtype
AnimalAmmo: "<float>" // Ammo restored to entities with Animal healthtype
AnimalEnergy: "<float>" // Energy restored to entities with Animal healthtype
DroidHealth: "<float>" // Health restored to entities with Droid healthtype
DroidAmmo: "<float>" // Ammo restored to entities with Droid healthtype
DroidEnergy: "<float>" // Energy restored to entities with Droid healthtype
VehicleHealth: "<float>" // Health restored to entities with Vehicle healthtype
VehicleAmmo: "<float>" // Ammo restored to entities with Vehicle healthtype
VehicleEnergy: "<float>" // Energy restored to entities with Vehicle healthtype
BuildingHealth: "<float>" // Health restored to entities with Building healthtype
BuildingAmmo: "<float>" // Ammo restored to entities with Building healthtype
BuildingEnergy: "<float>" // Energy restored to entities with Building healthtype
BuffOffenseTimer: "<float>" // Duration of offensive buff applied by the pickup
BuffOffenseMult: "<float>" // Multiplier for offensive buff (damage increase)
BuffDefenseTimer: "<float>" // Duration of defensive buff applied by the pickup
BuffDefenseMult: "<float>" // Multiplier for defensive buff (damage reduction)
BuffHealthTimer: "<float>" // Duration of health regeneration buff
BuffHealthRate: "<float>" // Rate of health regeneration during buff
DebuffDamageTimer: "<float>" // Duration of damage-over-time debuff
DebuffDamageRate: "<float>" // Rate of damage applied by debuff
PowerupSound: "<soundPropertyName>" // Sound played when the pickup is collected
AmbientSound: "<soundPropertyName>" // Looping ambient sound emitted by the pickup
```

## RemoteTerminal ClassLabel Properties
```
RemoteGameObject: "<objectName>" // Object name of controlled entity
NextLinkedTerminal: "<objectName>" // Next terminal in a linked terminal chain
PrevLinkedTerminal: "<objectName>" // Previous terminal in a linked terminal chain
GeometryName: "<mshName>" // Mesh used for the terminal’s visual model
VehicleType: "<string>" // Classification used by AI and collision systems (typically REMOTETERMINAL)
```

## Soldier ClassLabel Properties
```
CapturePosts: "0", "1" // Whether the entity can capture command posts
IsAcklay: "0", "1" // Whether this soldier uses Acklay-style step-collision
GeometryName: "<mshName>" // Main high‑res soldier model
GeometryLowRes: "<mshName>" // Low‑res LOD model
AnimationName: "<animBank>" // Animation bank for high‑res model
SkeletonName: "<skelName>" // Skeleton used for high‑res model (synonymous to AnimationName)
AnimationLowRes: "<animBank>" // Animation bank for low‑res model
SkeletonLowRes: "<skelName>" // Skeleton used for low‑res model (synonymous to AnimationLowRes)
FirstPerson: "<pathAndNameOfFPM>" // First person model, listed as path to lvl and model name e.g., CIS\cisdrde;cis_1st_droideka
ClothODF: "<odfName>" // Cloth entity attached to this entity (capes, skirts, etc.)
NoCombatInterrupt: "0", "1" // Whether actions ignore combat interruptions
Acceleration: "<float>" // Forward acceleration rate
Acceleraton: "<float>" // Legacy typo version of Acceleration
MaxSpeed: "<float>" // Maximum forward movement speed
MaxStrafeSpeed: "<float>" // Maximum sideways movement speed
MaxTurnSpeed: "<float>" // Maximum yaw rotation speed
MaxPitchSpeed: "<float>" // Maximum pitch rotation speed
PitchLimits: "<float> <float>" // Min/max pitch angle limits
JumpHeight: "<float>" // Vertical jump height
JumpForwardSpeedFactor: "<float>" // Forward speed multiplier during jump
JumpStrafeSpeedFactor: "<float>" // Strafe speed multiplier during jump
RollSpeedFactor: "<float>" // Speed multiplier during rolls
SprintAccelerateTime: "<float>" // Time required to reach full sprint speed
RecoverFromTumble: "<float>" // Time to recover from tumble state
UseDirectionalJumps: "0", "1" // Whether directional jump animations are used
UseDirectionalDeaths: "0", "1" // Whether directional death animations are used
ControlSpeed: "<stance> <thrustFactor> <strafeFactor> <turnFactor>" // Movement control per stance (stand/crouch/sprint...)
CollisionThreshold: "<float> <float> <float> // Theshold below collision won't deal damage. (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionScale: "<float> <float> <float>" // Multiplier for collision damage taken (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionInflict: "<float>" // Damage inflicted on others when colliding
UnitType: "Scout", "Trooper", "Pilot", "Assault", "Anti-Armor", "Repair", "Support", "Special" // AI behavior class
ImmuneToMines: "0", "1" // Whether this entity triggers mines
WeaponSection: "<int>" // Section header for weapon configuration
WeaponName: "<odfName>" // ODF name of weapon class
WeaponAmmo: "<int>" // Ammo for this weapon
WeaponShareAmmo: "0", "1" // Whether primary weapon shares ammo with other weapons
WeaponShareHeat: "0", "1" // Whether primary weapon shares heat with other weapons
WeaponChannel: "<int>" // Firing channel for this weapon
PrimaryWeapon: "<odfName>" // Primary weapon ODF (alias)?
SecondaryWeapon: "<odfName>" // Secondary weapon ODF (alias)?
EnergyRestore: "<float>" // Energy restored while moving
EnergyRestoreIdle: "<float>" // Energy restored while idle
EnergyDrainSprint: "<float>" // Energy drained while sprinting
EnergyCostJump: "<float>" // Energy cost for jumping
EnergyCostJumpSprint: "<float>" // Energy cost for sprint‑jump
EnergyCostRoll: "<float>" // Energy cost for rolling
JetJump: "<float>" // Vertical impulse for jet jump (or double-jump)
JetPush: "<float>" // Constant push while jet is active (20.0 is gravity)
JetAcceleration: "<float>" // Acceleration while jetting
JetShowHud: "0", "1" // Whether jet HUD meter is shown
JetEnergyDrain: "<float>" // Energy drained while jetting
JetFuelRechargeRate: "<float>" // Jet fuel recharge rate (0.0 - 1.0)
JetFuelCost: "<float>" // Fuel cost per jet activation (0.0 - 1.0)
JetFuelInitialCost: "<float>" // Fuel cost at jet start (0.0 - 1.0)
JetFuelMinBorder: "<float>" // Minimum fuel required to activate jet (0.0 - 1.0)
HealthGainEffect: "<fxName>" // Effect when gaining health
AmmoGainEffect: "<fxName>" // Effect when gaining ammo
EnergyGainEffect: "<fxName>" // Effect when gaining energy
BuffHealthEffect: "<fxName>" // Effect for health buff
BuffOffenseEffect: "<fxName>" // Effect for offense buff
BuffDefenseEffect: "<fxName>" // Effect for defense buff
DebuffEffect: "<fxName>" // Effect for debuffs
InvincibleEffect: "<fxName>" // Effect when invincible
JetEffect: "<fxName>" // Jetpack flame effect
JetIdleEffect: "<fxName>" // Idle jetpack effect
JetType: "hover" // Jet behavior type (Set to set hovering behavior)
FootSlideEffect: "<fxName>" // Effect when sliding on ground
ChokeEffect: "<fxName>" // Effect when being force‑choked
BlurEffect: "<fxName>" // Motion blur effect
WaterSplashEffect: "<fxName>" // Splash when entering water
FootWaterSplashEffect: "<fxName>" // Footstep water splash
WakeWaterSplashEffect: "<fxName>" // Wake splash when moving through water
CAMERASECTION: "STAND", "STANDZOOM", "CROUCH", "CROUCHZOOM", "SPRINT" // Camera configuration sections
EyePointOffset: "<float> <float> <float>" // Offset for camera eye point -unique to CAMERASECTION
TrackCenter: "<float> <float> <float>" // Vertical offset for camera tracking -unique to CAMERASECTION
TrackOffset: "<float> <float> <float>" // Distance offset for camera tracking -unique to CAMERASECTION
TiltValue: "<float>" // Camera tilt applied during movement -unique to CAMERASECTION
CameraBlendTime: "<float>" // Time to blend between camera states -unique to CAMERASECTION
FootstepStride: "<float>" // Distance between footstep sounds
RunSpeed: "<float>" // Speed used for run animation scaling
AcquiredTargetSound: "<soundPropertyName>" // AI: target acquired
HidingSound: "<soundPropertyName>" // AI: hiding
ApproachingTargetSound: "<soundPropertyName>" // AI: approaching target
FleeSound: "<soundPropertyName>" // AI: fleeing
PreparingForDamageSound: "<soundPropertyName>" // AI: bracing for hit
HeardEnemySound: "<soundPropertyName>" // AI: heard enemy
ChargeSound: "<soundPropertyName>" // AI: charging
ShockFadeOutTime: "<float>" // Deprecated? Shock effect fade‑out time
ShockFadeInTime: "<float>" // Deprecated? Shock effect fade‑in time
ShockFadeOutGain: "<float>" // Deprecated? Shock effect gain reduction
ShockSound: "<soundPropertyName>" // Deprecated? Shock effect sound
ClothingRustleSound: "<soundPropertyName>" // Cloth movement sound
LowHealthSound: "<soundPropertyName>" // Sound when low on health
LowHealthThreshold: "<float>" // Health threshold for low‑health state
ChokeSound: "<soundPropertyName>" // Sound when being choked
AmbientSound: "<soundPropertyName>" // Looping ambient sound
DropItemClass: "<odfName>" // Item class dropped on death
DropItemProbability: "<float>" // Chance to drop that item class
NextDropItem: "-" // Start of next section of DropItem properties
SkeletonRootScale: "<float>" // Scale of root bone
CollisionRootScale: "<float>" // Scale of root collision
CollisionHeadScale: "<float>" // Scale of head collision
CollisionTorsoScale: "<float>" // Scale of torso collision
CollisionHeadOffset: "<float> <float> <float>" // Offset for head collision
CollisionTorsoOffset: "<float> <float> <float>" // Offset for torso collision
SkeletonRootScaleLowRes: "<float>" // Low‑res skeleton scale
Explosion: "<fxName>" // Explosion particle effect on death
ExplosionName: "<odfName>" // Explosion class ODF spawned on death
ChunkFrequency: "<float>" // Frequency of destroyed chunks on death
OverrideTexture: "<textureName>" // Texture override for main model
OverrideTexture2: "<textureName>" // Secondary texture override
AnimatedAddon: "<anyName>" // Addon section identifier
GeometryAddon: "<mshName>" // addon geometry (antenna, visor, backpack, etc.)
AnimationAddon: "<animBank>" // Animation bank for addon
AddonAttachJoint: "<boneName>" // Bone where addon attaches
SndHeroSelectable: "<soundPropertyName>" // Sound when hero is selectable
SndHeroSpawned: "<soundPropertyName>" // Sound when hero spawns
SndHeroDefeated: "<soundPropertyName>" // Sound when hero dies
SndHeroKiller: "<soundPropertyName>" // Sound when hero kills someone?
SoldierMusic: "<musicTrack>" // Music for player soldier
AISoldierMusic: "<musicTrack>" // Music for AI soldier
SoldierAnnoucement: "<soundPropertyName>" // Announcement sound
FleeLikeAHero: "0", "1" // Play hero-death animation instead of normal death animation
MinFootHeight: "<float>" // Minimum foot height for ground detection
TargetPointOffsetStand: "<float> <float> <float>" // Aim point offset when standing
TargetPointOffsetCrouch: "<float> <float> <float>" // Aim point offset when crouched
TentacleCollType: "0", "1", "2 // Collision type for tentacles- 0 Box, 1 Sphere, 2 Cylinder (If under AnimatedAddon line, this will apply to addon tentacles instead of primary model tentacles)
NumTentacles: "<int>" // Number of tentacles (max 4)
BonesPerTentacle: "<int>" // Bones per tentacle (max 5)
```

## Walker ClassLabel Properties
```
GeometryName: "<mshName>" // Mesh used for the walker’s visual model
WALKERSECTION: "<sectionName>" // Section header for walker configuration (BODY, TURRET1, TURRET2, ...)
StompRumbleLightDuration: "<float>" // Duration of light controller rumble during small stomps
StompRumbleHeavyDuration: "<float>" // Duration of heavy controller rumble during big stomps
StompRumbleHeavy: "<float>" // Intensity of heavy stomp controller rumble
StompRumbleLight: "<float>" // Intensity of light stomp controller rumble
FPWalkScale: "<float>" // First‑person camera bobbing scale while walking
FPPosePointName: "<nodeName>" // Node used for first‑person camera pose
VehicleType: "<string>" // Classification used by AI and collision systems
NoCombatInterrupt: "0", "1" // Whether actions ignore combat interruptions
AnimationName: "<animBank>" // Animation bank for walker animations
SkeletonName: "<animBank>" // Animation bank for walker animations (synonymous to AnimationName)
SkeletonRootScale: "<float>" // Scale of root bone
AnimationBlending: "<float>" // Blend factor between animations
Acceleration: "<float>" // Forward acceleration rate
Acceleraton: "<float>" // Legacy typo version of Acceleration
MaxSpeed: "<float>" // Maximum forward speed
BoostSpeed: "<float>" // Maximum speed while boosting
JumpHeight: "<float>" // Vertical jump height
JumpForwardSpeedBoost: "<float>" // Forward boost applied during jump
JumpMinSpeed: "<float>" // Minimum speed required to initiate jump
MaxTurnSpeed: "<float>" // Maximum yaw rotation speed
MaxYawSpeed: "<float>" // Alias/fallback for yaw rotation speed
YawLimits: "<float> <float>" // Min/max yaw angle limits
MaxPitchSpeed: "<float>" // Maximum pitch rotation speed
PitchLimits: "<float> <float>" // Min/max pitch angle limits
ThrustAngleToStrafe: "<float>" // Angle threshold for converting thrust to strafe
ThrustAngleToTurn: "<float>" // Angle threshold for converting thrust to turn
ThrustAngleToStop: "<float>" // Angle threshold for converting thrust to braking
SteerTowardAimRate: "<float>" // Rate at which walker steers toward aim direction
SteerAtYawLimit: "<float>" // Steering behavior when yaw limit is reached
SteerAtStrafeLimit: "<float>" // Steering behavior when strafe limit is reached
CorrectAimForSteering: "0", "1" // Whether aim is corrected based on steering
ReverseBackwardSteering: "0", "1" // Whether steering reverses when moving backward
CollisionThreshold: "<float> <float> <float> // Theshold below collision won't deal damage. (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionScale: "<float> <float> <float>" // Multiplier for collision damage taken (first float is value independent of direction, second makes value larger from hits from top or bottom, third float makes values larger from front or back)
CollisionInflict: "<float>" // Damage inflicted on others when colliding

WeaponSection: "<int>" // Section header for weapon configuration
WeaponName: "<odfName>" // Weapon class ODF for this weapon
WeaponAmmo: "<int>" // Ammo count for this weapon
WeaponShareAmmo: "0", "1" // Whether ammo is shared with other weapons
WeaponShareHeat: "0", "1" // Whether heat is shared with other weapons
WeaponChannel: "<int>" // Weapon firing channel index
Explosion: "<fxName>" // Explosion particle effect triggered on destruction?
ExplosionName: "<odfName>" // Explosion class ODF triggered on death
ExplosionOffset: "<float> <float> <float>" // Offset for explosion
FinalExplosion: "<fxName>" // Final explosion particle effect after destruction sequence
FinalExplosionName: "<odfName>" // Final explosion ODF after destruction sequence
FinalExplosionOffset: "<float> <float> <float>" // Offset for final explosion
StompEffect: "<fxName>" // Effect played when walker stomps
StompDecal: "<fxName>" // Decal placed by stomp
StompDecalSize: "<float>" // Size of stomp decal
FootWaterSplashEffect: "<fxName>" // Splash effect when foot hits water
AttachNodeName: "<nodeName>" // Node used for attaching items like flags
DeathAnimationExplosion: "<odfName>" // Explosion class ODF during death animation
DeathAnimationExplosionTime: "<float>" // Time offset for explosion during death anim
DeathDustEffect: "<fxName>" // Dust effect during destruction
DeathDustDelay: "<float>" // Delay before dust triggers
DeathDustOffset: "<float> <float> <float>" // Offset for dust effect
DeathShakeDelay: "<float>" // Delay before camera shake begins
DeathShakeForce: "<float>" // Strength of camera shake
DeathShakeDuration: "<float>" // Duration of camera shake
DeathShakeRadius: "<float>" // Radius within which shake is applied
DeathFadeTimeStart: "<float>" // Time when fading begins?
DeathFadeTimeEnd: "<float>" // Time when fading ends?
StompDetectionType: "1" // Method used to detect stomp collisions
StompThreshold: "<float>" // Minimum force required to trigger stomp
FootstepSound0: "<soundPropertyName>" // Footstep sound variant 0
FootstepSound1: "<soundPropertyName>" // Footstep sound variant 1
FootstepSound2: "<soundPropertyName>" // Footstep sound variant 2
FootstepSound3: "<soundPropertyName>" // Footstep sound variant 3
FootstepSound4: "<soundPropertyName>" // Footstep sound variant 4
FootstepSound5: "<soundPropertyName>" // Footstep sound variant 5
HydraulicSound: "<soundPropertyName>" // Hydraulic movement sound
HydraulicSoundHeight: "<float>" // Height threshold for hydraulic sound
HydraulicLowerSound: "<soundPropertyName>" // Hydraulic lowering sound
HydraulicLowerHeight: "<float>" // Height threshold for lowering sound
StoppedTurnSpeed: "<float>" // Turn speed when stationary
ForwardTurnSpeed: "<float>" // Turn speed while moving forward
BoostTurnSpeed: "<float>" // Turn speed while boosting
EnergyAutoRestore: "<float>" // Energy restored automatically
EnergyBoostDrain: "<float>" // Energy drained while boosting
EnergyCostJump: "<float>" // Energy cost for jumping
TurnThreshold: "<float>" // Minimum speed before turning changes behavior
MaxTerrainAngle: "<float>" // Maximum slope angle walker can traverse
LegPairCount: "<int>" // Number of leg pairs
WalkerLegPair: "LEGS", "front_legs", "back_legs" // Leg-pair section identifier/separator
LegRayHitLength: "<float>" // Length of raycast used for foot placement
WalkerOrientRoll: "<float>" // Roll orientation factor for walker
FootBoneLeft: "<boneName>" // Left foot bone
FootBoneRight: "<boneName>" // Right foot bone
TerrainLeft: "<nodeName>" // Terrain collision primitive for left foot
TerrainRight: "<nodeName>" // Terrain collision primitive for right foot
LegBoneLeft: "<boneName>" // Lower leg bone left
LegBoneRight: "<boneName>" // Lower leg bone right
LegBoneTopLeft: "<boneName>" // Upper leg bone left
LegBoneTopRight: "<boneName>" // Upper leg bone right
WaterDamageInterval: "<float>" // Time between water damage ticks
WaterDamageAmount: "<float>" // Damage per water tick
FirstPerson: "<pathAndNameOfFPM>" // First‑person model path (e.g. CIS\cisdrde;cis_1st_droideka)
DropShadowSize: "<float>" // Size of shadow under walker?
PassengerSlots: "<int>" // Number of passenger seats (max 8 units per vehicle)
TowCableCollision: "<nodeName> <float> <float> <float>" // Tow cable collision primitive node and XYZ offset
IgnorableCollision: "<collisionType>" // Collision types walker ignores
IgnorableCollsion: "<collisionType>" // Legacy misspelling
WalkerWidth: "<float>" // Width of walker footprint?
SmashParkedFlyers: "0", "1" // Whether walker damages parked flyers
TimeRequiredToEject: "<float>" // Time for splicing to eject pilot?
EjectResistance: "<float>" // Resistance to vehicle disabling?
TimeTilReboard: "<float>" // Time before pilot can re-enter disabled vehicle
AIUseHoverPhysics: "0", "1" // Whether AI uses hover physics instead of walker physics
```

## Hologram ClassLabel Properties
```
Color: "<int> <int> <int>" // Base RGB tint applied to the hologram
NeutralColor: "<int> <int> <int>" // Neutral RGB tint applied to the hologram
FriendlyColor: "<int> <int> <int>" // Friendly RGB tint applied to the hologram
EnemyColor: "<int> <int> <int>" // Enemy RGB tint applied to the hologram
LocalsColor: "<int> <int> <int>" // Local RGB tint applied to the hologram
HoloImageGeometry: "<mshName>" // msh used for the projected hologram image
HoloVisibleDistance: "<float>" // Max distance at which hologram becomes visible
HoloHeight: "<float>" // Vertical offset of hologram above projector
HoloSize: "<float>" // Uniform scale of hologram image
HoloBeamInitialWidth: "<float>" // Starting width of the projection beam
HoloBeamIntensity: "<float>" // Brightness of the beam column
HoloLightIntensity: "<float>" // Intensity of hologram’s light emission
HoloImageIntensity: "<float>" // Brightness of the hologram image
HoloFlareIntensity: "<float>" // Intensity of flare/glow around the hologram
HoloLightRadius: "<float>" // Radius of emitted light
HoloRotateRate: "<float>" // Rotation speed of hologram image
HoloPopRate: "<float>" // Speed of “pop‑in” scaling when appearing
HoloFlickerRate: "<float>" // Frequency of flicker effect
HoloFlickerAlphaMin: "<float>" // Minimum alpha during flicker
HoloFlickerAlphaMax: "<float>" // Maximum alpha during flicker
HoloFadeInTime: "<float>" // Time required for hologram to fade in
HoloTurnOnDistance: "<float>" // Distance at which hologram activates when approached
HoloType: "build", "aligned" // Hologram classification (buildable symbol, or team-aligned symbol)
```

## Light ClassLabel Properties
```
Color: "<int> <int> <int> <int>" // Base RGBA color of the light
ConeLength: "<float>" // Length of the projected light cone (spotlights only)
ConeWidth: "<float>" // Final width of the cone at full length (spotlights only)
ConeInitialWidth: "<float>" // Starting width of the cone near the emitter (spotlights only)
ConeFadeFactor: "<float>" // Rate at which cone intensity fades over distance (spotlights only)
ConeFadeLength: "<float>" // Distance over which cone fade is applied (spotlights only)
HaloRadius: "<float>" // Radius of halo/glow around the light source
HaloFadeFactor: "<float>" // Rate at which halo fades with distance
HaloFadeLength: "<float>" // Distance over which halo fade is applied
FlareIntensity: "<float>" // Intensity of light flare effect
BeamIntensity: "<float>" // Brightness of the beam column
FlickerType: "None", "Strobe", "StrobeRandom", "StrobeFade", "Pulse", "Flicker" // Flicker behavior mode
FlickerPeriod: "<float>" // Time between flicker pulses
FadePeriod: "<float>" // Time for fade‑in/out cycles
OmniRadius: "<float>" // Radius of omnidirectional light emission (omnilights only)
SpotInnerConeAngle: "<float>" // Angle of full‑intensity inner cone (spotlights only)
SpotOuterConeAngle: "<float>" // Angle where intensity falls to zero (spotlights only)
DrawDistance: "<float>" // Maximum distance at which light is rendered
Static: "0", "1" // Whether the light is static (Does not affect vertex-lit meshes)
ShadowCaster: "0", "1" // Whether the light casts shadows
SpecularCaster: "0", "1" // Whether the light contributes to specular highlights
Bidirectional: "0", "1" // Whether the light emits forward and backward (spotlights only)
Name: "<string>" // Identifier for the light object?
Type: "Spot", "Omni" // Light type: spotlight or omnidirectional
ProjectedTexture: "<textureName>" // Texture projected by the light
FrameRate: "<float>" // Frame rate for animated projected textures
Synchronize: "0", "1" // Whether lights synchronize?
```

## GrassPatch ClassLabel Properties
```
MinSize: "<float>" // Minimum scale of individual grass particles
MaxSize: "<float>" // Maximum scale of individual grass particles
Alpha: "<float>" // Base alpha transparency for grass quads
NumParticles: "<int>" // Number of grass particles to render in the patch
MaxDistance: "<float>" // Maximum distance at which patch is rendered
RadiusFadeMin: "<float>" // Distance at which grass begins fading out
RadiusFadeMax: "<float>" // Distance at which grass fully fades out
DarknessMin: "<float>" // Minimum shading multiplier (darkest)
DarknessMax: "<float>" // Maximum shading multiplier (brightest)
NumParts: "<int>" // Number of geometry parts per particle (billboards, blades)
YOffset: "<float>" // Vertical offset applied to grass placement
Texture: "<textureName>" // Texture used for grass blades/quads
BoxSize: "<float> <float>" // Size of bounding box for particle distribution?
FlatHeight: "<float>" // Height of flat grass quads?
FlatSizeMultiplier: "<float>" // Multiplier applied to flat grass size?
FlatFaceFactor: "<float>" // How much flat grass faces the camera?
FlatShadowHeight: "<float>" // Height of shadow under flat grass?
FlatGrassSwing: "<float>" // Amount of swaying motion applied to flat grass?
FlatCount: "<int>" // Number of flat grass quads per patch?
SkinnyFactor: "<float>" // Multiplier for thin/skinny grass shapes?
MaxSkew: "<float>" // Maximum skew applied to grass quads
TransparentType: "<string>" // Transparency method? (blended is default, hardedged option? Unknown.)
```

## LeafPatch ClassLabel Properties
```
MaxDistance: "<float>" // Maximum distance at which leaf patch is rendered
Offset: "<float>" // Vertical offset applied to leaf placement
BoxSize: "<float> <float>" // Size of bounding box for particle distribution?
MinSize: "<float>" // Minimum scale of individual leaves
MaxSize: "<float>" // Maximum scale of individual leaves
Alpha: "<float>" // Base alpha transparency for leaf quads
NumParticles: "<int>" // Number of leaf particles in the patch
Radius: "<float>" // Radius of leaf distribution around patch center
Height: "<float>" // Height range for leaf placement
ConeHeight: "<float>" // Height of cone-shaped distribution (falling leaves)
DarknessMin: "<float>" // Minimum shading multiplier
DarknessMax: "<float>" // Maximum shading multiplier
HeightScale: "<float>" // Multiplier for vertical scaling of leaves
NumVisible: "<int>" // Max number of leaves visible at once (LOD control)
Texture: "<textureName>" // Texture used for leaf quads
MaxFallingLeaves: "<int>" // Maximum number of falling leaves simulated
MaxScatterBirds: "<int>" // Maximum number of birds triggered by leaf patch
Seed: "<int>" // Random seed for deterministic leaf distribution
NumParts: "<int>" // Number of geometry parts per leaf particle
Vine: "<float> <float>" // Width and height?
VineLength: "<float>" // Length of vine strands
VineSpread: "<float>" // Horizontal spread of vine strands
WiggleSpeed: "<float>" // Speed of leaf/vine wiggle animation
WiggleAmount: "<float>" // Amplitude of wiggle animation
```

## RotatingModel ClassLabel Properties
```
RotateNodeName: "<nodeName>" // Node that rotates?
YawConstant: "<float>" // Constant rotation speed in degrees/sec (always rotates)
YawRandom: "<float>" // Randomized additional rotation speed range (adds variation)?
```

## RumbleEffect ClassLabel Properties
```
MinLight: "<float>" // Minimum intensity for light rumble motor
MaxLight: "<float>" // Maximum intensity for light rumble motor
MinHeavy: "<float>" // Minimum intensity for heavy rumble motor
MaxHeavy: "<float>" // Maximum intensity for heavy rumble motor
MinHeavyDecay: "<float>" // Minimum decay rate for heavy motor intensity
MaxHeavyDecay: "<float>" // Maximum decay rate for heavy motor intensity
MinLightDecay: "<float>" // Minimum decay rate for light motor intensity
MaxLightDecay: "<float>" // Maximum decay rate for light motor intensity
MinDelayLight: "<float>" // Minimum delay before light motor activates
MaxDelayLight: "<float>" // Maximum delay before light motor activates
MinDelayHeavy: "<float>" // Minimum delay before heavy motor activates
MaxDelayHeavy: "<float>" // Maximum delay before heavy motor activates
MinTimeLeftHeavy: "<float>" // Minimum duration heavy motor remains active
MaxTimeLeftHeavy: "<float>" // Maximum duration heavy motor remains active
MinTimeLeftLight: "<float>" // Minimum duration light motor remains active
MaxTimeLeftLight: "<float>" // Maximum duration light motor remains active
MinInterval: "<float>" // Minimum interval between rumble pulses
MaxInterval: "<float>" // Maximum interval between rumble pulses
MinShakeAmt: "<float>" // Minimum camera shake amplitude (if tied to rumble)
MaxShakeAmt: "<float>" // Maximum camera shake amplitude
MinShakeLen: "<float>" // Minimum camera shake duration
MaxShakeLen: "<float>" // Maximum camera shake duration
SoundName: "<soundPropertyName>" // Sound triggered with rumble effect
```

## SoundAmbienceStatic
```
Sound: "<soundPropertyName>" // In-memory sound property to play
MinDistance: "<float>" // Minimum distance before sound fades in/out
MaxDistance: "<float>" // Maximum distance before sound fades in/out
```

## SoundAmbienceStatic
```
Sound: "<soundPropertyName>" // In-memory sound property to play
MinDistance: "<float>" // Minimum distance before sound fades in/out
MaxDistance: "<float>" // Maximum distance before sound fades in/out
```

## VehiclePad ClassLabel Properties
```
ControlZone: "<cpName>" // Controlling commandpost object
SpawnTime: <float> // Delay before spawning a new vehicle after previous death
ExpireTimeEnemy: <float> // Delay after enemy captures controlling CP before killing already-spawned vehicles
ExpireTimeField: <float>
DecayTime: <float> // Time to kill a vehicle outside controlling CP's control region when unoccupied
ClassAllATK: "<className>" // Vehicle class to spawn when controlling CP team is Rebel Alliance as Attackers
ClassCISATK: "<className>" // Vehicle class to spawn when controlling CP team is CIS as Attackers
ClassImpATK: "<className>" // Vehicle class to spawn when controlling CP team is Empire as Attackers
ClassRepATK: "<className>" // Vehicle class to spawn when controlling CP team is Republic as Attackers
ClassLocATK: "<className>" // Vehicle class to spawn when controlling CP team is Locals as Attackers
ClassHisATK: "<className>" // Vehicle class to spawn when controlling CP team is the "Historical" Attackers
ClassAllDEF: "<className>" // Vehicle class to spawn when controlling CP team is Rebel Alliance as Defenders
ClassCISDEF: "<className>" // Vehicle class to spawn when controlling CP team is CIS as Defenders
ClassImpDEF: "<className>" // Vehicle class to spawn when controlling CP team is Empire as Defenders
ClassRepDEF: "<className>" // Vehicle class to spawn when controlling CP team is Republic as Defenders
ClassLocDEF: "<className>" // Vehicle class to spawn when controlling CP team is Locals as Defenders
ClassHisDEF: "<className>" // Vehicle class to spawn when controlling CP team is the "Historical" Defenders
```

## VehicleSpawn ClassLabel Properties
```
Team: "<int>" // Team that owns this vehicle spawn (team index from 0 - 9)
ControlZone: "<objectName>" // Controlling CommandPost object name
SpawnCount: "<int>" // Number of vehicles that may be spawned at once (if enough room)
SpawnTime: "<float>" // Delay between vehicle death and respawning another
ExpireTimeEnemy: "<float>" // Time until vehicle despawns when enemy‑occupied
ExpireTimeField: "<float>" // Time until vehicle despawns when abandoned in field
DecayTime: "<float>" // Time until vehicle is destroyed from decay damage

ClassNeutral: "<odfName>" // Vehicle for when ControlZone team is neutral
ClassAllATK: "<odfName>" // Vehicle for when ControlZone team is Rebel Alliance as Attackers
ClassCISATK: "<odfName>" // Vehicle for when ControlZone team is CIS as Attackers
ClassImpATK: "<odfName>" // Vehicle for when ControlZone team is Empire as Attackers
ClassRepATK: "<odfName>" // Vehicle for when ControlZone team is Republic as Attackers
ClassLocATK: "<odfName>" // Vehicle for when ControlZone team is Locals as Attackers
ClassHisATK: "<odfName>" // Vehicle for when ControlZone team is the "Historical" Attackers
ClassAllDEF: "<odfName>" // Vehicle for when ControlZone team is Rebel Alliance as Defenders
ClassCISDEF: "<odfName>" // Vehicle for when ControlZone team is CIS as Defenders
ClassImpDEF: "<odfName>" // Vehicle for when ControlZone team is Empire as Defenders
ClassRepDEF: "<odfName>" // Vehicle for when ControlZone team is Republic as Defenders
ClassLocDEF: "<odfName>" // Vehicle for when ControlZone team is Locals as Defenders
ClassHisDEF: "<odfName>" // Vehicle for when ControlZone team is the "Historical" Defenders
ClassLocals: "<odfName>" // Vehicle used by local faction
```

## GodRay ClassLabel Properties
```
Radius: "<float>" // Radius of the god‑ray cone or circular emission area
MinLifetime: "<float>" // Minimum lifetime of each ray particle
MaxLifetime: "<float>" // Maximum lifetime of each ray particle
MinAlpha: "<float>" // Minimum alpha transparency for rays
MaxAlpha: "<float>" // Maximum alpha transparency for rays
Color: "<int> <int> <int>" // RGB tint applied to all rays
NumRays: "<int>" // Number of ray quads emitted at once
SpreadRadius: "<float>" // Horizontal spread of rays around the origin (controls fan width)
```

## Most Classes with Geometry
```
AttachDynamic: "0", "1" // Allows for attaching an ODF or particle effect to a moving/animated entity
AttachOdf: "<odfName>" // Attach another entity (light) to this entity
AttachEffect: "<fxName>" // Attach a particle effect entity (lightbeam, lensflare) to this entity
AttachToHardpoint: "<nodeName>" // Attaches last defined `AttachOdf` or `AttachEffect` entity to this node in the msh
```
