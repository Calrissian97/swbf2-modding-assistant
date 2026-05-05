# Memory Pools
This document explains the memory pool system used by Star Wars Battlefront 2.

Sections:
- Memory Pools Overview (lines 10-15)
- Valid Memory Pools (lines 17-86)

---

# Overview
Several entities require special memory allocations to be created in the game. You can specify the number of entries in a memory pool from the Lua script using the `SetMemoryPoolSize` function. This number is typically the count of entities to be allocated for. Some memory pools will be automatically raised during mission startup, but this behavior cannot be relied on, and it is recommended to always allocate memory pools in the `ScriptInit`function of the mission script. 

Usage: `SetMemoryPoolSize("<pool_name>", <count>)`

**Usage Note:** These commands must be placed in `ScriptInit` before assets are loaded in via the `ReadDataFile` function to avoid warnings regarding the pool counts in the Bfront2.log when running the debugger.

# Valid Memory Pools
| Pool Name | Recommended/Example Count | Description |
| :--- | :--- | :--- |
| `ParticleTransformer::PositionTr` | 2000 | Rendering; set before loading any assets. |
| `ParticleTransformer::ColorTrans` | 3000 | Rendering; set before loading any assets. |
| `ParticleTransformer::SizeTransf` | 1600 | Rendering; set before loading any assets. |
| `FLEffectObject::OffsetMatrix` | 256 | Rendering/Effects; raise as needed. |
| `AcklayData` | 16 | Memory required for "Acklay" entities. |
| `ActiveRegion` | Active region count? |
| `ClothData` | 128 | Global cloth simulation data allocation. |
| `Combo` | 50 | Combat combos (typically ~2x number of Jedi classes). |
| `Combo::State` | 650 | Combo states (~12x `Combo`). |
| `Combo::Transition` | 650 | Combo transitions (slightly larger than `Combo::State`). |
| `Combo::Condition` | 650 | Combo conditions (slightly larger than `Combo::State`). |
| `Combo::Attack` | 550 | Combo attacks (~8-12x `Combo`). |
| `Combo::DamageSample` | 6000 | Damage samples (~8-12x `Combo::Attack`). |
| `Combo::Deflect` | 100 | Combo deflects (~1x `Combo`). |
| `Music` | 40 | Music-related engine memory. |
| `Weapon` | 64 | Number of weapon entities. |
| `Ordnance` | 256 | Ordnance entity memory (lower for heroes vs villains). |
| `OrdnanceTowCable` | 40 | Tow cable ordnance memory. |
| `LightFlash` | ? | Seems unused, possibly related to ordnance. |
| `ShieldEffect` | 64 | Shield Effect memory. |
| `Aimer` | 256 | Weapon aiming logic; check log and raise if needed. |
| `AmmoCounter` | 64 | UI ammo counter memory. |
| `EnergyBar` | 64 | UI energy bar memory. |
| `SoldierAnimation` | 1024 | Unit animation memory. |
| `UnitAgent` | 64 | Number of units (AI allotment). |
| `UnitController` | 64 | Number of units (AI controller memory). |
| `Navigator` | 64 | Number of controllable entities (AI navigation). |
| `ConnectivityGraphFollower` | 32 | Number of connectivity graph followers? |
| `PathFollower` | 32 | Number of entity-path follower entities? |
| `EntityCloth` | 64 | Number of cloth entities (includes props with cloth). |
| `EntityBuildingArmedDynamic` | 4 | Unknown if required, EntityBuildingArmedDynamic count? |
| `EntityCarrier` | 2 | Deprecated functionality, carrier entity count. |
| `EntitySoldier` | 32 | Seems unused, count of soldier entities. |
| `EntityTauntaun` | 4 | Seems unused, count of tauntaun entities. |
| `EntityDroideka` | 4 | Seems unused, count of droideka entities? |
| `EntityMine` | 24 | Number of mine entities in the world. |
| `TentacleSimulator` | 24 | Number of tentacles to simulate. |
| `MountedTurret` | 32 | Number of turrets in the world. |
| `EntityDefenseGridTurret` | 32 | Number of CP turrets in the world (Galactic Conquest bonus). |
| `EntityPortableTurret` | 24 | Number of deployable turrets in the world. |
| `EntityDroid` | 16 | Number of droid entities. |
| `EntityHover` | 4 | Number of hover vehicles. |
| `CommandHover` | 2 | Number of transport hover vehicles. |
| `EntityWalker` | 4 | Number of walker entities. |
| `CommandWalker` | 2 | Number of transport walker entities. |
| `EntityFlyer` | 4 | Number of flyer entities. |
| `CommandFlyer` | 4 | Number of transport flyer entities. |
| `EntityRemoteTerminal` | 12 | Number of remote terminal entities. |
| `PassengerSlot` | 0 | Unknown function, passenger slot functionality? |
| `EntityLight` | 200 | Number of lights in the world. |
| `EntitySoundStream` | 24 | Number of Sound Stream entities. |
| `EntitySoundStatic` | 24 | Number of Sound Static entities. |
| `BaseHint` | 1024 | Hint node memory. |
| `Obstacle` | 1024 | Barrier memory. |
| `PathNode` | 512 | Spawn-path and flyer-path nodes. |
| `PathRequest` | ? | Seems unused, related to entity-path-following? |
| `SoundSpaceRegion` | 32 | Number of Sound Space Regions. |
| `TreeGridStack` | 512 | Tree grid stack memory. |
| `ParticleEmitter` | 512 | Particle Effect memory. |
| `ParticleEmitterInfoData` | 512 | Particle Effect memory. |
| `ParticleEmitterObject` | 2048 | Particle Effect memory. |
| `Asteroid` | 50 | Asteroid entity memory. |
| `FlagItem` | 2 | Flag entity memory. |
| `PowerupItem` | ? | Seems unused, count of PowerupItem entities. |
| `Timer` | ? | Seems unused, count of timers. |
| `RedOmniLight` | 200 | Omni Light memory? |
| `RedShadingState` | 64 | Shader memory? |
