# Paths
This document explains how paths work in Star Wars Battlefront 2. The game uses Catmull-Rom spline paths for unit-spawning, entity-spawning, boundary definitions, AI unit patrolling, and entity-following.

Sections:
 - Spawn Paths (lines 14-31)
 - Boundary Paths (lines 33-34)
 - Patrol Paths (lines 36-44)
 - Entity Paths (lines 46-103)
 - Squadron Paths (lines 105-106)
 - Formation Paths (lines 108-119)

 ---

# Spawn Paths
Spawn paths can be simply placed and referenced by name for entity spawning. No path or node properties are required.

## Unit Spawn Paths
In the Command Post Instance Properties, simply supply the path name to the SpawnPath field to associate unit-spawning with that path.

## Prop Spawn Paths
The world's foliage `.prp` file can define a set of props to spawn along a path. The path is referenced, distance between spawned props defined, and an odf file for the prop. For example:
```
TreeLine()
{
	Path("jungle")
	{
		Distance(28);
		BorderOdf("kas_prop_treebill.odf");
	}
}
```

# Boundary Paths
Boundary paths are placed and sized in **ZeroEditor** to define the playable bounds of a level.

# Patrol Paths
Patrol Paths are spline paths that AI units will "patrol" while the associated CP is under friendly control. These replace Patrol Hintnodes, and have the following properties:

- Path Properties: `type = PatrolPath`
- Node Properties: `WaitMin = <float>` and `WaitMax = <float>`

The `type` property of the path is required for the game to recognize the path as a PatrolPath.
The `WaitMin` node property sets the minimum time an AI unit should remain at the node during patrolling.
The `WaitMax` node property sets the maximum time an AI unit should remain at the node during patrolling.

# Entity Paths
Paths for entities to follow are created using the **Path Tool** in ZeroEditor. EntityPaths are instanced for each path that begins with the string `entitypath `.

These paths must be named in the following format:
`"entitypath {pathname}"`

For example:
`"entitypath xwingstrafingrun"`

Paths and nodes (points) on a path can have properties associated with them to control how an entity traverses the path and which entities are permitted to follow it.

## EntityPath Properties

*   **`Class`**: String ID which relates to the entity ODF's `PathFollowerClass` property. An entity will only follow a path if:
    *   The `PathFollowerClass` property of the entity isn't set.
    *   The `Class` property of the path isn't set.
    *   The `Class` property of the path matches the `PathFollowerClass` property of the entity.
    *   *Note:* Up to 5 class properties can be set (e.g., `Class1`, `Class2`). You can specify the maximum number of instances by following the ID with a value: `Class("xwing 3")`.

*   **`MaxEntities`**: Sets the maximum number of instances of any class which can follow the path simultaneously. This overrides values specified in individual `Class` properties.

*   **`MaxSquadronSize`**: Sets the maximum size of a squadron of entities following the path.

*   **`PathRoll`**: When set to `1.0`, the entity ignores ODF roll properties and rolls based on the rotation values of each node in the path. When `0.0`, roll is determined by the entity ODF.

*   **`Speed`**: Multiplier for the entity's default speed. A factor of `1.0` is default; `0.5` is half speed. Final speed = `Entity Default Speed * Entity PathFollowerSpeed * Path Speed`.

*   **`VarianceX` / `VarianceY` / `VarianceZ`**: Varies the position of all nodes on the path along the specified world axis. Defaults to `0.0`.

*   **`BranchDifferent`**: If `1.0`, the entity will always branch to a different path. If `0.0`, it may select the same path again. Defaults to `1.0`.

*   **`SingleDirection`**: If `1.0`, once an entity starts following a path, all subsequent entities must follow in the same direction until the path is empty. Defaults to `0.0`.

*   **`Direction`**: Forces entities to follow the path in a specific direction: `1.0` (forwards), `-1.0` (backwards), or `0.0` (any). Defaults to `0.0`.

*   **`Frequency`**: A multiplier [0..1] on the path's "score" when an entity is choosing a new path. Higher values increase the likelihood of selection. Defaults to `1.0`.

*   **`EnableObject`**: If set to the name of a destructible object, the path is only enabled while that object is alive.

*   **`Name`**: Overrides the path name. Useful for calling multiple paths by the same name to enable them simultaneously via `EnableFlyerPath()`.

## EntityPath Node Properties

*   **`BranchProbability`**: The likelihood [0..1] of an entity branching to another path from this node. `0.0` means never branch unless at the end; `1.0` means always branch.

*   **`Range`**: The search radius (in world units) for finding a new path to branch to. If no paths are found in range, the most suitable one (closest distance/orientation) is chosen.

*   **`BranchRegion`**: Specifies a spherical `entitypathbranch` region to branch to. Overrides `Range`.

*   **`MaxAngle`**: Maximum allowed difference (in degrees, 0..180) between the entity's current angle and the candidate path's start angle. Defaults to `180`.

*   **`BranchPaths`**: The number of "most suitable" paths to randomly select between when branching. Defaults to `0`.

*   **`Speed`**: Controls entity speed when approaching the node. Multiplied by path, entity, and default speed values.

*   **`VarianceX` / `VarianceY` / `VarianceZ`**: Varies the node position along the path's local axes. Defaults to `0.0`.

*   **`LandOnArrival`**: (Deprecated) `1` or `0`. Determines if a flyer should attempt to land upon reaching this node. *Note:* Must be set on the second-to-last node to trigger landing at the end of a path.

# Squadron Paths
Entities can group together into formations defined by formation paths. Every 10–20 seconds, entities check for nearby allies (within 10x diameter, facing within 60 degrees) to form a squadron. EntityPaths are SquadronPaths unless the MaxSquadronSize property is set to 0.

# Formation Paths
Each point in the path represents a slot in the formation, unless the node has the `Root` property.

## FormationPath Properties

*   **`RootIsSlot`**: Set to `1.0` if the root node is a valid position within the formation. Set to `0.0` if it is only a reference point.

## FormationPath Node Properties

*   **`Root`**: Assign to a node to set it as the formation root. If not set, the first node is default. If multiple nodes are set, the last one in the list becomes the root.

*   **`MemberID`**: Restricts a slot to a specific member ID. If not set, the slot is open to any entity in the squadron.
