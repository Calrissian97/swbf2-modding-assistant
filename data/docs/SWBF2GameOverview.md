# SWBF2 2005
This document is a high-level overview of Star Wars Battlefront II (2005)

Sections:
- Game Overview (lines 9-54)

---

# Game Overview
At it's core each level consists of a minimum of two opposing teams each owning at least one command post from which their units spawn. In the Conquest gamemode each command post can be captured by the enemy if a unit enters a capture region linked to the command post and holds it's position for long enough. When a command post is captured the spawn path attached to it is taken over by the capturing team and it's units will spawn from that command post. When all of the command posts are owned by one team a Victory/Defeat timer starts, or a team runs out of reinforcements the game is over. Command posts are uncapturable in other gamemodes. In Capture The Flag gamemodes these command posts are uncapturable and the objective is to bring a flag item back to a team's home region. In Space Assault, the objective is to score points by destroying enemy capital ship systems and enemy fighters, to a score limit. In team deathmatch, the objective is to gain points by defeating enemies to reach a score limit first.
The game itself is made up of levels created with a level editor (zeroeditor) consisting of objects created with Softimage XSI/Blender and exported using a special add on that outputs a `.msh` file. The models are recognized by the editor by way of an Object Definition File, a text file that defines an entity and all of it's properties (`.odf`). The ODF files define the properties of objects not just for the game but also for the editor. Once a model is exported an ODF file must be manually created first before it can be used in the editor. 
The level editor is a terrain heightmap editor and object layout application that allows for generation and manipulation of a textured vertex heightmap as terrain as well as opening models exported from XSI/Blender. In addition to manipulation of objects and terrain the editor also has modes for creating unit spawn paths and vehicle spawns, AI paths and barriers, invisible capture, control, sound, and shadow regions, and map boundaries. Files saved by the editor are used by the munge compiler in a two step process to prepare assets for use in the game as an addon. Lua scripts are used to setup objectives, teams, custom scripting logic, and adjust world or class properties.

# Level Requirements
Each level requires some type of terrain or object on which to play, two command posts and two teams.

## Terrain
Each level must have a terrain or object on which the players can spawn. If a vertex map terrain is not created then models imported into the world can serve as the battle platform. Units can only be spawned from fixed positions or command vehicles, meaning units cannot spawn inside arbitrary objects so some type of fixed object is required.

## Teams
Each team on a level consists of 5 Unit Classes (max 9 + hero) and 1 Hero Class. The Hero Class units on a level are unlockable characters, either through points or timers. Each Unit Class is defined as a specific unit type and in-game count can be set manually while only one hero per team can be in play at a time. Hero units have their health deplete over time, with kills granting additional time.

## Command Posts
Command posts are buildings or objects that can be owned or captured by a team. Each command post is assigned a value to each team in a given mission. Enemy units attack command posts based on their value and proximity. AI will target the nearest command post first, and if more than one is an equal distance away the one of highest value will be targeted first. Each command post also has a Bleed Value, which is taken into account to determine the rate at which an opposing team's reinforcement count degrades throughout the mission. Command posts are typically attached to at least a Spawn Path, a Capture Region, and an optional Control Region for vehicle spawning.

## Spawn Paths
Spawn Paths are invisible objects from which units spawn into the game. Spawn Paths must be attached to command posts to function. Each spawn path has a unique name that is attached to the command post and an unlimited number of spawn nodes that acts as points from which units spawn. While a command post may exist in one place, the spawn points associated with it can be scattered across a map, though typically nearby.

## Capture Regions
A Capture Region is attached to a command post instance and acts as a zone that when occupied by an enemy unit triggers the capture of a command post. It is the center of the capture region that the AI units navigate to in order to capture a command post.

## Control Regions
Control Regions can also be attached to command posts. A control region is used to control whatever is within it when the command post it belongs to is owned by a particular team. The most common use for control regions is to act as zones where vehicles can be spawned and remain intact without decaying (losing health). Once a vehicle leaves a team’s control zone it is considered "in the field" and if abandoned will begin decaying. A Vehicle Spawn point must also be located within a control region in order to spawn vehicles.

## Barriers
Objects on a level are not recognized by the AI when it plans it’s course to an objective. Barriers are placed around objects the AI can collide with so they will plot a course around the object. Barriers act as invisible boxes that the AI recognize and calculate the area of in order to plot a course around objects. Each barrier also has a set of filters that determine what AI types can pass through them. AI cannot chart a course to a command post that is within a barrier filtering out that AI type.

## Planning Paths
Planning Paths are made up of Hubs and Connections forming a Connectivity Graph that defines routes taken by AI as they plot a course to objectives. When an AI unit plans a path to an command post it looks for the closest command post that is not owned by it's team and charts a course. By default, the AI will take the most direct course from it’s starting point, a straight line. When a connectivity graph is present the AI looks first for the nearest command post, then the nearest connectivity hub and sets whichever is closer as it's destination.

## Hint Nodes
To further control AI behavior, Hint Nodes can be used. Hint Nodes are hotspots with properties that designate AI behavior on those spots. These include Snipe, Jet Jump, Mine, Cover, VehicleCover, Fortification, and Access. These node types also have additional properties such as attack/defend, standing, or crouch. When an AI comes into proximity with a Hint Node they will occupy it and take the specified action if applicable. If after a certain amount of time the unit encounters no enemy units it will leave that node and plot a course to the nearest command post not owned by it's team. Gun turrets do not require hint nodes for AI to occupy them, technically the turrets are vehicles but are treated like Hint Nodes by the AI.

## Boundaries
Each map has at least one Boundary that when crossed triggers a countdown to death and a message that the unit is leaving the battlefield. Boundaries are required not just to define the playable area on a map but also to control the aesthetic appearance of the battlefield. If a unit moves too close to the edge of the map, the edge of the terrain or sky can usually become visible.

## Vehicle Spawns
A Vehicle Spawn is in an invisible object that when placed in the control region of a command post can spawn a vehicle for the team that owns the command post. Vehicle spawns can spawn different vehicles for each team and their role (Attacking or Defending) or no vehicles at all.

## Common Objects
There are numerous common objects in the game that provide functionality to maps. These include Weapon Recharge Droids, Health Recharge Droids, Vehicle Recharge Droids, and Turrets. These objects are not team or world specific.

## Add On Functionality
When the game is executed it looks for the AddOn folder and any folders beneath it. It looks at each folder in the AddOn folder to find an addme.script file and appends the in-game mission list with new map names one by one. Compiled addon maps may also make use of assets shipped with the game, so even though they are not beneath the add on folder, the maps require the intact assets of the shipped version of the game. Mod Templates have been provided as examples for reference as well as starting points. The Visual Munge application in the BF2_Modtools/data folder will generate template addon data folders depending on options given such as available eras, modes, and whether it is a space level or world level. These templates can then be immediately munged and played in the game.
