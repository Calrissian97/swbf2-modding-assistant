# Hint Nodes
This document explains the purpose of hint nodes and each type.

Sections:
- HintNode Purpose and Types (lines 9-40)

---

# Purpose
Hintnodes act as positional suggestions for various AI behaviors, depending on the type of the node and node properties.

# Types
## Snipe Nodes
Only snipers will use these. They run to them, get into one of the selected Primary stances (`Stand`, `Crouch`), face the direction of the node, and remain there sniping enemies. After a minute or two they'll leave and do something else. They also have a mode property with possible values of `Attack`, `Defend`, `None`, and `Both`. The mode determines whether "Attacking" or "Defending" AI snipers will target this hintnode.

## Patrol Nodes
For defensive patrolling movement. AI units will travel between patrol nodes while the target CP is under friendly control. Patrol Nodes are now *deprecated*, replaced with Patrol Paths.

## Cover Nodes
These are the general combat nodes. You should place lots of them everywhere in the level, since AI will use these while in combat.
The direction should be set facing the 'covered' direction. So if the node is behind a barrel, the direction would point towards the barrel. This way they know that they should use that node if the enemy they are hiding from is on the other side of the barrel.
You should also set both primary and secondary stances. Primary stance is the 'covered' state, and is usually `Crouch`. Secondary stance is the 'attacking' state, and could be `Stand`, `Crouch`, `Left`, or `Right`. Selecting stand will make them stay put but stand up and shoot, while left or right make them take a step (2m) in that direction before firing.

## VehicleCover Nodes
These are similar to Cover nodes except they apply to AI units when fired upon by vehicles. All properties are the same as Cover nodes.

## Fortification Nodes
These are used by units while they are defending something, such as the flag in CTF gamemodes, or an object in Assualt gamemodes. As opposed to Cover hintnodes that AI flock to while in combat, AI units will remain at Fortification hintnodes and wait for attackers. All properties are the same as Cover and VehicleCover nodes.

## JetJump Nodes
Jet Jump nodes are used by all units, those with jetpacks/jedi-jump especially targeted. They will occasionally run to a node and jet jump in that direction. They get launched exactly in the direction that the node points, so the up/down is important as well. You should rotate the node to face the correct direction, then angle it upwards about 45 degrees. This is pretty close to what a player would do if they run and jet jump.

## Mine Nodes
Units with mines will drop them on these nodes (and sometimes detpacks due to a bug). One mine will be layed per node. A `Target` property can be set to a Command Post so that only the controlling team will lay mines at this node. Otherwise, any mine-laying unit will utilize the Mine hintnode.

## Land Nodes
Flyer vehicles will land on these nodes. Land Nodes are now *deprecated*. Similar behavior can be emulated through flyerspline entity-paths and lua scripting to force landing/exit upon entering a region placed where the flyer should land at the end of the flyerspline.

## Access Nodes
AI will stop by these nodes for a moment to appear they are accessing something. Unknown if placing these nodes next to interactable entities such as turrets will encourage them to pilot them.
