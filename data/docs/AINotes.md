# AI Behaviors
This document explains various AI-related systems.

Sections:
- AI Visibility (lines 14-59)
- AI Snipers (lines 61-67)
- Command Post Behavior (lines 69-70)
- AI Planning Types (lines 72-75)
- AI UnitType Behaviors (lines 77-89)
- AI Weapon Firing (lines 91-98)

---

# AI Visibility
There are three factors that simultaneously affect AI visibility: Lua * Foliage * Region.

## LUA AI Visibility
You can set the overall view distance in the level lua: `SetAIViewMultiplier(0.45)`
This example means that over the entire level, AI can see 45% as far as normal. Related, `AISnipeSuitabilityDist(distance)` sets range AI snipers will consider sniping.

## Foliage AI Visibility
You can set visibility modifiers on foliage, which, for example, allows you to hide inside bushes on Endor. `.prp` files define this like so:
```
Layer(1)
{
    SpreadFactor(0.5);
    Mesh()
    {
        File("end_prop_fern5.msh", 30);
        Frequency(20);
        Scale(1);
        Stiffness(0.0);
        CollisionSound("foliage_collision");
        AIVisibilityFactor(0.7,1.0); // This line here!
    }
    Mesh()
    {
        File("end_prop_treeclump_1.msh", 50);
        Frequency(50);
        Scale(1);
        Stiffness(0.0);
        CollisionSound("foliage_collision");
        AIVisibilityFactor(0.35,0.6); // This line here also!
    }
}
```
You can adjust the visibility per foliage model, with values for crouching and standing.
The first means that for the foliage model "end_prop_fern5", you will be 70% visible from AI if you're crouched inside it, but 100% visible if standing inside it. 
The second model ("end_prop_treeclump_1") will give you 35% visibility when crouched, and 60% when standing.

## Region AI Visibility
AI Visibility Regions allow you to set regions in zeroeditor that affect the AI's visibility of anything inside that region. 
Vis Regions work on both player HUD elements and AI, but not so well on vehicles.
To make them in the editor, create a new region and hit the "Change Type" button to select the type "AIVis". Then set the vis multipliers for `crouch=<float>` and `stand=<float>`.
These are a multiplier on normal visibility, so 0.5 means that you're 50% covered, while 2.0 would mean that you're visible twice as far away as normal.
You can only be inside one vis region at a time, so if the regions overlap, it will randomly pick one of them and use that value.

# AI Vehicle Notify Radius
You can set how far AI units will go to get into a vehicle in the mission script via `SetAIVehicleNotifyRadius(radius)`. The default is 50 meters.

# AI Snipers
Here’s a brief description on how to make the AI defenders stay in defensive positions.  
- Place snipe hints at the defensive positions. Make sure the direction of the hint faces the forward-facing direction for the defender.
- Set the mode of the hint to "Defend".
- In the lua script, add the following: `SetDefenderSnipeRange(170)`
This range value determines how far from their CP they will go searching for defensive hintnodes.
Some selected AI snipers will now stay at the snipe hintnodes while the CP is under their team's control.

# CP Behavior
When a command post is taken, any nearby units (within 60m) from the original owning team will try to immediately reacquire it. Otherwise, AI will prioritize nearby neutral or enemy CPs, weighted by CP-specific properties such as `Value_...` properties. CPs can also have properties such as AISpawnWeight that can alter the weight for AI unit spawn-selection from team-controlled CPs.

# AI Planning Types
I've added a new parameter to the ODFs called AISizeType.  This is basically the size category that the soldier/vehicle will use when referencing the connectivity graph and new barrier system.  Example: `AISizeType = "SOLDIER"`
Your choices for this are `SOLDIER`, `HOVER`, `SMALL`, `MEDIUM`, and `HUGE`, which are the same flags that are set in the editor when creating the barriers or the path planning graph.
If there isn't a tag in the ODF file , it defaults to `SOLDIER`.

# AI Behaviors
Soldier classes have an ODF property `UnitType` which determines certain AI behaviors.

| UnitType | Description |
| :--- | :--- |
| Trooper | Trooper units prioritize objectives, aggressively engaging in combat when enemies are encountered. |
| Assault | Assault units prioritize targeting enemy vehicles with their rocket launcher, switching to their secondary weapon when engaging with enemy units and holding their ground. Potentially more likely to use Cover/VehicleCover hintnodes. |
| Anti-Armor | Synonymous with Assault. |
| Scout | Scout units prioritize targeting enemy units from a distance. They are the only UnitType that will use Snipe hintnodes, and will prefer using their longer-range weapon at a distance. If an enemy combatant attacks them up close, they will switch to their secondary weapon, engage in serpentine movement, and reverse direction until they are at a suitable range for sniping.
| Pilot | Pilot units prioritize targeting friendly units to dispense ammo/health pickups for them, and repairing entities such as friendly vehicles or neutral turrets/buildings. They are the only UnitType that will heal vehicles over time when piloted. They will also target enemy vehicles with their fusion cutter to slice/disable them. |
| Support | Synonymous with Pilot, but will not heal vehicles over time when piloted. |
| Repair | Synonymous with Support. |
| Special | Special units balance objectives with support roles. They will seek out friendly units to dispense health/ammo pickups for them if they have a dispenser weapon equipped. They will also seek out friendly vehicles or neutral turrets/buildings to repair if they have a fusion cutter weapon equipped, or slice/disable enemy vehicles when engaged. |

# AI Weapon Firing
Weapon classes have properties that determine how AI units will fire them.
| Property | Description |
| :--- | :--- |
| BarrageMin | Integer value corresponding to the minimum amount of shots the AI will take with this weapon in a single barrage. |
| BarrageMax | Integer value corresponding to the maximum amount of shots the AI will take with this weapon in a single barrage. |
| BarrageDelay | Float value corresponding to the delay in seconds between each barrage. |
| AutoFire | If "1", AI will fire the weapon regardless of the presence of enemy entities. If "0", the AI unit will only fire the weapon when targeting an enemy. |
