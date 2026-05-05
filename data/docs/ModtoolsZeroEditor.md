# Level Editing with ZeroEditor
This document explains the core interface, controls, and editing systems of **ZeroEditor**, the level editor used for Star Wars Battlefront 2. It focuses on how the editor loads assets, how its toolbars function, and how layers and edit modes are organized.

Sections:
 - Launching and Interface (lines 24-47)
 - Editor Toolbars and File Management (lines 49-70)
 - Viewing and Mode Controls (lines 72-109)
 - Active Layer System (lines 111-146)
 - Advanced Tools and Visibility (lines 148-173)
 - Input and Shortcut Reference (lines 175-267)
 - Terrain Editing Modes (lines 269-461)
 - Foliage Editing (lines 463-531)
 - Object Placement and Properties (lines 533-566)
 - Paths and Regions (lines 568-624)
 - AI Hint Nodes (lines 626-660)
 - AI Barriers (lines 662-705)
 - Path Planning and Connectivity (lines 707-792)
 - Boundary Edit Mode (lines 794-805)
 - Layers for Game Modes (lines 807-914)
 - Procedural Animation (lines 916-1094)

---

# 1. Launching ZeroEditor
ZeroEditor builds an **index of all files** located beneath its directory every time it starts.

- Each `datamod#` folder and template includes its own copy of ZeroEditor and its config files.
- This prevents crashes caused by unsupported files and improves startup speed.
- ZeroEditor references files through its internal index rather than reading paths in real time.

To launch:
- Double‑click the ZeroEditor executable.
- No world is loaded by default.
- The LucasArts license agreement appears on startup.

> Note that an error may appear when starting the application for the first time, this may be safely ignored.

# 2. ZeroEditor Interface Overview
ZeroEditor contains **five global toolbars**:

1. **FILE**
2. **EDIT**
3. **SHOW**
4. **EDIT MODE**
5. **ACTIVE LAYER**

Each toolbar controls a major part of the editor’s workflow.

# 3. File Control
The File toolbar contains:

- **Load World**  
- **Save World**

Worlds use the `.wld` extension, but saving a world also writes multiple supporting files:

- Mode‑specific files  
- Layer index files  
- Terrain files  
- Other editor‑generated metadata  

Worlds are stored in the `world` folder, while assets used by edit modes (e.g., meshes, ODFs) live in the `MSH` and `ODF` directories.

# 4. Edit Control
The Edit toolbar provides:

- **Undo** (Ctrl+Z)  
- **Redo** (Ctrl+Y)

These functions do not work in all modes or for all object types.

# 5. Viewing Controls
## "Show" Controls
The Show toolbar toggles visibility of editor elements **regardless of active mode**.

Example:
- Paths and Regions are normally invisible in Object mode.
- Enabling them allows you to see their placement without switching modes.

This is especially useful on dense maps with many objects or foliage.

## Terrain View Controls
These affect how the **vertex map** is displayed:

- **SOLID** — Shows terrain with textures and sky lighting.
- **WIRE** — Shows a gray wireframe.
- **SOLID + WIRE** — Solid terrain with a green wireframe overlay.
- **HEIGHT** — Displays terrain as a heightmap.
- **COLOR** — Displays vertex colors from Color Mode.

# 6. Edit Mode Control
ZeroEditor includes **12 edit modes**, each toggled from the Edit Mode toolbar:

| Mode       | Purpose |
|------------|---------|
| HEIGHT     | Edit terrain heightmap |
| COLOR      | Paint vertex colors |
| TEXTURE    | Apply terrain textures |
| WATER      | Add/edit water tiles |
| FOLIAGE    | Paint or erase foliage |
| OBJECT     | Place and edit objects |
| PATH       | Create/edit unit spawn paths |
| REGIONS    | Create/edit region volumes |
| HINTNODE   | Add/edit AI hint nodes |
| BARRIER    | Add/edit AI barriers |
| PLANNING   | Edit AI path planning graph |
| BOUNDARY   | Edit map boundaries |

Each mode exposes its own toolset and properties panel.

# 7. Active Layer System
ZeroEdit’s layer system was originally designed for **multi‑user collaboration**, where each developer worked in their own layer (similar to branches).

A layer contains the same set of files as the base layer, but isolated.

## Creating a Layer
1. Click **CHANGE**.
2. Click **NEW** in the popup.
3. Rename the layer.

## Evolution of Layer Usage
As ZeroEditor grew more complex, layers shifted from "one per person" to **functional grouping**:

Common examples:

- **Design Layer**  
  - Objects  
  - Paths  
  - Capture/Control regions  
  - Boundaries  
  - Path planning

- **Shadow Regions Layer**

- **SoundSpaces / SoundRegions Layer**

- **Trees Layer**

- **Buildings Layer**

This reduces clutter and improves workflow on crowded maps.

## Layer Flexibility
- Objects can be moved between layers.
- Layers can be deleted.
- The base layer is typically unused in modern workflows.

# 8. Advanced Controls
The **Advanced** toolbar provides tools for terrain creation, camera settings, image export, and terrain shadow baking.

## TERRAIN
- Creates a new terrain file for the world.

## CAMERA
- Adjusts **Fog Range** and **Sky Visibility** (editor‑only visual settings).
- Includes a button to snap the camera to a **top‑down satellite view**.

## IMAGE
Provides tools for exporting terrain images:
- **HEIGHTMAP** — saves a grayscale heightmap.
- **HIRESMAP** — saves a high‑resolution terrain image for map creation.
- **BURN TERRAIN** — uses the heightmap to bake shadows directly into the terrain texture.

# 9. Visibility Controls
The visibility bar adjusts how far the editor renders objects and terrain.

- Visibility increases in **500‑meter increments** (500–5000m).
- High visibility in **SOLID** mode can cause severe slowdown or crashes.
- **WIRE** mode is much lighter since terrain textures are not rendered.

Recommended workflow:
- Start with low visibility.
- Increase only when necessary.

# 10. ZeroEditor Keyboard & Mouse Commands
## 10.1 Global Commands

| Command | Action |
|--------|--------|
| **Ctrl + S** | Save |
| **Ctrl + L** | Load |
| **Ctrl + Z** | Undo |
| **TAB** | Toggle between Mouselook and Edit |

## 10.2 Camera Rotation (Arrow Keys)
| Key | Action |
|-----|--------|
| Arrow Up | Rotate view up |
| Arrow Down | Rotate view down |
| Arrow Left | Turn view left |
| Arrow Right | Turn view right |

## 10.3 Camera Movement (Numpad)
| Key | Action |
|-----|--------|
| Numpad 8 | Move forward |
| Numpad 2 | Move back |
| Numpad 4 | Move left |
| Numpad 6 | Move right |
| Numpad 7 (Home) | Move left + forward |
| Numpad 9 (PgUp) | Move right + forward |
| Numpad 1 (End) | Move left + back |
| Numpad 3 | Move right + back |

## 10.4 Movement Speed
| Key | Action |
|-----|--------|
| `,` ( < ) | Slow movement |
| `.` ( > ) | Speed up movement |

# 11. Mouselook Mode
When **Mouselook is ON**:
- Cursor disappears.
- You cannot select objects.
- Used for free camera navigation.

## Controls (Mouselook ON)
| Input | Action |
|--------|--------|
| Alt + I | Invert vertical look |
| Mouse Forward | Look up |
| Mouse Back | Look down |
| Mouse Left | Turn left |
| Mouse Right | Turn right |
| W | Move forward |
| S | Move back |
| A | Strafe left |
| D | Strafe right |
| F | Move up |
| V | Move down |

# 12. Edit Mode Cursor Controls (Mouselook OFF)
When **Mouselook is OFF**:
- Cursor is visible.
- You can select and manipulate objects.

## Cursor Movement
| Input | Action |
|--------|--------|
| Left Click | Select or place |
| Right Click | Deselect |
| Mouse Forward | Move cursor/item forward |
| Mouse Back | Move cursor/item back |
| Mouse Left | Move cursor/item left |
| Mouse Right | Move cursor/item right |
| F | Move item up |
| V | Move item down |

# 13. Object Manipulation Shortcuts
## 13.1 In OBJECT Mode
| Input | Action |
|--------|--------|
| Left Mouse Button | Manipulate X axis |
| Right Mouse Button | Manipulate Y axis |
| Middle Mouse Button | Manipulate Z axis |
| C + L/R/M Button | Translate (move) |
| X + L/R/M Button | Rotate around object center |
| Z + L/R/M Button | Rotate around object root |

# 14. Region & Barrier Manipulation Shortcuts
When in **REGION** or **BARRIER** mode:

| Input | Action |
|--------|--------|
| C + L/R/M Button | Scale on X axis |
| X + L/R/M Button | Scale on Y axis |
| Z + L/R/M Button | Scale on Y axis (as documented) |

# 15. Edit Modes
ZeroEditor provides multiple edit modes for modifying terrain, colors, textures, water, and more. Each mode exposes its own toolset and properties panel.

# 16. Height Mode
Height Mode edits the **vertex heightmap** of the terrain using a brush system. Instead of painting colors, the brush applies **foreground** and **background** height values.

## Height Brush Controls
- **MODE**
- **SIZE**
- **SHAPE**
- **ROTATION**
- **PRESSURE**
- **TERRAIN HEIGHT** tools

## 16.1 Height Brush Modes
| Mode | Description |
|------|-------------|
| **PAINT** | Default mode; applies height uniformly under the brush. |
| **SPRAY** | Applies height changes randomly, similar to a spray can. |
| **RAISE** | Raises (LMB) or lowers (RMB) terrain continuously while held. |
| **BLEND** | Smooths between foreground and background heights, useful for natural slopes. |

## 16.2 Brush Size
Controls the width and depth of the brush.  
Values can be typed manually or adjusted with sliders.

## 16.3 Brush Shape

| Shape | Description |
|--------|-------------|
| **SQUARE** | Hard‑edged square brush. |
| **CIRCLE** | Hard‑edged circle; small circles may appear square due to 8m grid. |
| **CONE** | Creates a cone‑shaped gradient between foreground and background heights. |
| **BELL** | Similar to CONE but produces a bell‑shaped gradient. |
| **RAMP** | Creates a rectangular ramp between foreground and background heights. |

## 16.4 Rotation & Pressure
- **ROTATION** — Brush rotation in degrees.  
- **PRESSURE** — Strength of height application (default: 20%).  
  - Higher pressure is useful in **RAISE** mode.

## 16.5 Terrain Height Tools
These tools manage height sampling, copying, and pasting.

### Foreground & Background Heights
- Two height values are always stored:
  - **Foreground** (left mouse button)
  - **Background** (right mouse button)

### PICK
- Samples height from terrain vertices.
- Cannot pick height from objects.

### MARQUEE
- Selects a rectangular area of terrain.
- Copy with **Ctrl+C**.
- The copied terrain preview follows the cursor until placed.
- Can be pasted repeatedly.
- Right‑click cancels selection.

### Manual Height Entry
- Foreground/background values can be typed manually.
- Consider world scale:
  - Default terrain: **256 × 256 meters**, **8m grid**
  - Max/min heights are defined in the mission LUA.

# 17. Color Mode
Color Mode paints **vertex colors** on the terrain.  
It also exposes ambient color controls (editor‑only; sky files must be edited manually).

To view vertex colors clearly, enable **COLOR** in the Terrain View panel.

## 17.1 Paint Brush Controls
- **MODE**
- **SIZE**
- **SHAPE**
- **PRESSURE**
- **FOREGROUND/BACKGROUND colors**

### Modes
| Mode | Description |
|------|-------------|
| **PAINT** | Applies color uniformly. |
| **SPRAY** | Randomized spray‑can effect. |
| **PICK** | Eyedropper tool for sampling terrain color. |
| **BLEND** | Smoothly blends between colors. |

### Size
- Brush size in grid units (8 meters per grid).

### Shape
Same shapes as Height Mode:
- SQUARE  
- CIRCLE  
- CONE  
- BELL  

### Pressure
- Controls color intensity (default: 20%).

### Foreground & Background Colors
- Displayed as RGB values.
- Can be manually edited.

## 17.2 Color Fill
- Fills the entire vertex map with the **foreground** color.

## 17.3 Color Table
Located at the bottom of the screen.

Includes:
- Default palette
- Foreground/background selectors
- **LOAD** button for custom `.ACT` palettes
- Ambient color controls:
  - **SKY**
  - **FOG**
  - **AMBIENT**

Ambient colors affect object lighting in the editor and serve as references for sky file editing.

Values can be set using **RGB** or **HSV**.

# 18. Texture Edit Mode
Texture Mode applies terrain textures to the vertex grid.

Brush controls are similar to Height and Color modes, except:

- **RAISE** — Brings out a texture layer beneath another.
- **BLEND** — Blends visibility between adjacent textures.

## SOLO TEXTURE
- Displays only the selected texture for clarity.

## Foreground/Background
- Represent **alpha values** rather than colors.

## 18.1 Texture & Detail Fields
- **TEXTURE** — Name of the texture to apply.
- **DETAIL** — Name of the detailed version of the texture.
- **SHOW DETAIL** — Toggles detailed texture view.

## 18.2 Tile Controls
The tile panel displays available textures.

- Selecting a tile updates the **TEXTURE** field.
- Every world must have **at least one terrain texture**.

### TILERANGE / TILEROTATION
- Control how textures are applied to sloped or vertical surfaces.
- Useful for cliffs and hillsides.

### RAISE / LOWER
- Adjust the selected tile’s position in the texture layer stack.
- Stacking more than ~4 layers causes visual artifacts.

# 19. Water Edit Mode
Water Mode applies water tiles to the terrain.

### Water Tile Basics
- Each tile is **4 × 4 terrain grids** (24m × 24m minimum).
- Up to **15 layers** per tile.
- Each layer may have:
  - Its own texture
  - Alpha value
  - Color value

Not all water controls are used in practice.

## 19.1 Brush Size
- **WIDTH** and **HEIGHT** define brush size.
- Brush is always square.
- **1 unit = 4 terrain grid tiles**.

### LAYER
- Selects which water layer is being edited.

### HEIGHT
- Not used.

## 19.2 Water Animation Controls
| Control | Purpose |
|---------|---------|
| **UVel** | Horizontal animation speed |
| **VVel** | Vertical animation speed |
| **URepeat** | Horizontal texture repetition |
| **VRepeat** | Vertical texture repetition |

## 19.3 Texture, Color, Alpha
- **TEXTURE** — Texture name for the selected water layer.
- **COLOR** — Background color for transparent areas.
- **ALPHA** — Transparency of the layer.
- **GLOW** — Not used.

# 20. Foliage Edit Mode
Foliage is defined in a PRP file and painted onto the terrain using the Foliage Brush tools. Up to four foliage layers are supported. Brush controls include SIZE and SHAPE, since foliage placement is intentionally irregular. FILL WORLD and ERASE WORLD apply or remove foliage across the entire map.
Some foliage appears as simple white disks in the editor to reduce render cost, while others are fully rendered. This is determined per asset.

## 20.1 Foliage PRP Structure
Foliage definitions are stored in .prp files. Examples:
```
Layer(0)
{
    SpreadFactor(0.1);
    Mesh()
    {
        GrassPatch("nab_prop_grass.odf", 50);
        File("editor_grasspatch.msh", 50);
        Frequency(100);
        Scale(1);
        Stiffness(0.0);
    }
}

Layer(1)
{
    SpreadFactor(0.4);
    Mesh()
    {
        File("end_prop_fern5.msh", 30);
        Frequency(20);
        Scale(1);
        Stiffness(0.0);
        CollisionSound("foliage_collision");
        ColorVariation(0.2); AIVisibilityFactor(0.7,1.0); // AI visibility when crouching, standing
    }

    Mesh()
    {
        File("end_prop_treeclump_1.msh", 50);
        Frequency(80);
        Scale(1);
        Stiffness(0.0);
        CollisionSound("foliage_collision");
        ColorVariation(0.2);
    }
}
```

## 20.2 Foliage Property Definitions
SpreadFactor controls density; lower values produce denser foliage.  
The number after a File(...) entry defines the fade in/out distance in meters.  
Frequency determines the percentage of the layer represented by that mesh.  
Scale adjusts object size.  
Stiffness controls how much foliage tilts with terrain (0 = flexible, higher = upright).  
CollisionSound defines a sound played when units collide with the foliage.  
ColorVariation introduces random color differences for natural variation.

## 20.3 Path-Based Foliage (Billboard Bushes)
Some foliage is created using PATH EDIT MODE rather than Foliage Mode. These are known as Hell Bushes: objects placed along a path at fixed intervals.

Example:
```
TreeLine()
{
    Path("jungle1")
    {
        Distance(28);
        BorderOdf("end_prop_treebill.odf");
    }
}
```
Distance controls spacing between objects. This technique is used for dense perimeter foliage such as the jungle borders on Yavin 1.

# 21. Object Edit Mode
Object Mode imports and configures objects defined in ODF files. Once an object’s ODF is placed in the world’s ODF directory, it becomes available in ZeroEditor. Objects are placed using ACTION MODE: PLACE and can then be moved or manipulated.

## 21.1 Action Modes
- SELECT: Select existing objects.  
- PLACE: Place new objects; repeated clicks duplicate the object.  
- MULTI SELECT: Select multiple objects simultaneously.

# 22. Snap To
- SNAP TO provides toggles for snapping movement to grid squares and snapping rotation to fixed degree increments. - RESET ROTATION restores the object’s default orientation.

# 23. Alignment Tools
Alignment tools work with keyboard controls to align objects using world or object geometry.
USE ROOT and USE ORIGIN determine the pivot point for rotation.
- GROUND TO TERRAIN snaps the object to terrain height.  
- GROUND TO OBJECT snaps the selected object to the surface of another object.
> Grounding uses the object’s geometry and origin, so adjustments may be needed to prevent floating or clipping.

# 24. Selectability
- HIDE makes an object invisible in the editor.  
- ACTIVE disables selection of the object.  
> Inactive objects must be selected through the Object Browser.

# 25. Object Properties
- HEIGHT sets the object’s elevation in meters; LOCK prevents height changes.  
- ODF FILE displays the object’s ODF filename.  
- NAME is the editor-only display name.  
- LABEL is the localization key used for translated in-game names.  
- TEAM applies to team-specific objects such as command posts.  
- TOGGLE BROWSER shows or hides the Object Browser panel.

# 26. Object Instance Properties
Instance properties override default ODF settings for individual objects. COPY TO and COPY FROM allow transferring instance settings between objects. PGUP and PGDN scroll through long property lists.
These overrides are saved in the world file and take precedence over common ODF defaults.

# 27. Path Edit Mode
Path Edit Mode is used to create UNIT SPAWN paths. A spawn path is a sequence of SPAWN nodes, each containing directional axes that determine the facing direction of units when they spawn. Path names can be referenced in object instance properties, such as those for command posts.

Path nodes:
- Snap to terrain by default.
- Can be rotated using standard keyboard and mouse controls.
- Can have their heights adjusted or locked using LOCK HEIGHTS or by holding Shift.

## 27.1 New Path
Selecting NEW PATH generates a new path name and switches the mode to ADD NODE.  
Each click on the terrain places a new node in the path.

## 27.2 Move
Right‑clicking a path allows the entire path to be moved on the XZ axes.
Individual nodes can be selected with the left mouse button and moved independently.

## 27.3 Tape Measure
Path Edit Mode includes a tape measure tool for measuring distances in meters.

# 28. Regions Edit Mode
Regions define gameplay and environmental behaviors. Common region types include:

- Capture Regions  
- Control Regions  
- SoundStream Regions  
- SoundTrigger Regions  
- SoundSpace Regions  
- Shadow Regions  
- Death Regions  
- Rain / No Rain Regions  

RegionID is used only within the editor, or when referencing a region via lua scripting.
The Properties field defines the region’s in‑game behavior.

Examples:

- SoundStream regions require properties beginning with SoundStream, followed by a SoundStreamProperty name and a number. The number represents a rolloff point (1 / number = meters before rolloff begins).
- SoundTrigger regions play a sound when entered (e.g., "Transport One is Away" on Hoth).
- SoundSpace regions define reverb and occlusion.
- Shadow regions block sunlight and ambient light.
- Death regions kill units that enter them.
- Rain blockers prevent rain from appearing indoors (e.g., Kamino).

## 28.1 Region Actions
To create a region:
1. Select NEW REGION in ACTION mode.
2. Click the terrain to place it.

Regions can be selected in SELECT mode to adjust properties.

Region shapes:
- BOX  
- SPHERE  
- CYLINDER  

Some region types require specific shapes to function correctly.
Regions can be snapped to grid tiles using SNAP TO.

# 29. Hint Node Edit Mode
Hint Nodes are AI behavior hotspots. When an AI unit enters the node’s influence area, it performs the specified behavior. Hint nodes should be used sparingly for optimal performance.
Hint nodes include visual indicators showing the hotspot and required facing direction.

## 29.1 New Node
Selecting NEW NODE allows placement of a new hint node with each mouse click.

## 29.2 Move
Nodes can be selected in MOVE mode and adjusted as needed.

## 29.3 Node Types
Node types define AI behavior:

- SNIPE: Used by marksmen.
- PATROL: Causes units to linger and change position.
- COVER: AI takes cover behind the object the node is placed near when fired upon by a unit.
- VEHICLECOVER: AI takes cover behind the object the node is placed near when fired upon by a vehicle.
- ACCESS: AI stands at an object (e.g., control panel) as if interacting with it.
- JETJUMP: Controls jet trooper jumps to higher areas (e.g., Endor huts).
- MINE: AI places mines at the node.
- LAND: Used by carriers for landing and deploying troops (Deprecated in SWBF2).

Some nodes support primary and secondary stances:
- Stand  
- Crouch  
- Prone  
- Face left or right  

## 29.4 Name
Nodes can be named purely for organizational convenience.

## 29.5 Toggle Height
Controls the ghosted height indicators used to visualize node height.  
These indicators can be adjusted for visibility and transparency.  
The same system applies to other edit modes.

# 30. Barrier Edit Mode
Barriers are invisible volumes used by AI to navigate around obstacles.  
Each barrier includes filters determining which AI types can pass through it.
AI cannot path to a command post located inside a barrier that bans their type.

## 30.1 Creating Barriers
To create a barrier:
1. Select NEW in the EDIT BARRIER ACTION panel.
2. Click the terrain to place the first corner.
3. Move the mouse to size the rectangle.
4. Click again to anchor the second point.
5. Click a third time to finalize the shape.

- SRETCH mode allows for moving a single edge of a barrier.
- MOVE mode moves the entire barrier.  
> Holding Shift while moving snaps the barrier’s corner to the nearest corner of an adjacent barrier.

## 30.2 Rotate
In ROTATE mode, clicking a barrier sets the nearest corner as the rotation anchor, allowing for rotating.

# 31. Barrier Filters
BAN controls define which AI types are blocked:

- Soldier  
- Hover  
- Small  
- Medium  
- Huge  
- Flyer  

These correspond to ClassLabels in unit or vehicle ODF files.
Flyers require larger barriers because they move faster and need more distance to adjust course.

# 32. Barrier Height Controls
TOGGLE HEIGHT shows or hides the barrier’s height shading.  
Barriers have infinite height in-game; the shading is only a visual aid.

HEIGHT and ALPHA adjust:
- The displayed height of the shaded region  
- The transparency of the shading  

# 33. Barrier List
Barrier names are editor‑only and arbitrary.  
Default names are typically used.

# 34. Path Planning and Connectivity Graphs
Planning Paths consist of **Hubs** and **Connections**, forming a Connectivity Graph that defines the routes AI units take when navigating toward command posts. Without a graph, AI attempts to move in a straight line toward the nearest enemy command post. With a graph, AI evaluates both the nearest command post and the nearest hub, choosing whichever is closer as its immediate destination.

PLANNING Mode allows the creation of invisible hubs and connections that define valid movement corridors for AI NPCs.

# 35. AI NPC Movement
AI NPCs move **from Hub to Hub** using Connections. The movement process:

1. The AI identifies the **nearest Hub** connected to a path leading toward the final destination Hub.
2. This becomes the **Primary Destination Hub**.
3. The AI moves toward secondary waypoints along the Connection.
4. Upon reaching the Primary Destination Hub, the AI recalculates the shortest path to the Final Destination Hub.
5. A new Primary Destination Hub is selected.
6. The process repeats until the AI reaches the Final Destination Hub.

Filters can remove hubs or connections from consideration.  
Weights can make certain connections less desirable, influencing AI path selection.

# 36. Hubs
Hubs are circular areas that act as primary and secondary destinations for AI. A hub cannot exist alone; at least two hubs are required for a functional graph.

## 36.1 Creating Hubs
- Select **NEW HUB** in Planning Mode.
- Click once to begin sizing the hub.
- Move the mouse to adjust diameter.
- Click again to finalize size and place the hub.

Hubs can be renamed, though defaults are typically used.

## 36.2 Editing and Deleting Hubs

- **EDIT/MOVE HUB**: Click and drag to reposition.
- **Radius**: Adjust size of the hub.
- **Delete**: Select the hub and press the Delete key.

# 37. Connections
Connections define the paths between hubs and act as corridors for AI movement.

## 37.1 Creating Connections
- Select **NEW CONNECTION**.
- Click a hub to begin.
- A rectangular connection will follow the cursor, snapping to hubs when near.
- Click a second hub to finalize the connection.
- Right‑click cancels an unattached connection.

## 37.2 Editing Connections
- Select **EDIT CONNECTIONS**.
- Left‑click a connection to select it.
- Right‑click and hold on the attached hub to detach it.
- Move the cursor to another hub and release to reattach.
- Releasing while not over a hub deletes the unattached connection.
- Naming connections allows them to be referenced via lua scripting.

# 38. Hub and Connection Appearance
Hubs and connections appear as 2D lines with shaded columns for visualization.  
These columns represent infinite height in-game.

Visibility controls:

- **Toggle Hub Height**
- **Toggle Connection Height**

Height and transparency can be adjusted using the **Height** and **Alpha** fields.
# 39. Filters
Planning filters determine which unit types may use a connection.  
They function similarly to Barrier filters and are toggled per connection.

# 40. Weights
Each connection has a default weight of 100.  
Weights influence AI path selection by making certain connections more or less desirable.

## 40.1 Editing Weights
- Select **EDIT WEIGHTS**.
- Click a starting hub.
- A line follows the cursor until a destination hub is clicked.
- Right‑click cancels an unattached weight.
- Once attached, enter a new value in the **Weight** field.

Weights allow fine control over AI routing toward command posts.

# 41. Infinite Height
Planning paths have **infinite height**, as the game does not support 3D pathing.  
This means:

- Paths cannot overlap vertically.
- Stacked play spaces must be connected using hubs rather than overlapping connections.

# 42. Boundary Edit Mode
Boundaries define the playable area of a map. Crossing a boundary triggers a death countdown and a warning message. Boundaries also prevent players from seeing the edge of the terrain or sky.

## 42.1 Creating a Boundary
- Select **NEW BOUNDARY**.
- A circular boundary is created automatically.
- Adjust using **HEIGHT** and **DEPTH** sliders.
- Boundaries can be moved by right‑clicking and dragging.
- Multiple boundaries may exist; the death timer triggers only when a unit is outside all boundaries.

## 42.2 Boundary Names
Boundary names are arbitrary but must be correctly declared in the mission LUA to function.

# Layers for Game Modes
This document explains how **Game Modes**, **Layers**, and **REQ/MRQ files** work in ZeroEditor, along with the rules and workflows required to safely add, remove, and manage layers and game modes.

## 1. Overview: What Changed?
Game Modes introduce a new system where layers are grouped and selectively loaded by mission LUA scripts.
> A Game Mode is a collection of layers… Layers in the Common Game Mode are always loaded… other Game Modes must be loaded explicitly in a mission LUA.

### Key points
- **Game Modes now exist** and control which layers load in‑game.
- **Common layers** always load.
- **Non‑common layers** load only when specified in the mission LUA.
- **Layers now have real significance**—they are discrete entities tied to REQ/MRQ generation.
- **World REQs moved** into each world’s folder (e.g., `tat/world1/tat1.req`).
- Some previously working features (e.g., vehicle spawns) may break if layer rules are violated.

## 2. Layer Management Workflow (Add / Delete / Rename)
Layers are now standalone entities with their own metadata. Changing them requires updating REQ/MRQ files.

### Required files to check out
- `*.wld` — World file  
- `*.ldx` — Layer index  
- `*.req` — World REQ  
- `*.mrq` — Mode REQs (if any)

### Steps
1. **Open the editor** and modify layers as needed.
2. **Configure Game Modes** (see section 4).
3. **Regenerate REQ/MRQ files**  
   > "Click [Generate], select the World REQ… This step rewrites all .REQ and .MRQ files."
4. **Save the world.**
5. **Check in** updated REQ, LDX, and MRQ files.
6. **Munge** (clean first if new to Game Modes).

## 3. Mandatory Layer Rules
These rules are enforced by the engine and must be followed to avoid broken gameplay.
> "Any vehicle spawns MUST be in the SAME LAYER as the command post they are associated with."  
> "The capture and control regions for a command post MUST be in the SAME LAYER as the command post."

### Rules
- **Vehicle spawns** must be in the same layer as their **command post**.
- **Capture/control regions** must be in the same layer as their **command post**.
- More rules may exist but were not included in the provided text.

## 4. Creating & Managing Game Modes
Game Modes define which layers load for a given mission.

### Game Mode UI Components
- **Common Layers** — always loaded  
- **Game Mode List** — defined modes  
- **Layers Used** — layers assigned to the selected mode

### Rules
- A layer **cannot** be both **Common** and part of a Game Mode.
- Layers must be explicitly assigned to modes.

### Create a Game Mode
1. Under **Mode Name**, click **Add**.
2. Select the new mode and rename it.
3. Press **Enter** to confirm.

### Remove a Game Mode
- Select the mode → click **Remove**.

### Add a Layer to a Game Mode
1. Remove the layer from **Common Layers**.
2. Select the target Game Mode.
3. Under **Layers Used**, click **Add** and choose the layer.

### Remove a Layer from a Game Mode
- Select the mode → select the layer → click **Remove**.

### Finalize Game Modes
As with layer editing:
> Click [Generate], select the World REQ… This step rewrites all .REQ and .MRQ files… Don’t forget to save your World! And to munge.

## 5. Using Game Modes in Mission LUA
Each Game Mode generates an MRQ file named:
> "In the case of Hoth… world name is ‘hoth.wld’… created ‘hoth_Conquest.mrq’."

### How to load a Game Mode in LUA
Find the world load line:

```lua
ReadDataFile("HOT\\hot1.lvl")
```
To load a Game Mode, append the MRQ name without .mrq:
`ReadDataFile("HOT\\hot1.lvl", "hoth_Conquest")`

This loads:
- All Common layers
- All layers assigned to Conquest
- After editing:
- Save the LUA
- Re‑munge Common

## 6. Summary of the Full Workflow
When modifying layers or game modes:
Focus on WLD, LDX, GRP, REQ, MRQ files.
- Edit layers.
- Configure Game Modes.
- Regenerate REQ/MRQ.
- Save world.
- Check in updated files.
- Munge.

When calling for a Game Mode in LUA:
- Add MRQ name (no extension) to ReadDataFile.
- Re‑munge Common.

# Procedural Animation
A procedural animation (PA) is a way of defining movement for any static object. It is designed to add more life to levels.
A PA is a series of keyframes:  a keyframe stores either a position or a rotation (in degrees), and a time (in seconds). Position and rotation are considered separate, so there does not need to be a both a position and rotation keyframe at any given time. (You can usually consider the position and rotation animations to be separate from each other.) The object moves between keyframes as time progresses, and this creates an animation.

A simple example:
A position keyframe at (0,0,0) with time = 0, and another at (10,0,0) with time = 10 sec. When played, the object will move smoothly from (0,0,0), through (5,0,0) at 5 sec, to (10,0,0) at 10 sec., and will stay at (10,0,0) from then on. If the animation is set to Loop, then the object will return to (0,0,0) right after 10 sec. and the animation will repeat.

PA mode in ZeroEditor is a 90/10 function, meaning it can do 90% of the things that you want to fairly easily, and if it could do the extra 10% then it would take months to build. Therefore, what you CAN do with it is as follows:
- Move a static object any which-way over time.
- Associate an animation with the object that it acts upon.
- Associate many of ^ those pairs into an Animation Group.
- In-game play, pause, restart, and play sections of an Animation Group through events, as well as triggering other events and groups.

And what you CAN’T do:
- Move regions or anything that isn’t a static object.
- Move non-static objects (spawned fliers, players, bots.)
- Have fine-grained control of sound associated with animations.
 
## The Animation Mode GUI
Click the well-hidden Animation Mode button (at the bottom of the Object Mode menu) to enter Animation Mode:

> Note: To go back to Object Mode, either click on the Back To Object Mode button in the top-center, or click the Object Mode button (which is lazy and never moves from its usual spot.)

Upon entering Animation Mode, all changes you make to objects (which are limited to moving and rotating them) are non-permanent, so when you save your world or Animation and then exit Animation Mode all objects are restored to their initial positions.

### The Helpful Display Options Menu
This menu provides a few important functions:
* Show Path – toggle display of the path of the object over the animation’s runtime.
* Show Ghosts – toggle on or off the "ghost" objects that show the object at various equally-spaced time intervals throughout the animation. For example, 2 ghosts = one at the start and one halfway through, 3 ghosts = one at the start, one at 1/3, and one at 2/3, etc.
* Ghosts Text Box – enter the number of ghosts to be shown.
* Toggle Graph – turn on or off the graphs of the objects X, Y and Z positions / rotations throughout the animation’s runtime. Example graph of an object moving from (0,0,0) to (10,20,30) over 10 seconds – NOTICE THE GRAPH LABELS showing different maximum values. Scaling can be confusing….

## The Animation side menu
- The name of the currently selected animation.
- The name of the currently selected object, if any.
- Displayed frame’s time in secs – text box / slider.
- Total run time in secs – text box.
- Loop and Local Translation buttons.
- List of all existing animations.
- Add new / delete current buttons.
- Play or stop buttons for the currently selected animation.
- Keyframe menus below for both position and rotation.
- Add / delete a position or rotation key.
- Listbox of keys showing what times they occur.
- Text boxes for changing the time, X, Y or Z values for the currently selected position or rotation key. Position is in meters, Rotation is in degrees.
- Type of transition to use from this key to the next key. 

If the transition type is Spline, below it will appear 6 text boxes for deciding on your X, Y and Z slopes when leaving this key, and the X, Y and Z slopes when arriving at the next key. There are "Pop", "Linear" and "Spline" types. Spline type transitions are used to create smoother animations – just be sure to match the "in" slope at a keyframe with the "out" slope.

## Keys, position, rotation, graphs and other confusing parts - creating a new animation
What use would animation mode be without the ability to create new animations? Probably not much considering it’s still useless even with that ability, so let’s examine the steps to creating a new animation.

First of all, click the Add button to create a new animation. Then give it a descriptive name so it can be referenced later.
Finally, decide on a total run time and enter it into the Run Time box. Don’t worry, you can change the run time later if you decide you want it to be different - but you can’t edit an animation that doesn’t have a Run Time.
Next, select the object you wish to use to create the animation. Please note that any object you want to animate must have a name, so if you are not in the habit of naming your objects, go name the one you want now before you try to animate it.
> Note:  The positions that are recorded in keys are calculated relative to the position the object was in when you entered Animation Mode!  In other words, if you enter Animation Mode and then move an object 10 feet and add a position key, that key will be (10,0,0) rather than (0,0,0).  If you wish to move the starting point of an animation, move the object in Object Mode first!

Additionally, it is probably a good idea to add both a position and rotation key at 0 seconds, as a starting point.

Now, the Time slider can move from 0 seconds to the end of the animation’s runtime.  If you have an object selected, moving the Time slider will move the object to its position at that time.

### To add a keyframe:
First, move the Time slider to the time at which you want the key, or type that time into the Time box. If you will be adding a Position key, move the object to the place you want it to be at that time, and click Add (under Position). If you will be adding a Rotation key, simply click Add (under Rotation).  For reasons too confusing and boring to list here, Rotations must be entered manually. Remember that "X" means rotating around the X axis (i.e. pitch), Y is rotation around the Y axis (yaw), and Z is roll. Finally, you can manually adjust the X, Y, Z, and time values of any key by selecting the key and typing the values in. The changes are shown immediately if an object is selected, to help with entering Rotations. After you’ve added some keyframes, perhaps moving the object to a few positions using Linear transitions, you can click Play to play the animation from the current frame time through to the end. You can also use the Play From Start button to play your animation from the beginning of the timeline.

### Looping:
If Loop is off (the default for any new animation), then once the animation reaches its final Run Time, the object will remain in its final position from then on. If Loop is on, then once the object passes the animation’s final keyframe, it will transition back to the first keyframe using whatever transition is specified in the final keyframe. It is as if you had duplicated the first keyframe again at the end of the animation.

### Local Translation:
Remember I said, "position and rotation are usually considered separate"?  Well, this is the reason for the "usually". If Local Translation is on, then the Position keyframes change depending on which way the object is facing.
Thus, with Local Translation on, the direction an object moves is determined by its rotation. This is useful for animating spaceships, cars, and objects that continually move in one direction ("forward") while turning.

> Hint:  Local translations can be difficult to wrap your head around. It helps to animate in pieces, doing position first to make a straight track, then go back and add rotations to make turns.

Next, decide how fast you want it to go. For example, if the animation is 30 seconds long and you want it to move at 10 meters per second, then it will have to move 300 meters total. Create a Position keyframe at 0 seconds, then create one at the end of the animation. Change the one at the end of the animation to reflect the total amount of movement - for example, (0,0,0) at 0 sec. and (300,0,0) at 30 sec. Thus the object will travel in a straight line at a constant speed. Now, turn on Local Translation and simply insert Rotation keyframes at whatever times you want, to bend the "track". You can create smooth variations in speed by using several Position keyframes connected by spline-type transitions.

### The Group side menu – creating a new animation group
So by now you have created a bunch of nifty things that you want to happen in your level. If this is true, then this section is where you want to be.

An Animation Group is a set of animation/object pairs e.g., Animation A on object A, Animation B on objects B and C, and so on. A Group can pair any animation(s) with any object(s), but the catch is that the objects must have been given names. So go back to Object mode and name the objects you need.

Only Animation Groups may be played in-game, so this is where all the magic happens – the Animation Group panel.
This panel contains the Name of the currently selected group. Add/delete group buttons, and group list. Plays When Level Begins button.  Play/stop currently selected group buttons. Add/delete an anim/obj pair from the current group. A list of paired names that reflect the object name and animation name. Edit the currently selected animation and object to be paired together.

So here’s how you use this panel for your animations.
Click the top Add to add an animation group, and then give it a descriptive name.

Click the Animation/Object Pairs Add button to add an animation/object pair to the currently selected group. You must add a new pair before you can edit it.

Type in the name of an animation and the name of the object it will be played on. Capitalization doesn’t matter, but make sure they are spelled correctly.

You can click the Play button to play the entire group and see what it acts like together.
> NOTE:  You must have an object with a name selected in order to play a group. 

That’s all there is to creating an animation group! When you have your groups created, you can move on to actually getting them to do things.

Groups that have Plays When Level Begins turned on will automatically play as soon as the level is loaded, meaning if all you’re trying to do is add background animation, you’re done now. 

Stops when Object is Controlled is a button that allows you to toggle off the animation if the player or an AI unit enters that object causing it to switch sides. This was not used in the final game, but was intended to give spacecraft a subtle hovering/floating animation that would stop when a ship was entered and start again when the ship was exited.

## Creating Hierarchies
When you are ready to start grouping objects in hierarchies, you’ll want to check out the aptly named Hierarchies panel in the lower right corner of the editor.

- The Root Name is the parent object that will control the other children objects. 
- The Selected object is a text entry box that you use to enter the name of the child objects. 
- The Hier List is allows you to select the hierarchy you wish to work on.
- The Obj List shows the children for a selected hierarchy

So how do you use this?  Simple!

- Click on the Add button below the Hier List, a new hierarchy will appear in the Hier List. 
- Click on the word Rootobj and type in the name of the parent object that is assigned in an animation group. 
- Next click the Add button below the Obj List and rename Obj 1 to the child object you want in the hierarchy. 

Remember that you’re animating the parent object, so don’t animate the child unless you want some crazy results. 
That’s it! DONE! 

When playing back the animation in ZeroEditor you won't see the child objects move with the parent object but it will work fine in-game.
Now, if you want the parent to be animated but the children to remain where they are (ie: animating a crane to pickup and box then drop it somewhere else) click the Disable Hierarchies button in the Animation Group panel and you can disable the parent children interaction between the objects only for that Animation Group. 

If you want to do more, then go on to the Dreaded LUA in the next section….

::ominous music::

## In-game control through the awesome power of LUA
Assuming you know LUA syntax and how events work (which are NOT explained in this doc), there are a few event-related things you can do with animation groups.

### Lua Functions
| Function | Description |
| :--- | :--- |
| `PlayAnimation("Animation Group Name")` | Resumes playing of an animation group from whichever time it was at last. |
| `PauseAnimation("Animation Group Name")` | Pauses the group’s playback – objects remain where they are currently. |
| `RewindAnimation("Animation Group Name")` | Rewinds the group to the beginning. Can be called while the group is playing. |
| `PlayAnimationFromTo("Animation Group Name", beginTime, endTime)` | Plays the indicated animation from beginTime to endTime (in seconds). |
| `SetAnimationStartPoint("Animation Group Name")` | Sets the current positions of the objects as the new start point for the next time they are animated. |

### Animation Start Points
When a level is loaded, the positions of all objects are captured, and those positions are used as the start points for animations unless SetAnimationStartPoint is called later. This is best demonstrated by an example.

Say an object is created at (0,0,0) on level load, and I have an animation group MyGroup that moves it 10 units forward on the X-axis.  If I play the entire animation: `PlayAnimation("MyGroup")`

The object ends up at (10,0,0). 

Now if I stop the animation and play it again
```lua
PauseAnimation("MyGroup")
RewindAnimation("MyGroup")
PlayAnimation("MyGroup")
```
The start point has not changed, so the object will go back to (0,0,0) and move again to (10,0,0). 

However, if I play the animation once, then SetAnimationStartPoint("MyGroup")
```lua
PlayAnimation("MyGroup")
-- wait 10 sec --
PauseAnimation("MyGroup")
SetAnimationStartPoint("MyGroup")
```
The start point is now the object’s current position, (10,0,0). So, the next time I play the animation, it will go from (10,0,0) to (20,0,0). See?

Start points are per-animation-group, so if I had a second animation group, MySecondGroup, that went 10 units up on the Y axis for this object, and I played it after playing MyGroup and after setting MyGroup’s start point.
```lua
PlayAnimation("MyGroup")
-- wait 10 sec --
PauseAnimation("MyGroup")
SetAnimationStartPoint("MyGroup")
PlayAnimation("MySecondGroup")
```
The object would go from (0,0,0) to (0,10,0), since the start point for MySecondGroup is still (0,0,0). 

To have them follow each other properly we need:
```lua
PlayAnimation("MyGroup")
-- wait 10 sec --
PauseAnimation("MyGroup")
SetAnimationStartPoint("MySecondGroup")
PlayAnimation("MySecondGroup")
```
So that MySecondGroup starts at the end point of MyGroup.
This should be as complicated as animation LUA programming gets, because they are not designed for complex use.
