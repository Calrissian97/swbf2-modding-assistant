# World System
This document explains the world system used in Star Wars Battlefront 2.

Sections:
 - World Naming (lines 14-15)
 - Layers (lines 17-24)
 - Environment Files (lines 26-48)
 - Logic Files (lines 50-59)
 - Asset Loading (lines 61-74)
 - Technical Constraints (lines 76-80)

 ---

# Naming Convention
Worlds (maps) are identified by a unique **three-character code** (e.g., `tat` for Tatooine, `cor` for Coruscant). This code is used as a prefix for scripts, folders, and core world files.

# Layers
Worlds in BF2 utilize a hierarchical layering system. This allows developers to load a single physical map while swapping out objects, lighting, and AI logic for different eras or gamemodes.

*   **Base Layer (.wld)**: The primary layer that is always loaded. It contains common geometry and objects.
*   **Sub-Layers (.lyr)**: Additional layers containing lighting, objects, paths, hintnodes, AI planning, and regions.
*   **Organization**:
    *   **Layer Groups (.grp)**: A text-based index mapping layer IDs to their respective `.lyr` filenames.
    *   **Gamemode Groups (.ldx)**: Groups specific `.lyr` files together for loading based on the selected gamemode/era.

# Environment Files
Beyond objects, several specific file types define the world's visuals:

## World Skies (** .sky **) define the visual backdrop, atmosphere, and fog settings.

*   **Sky Domes**: A series of layered mesh models. Subsequent domes occlude previous ones.
*   **Rotation**: Domes can be assigned rotation rates to simulate moving clouds or celestial bodies.
*   **Sky Objects**: Specialized `msh` files with no collision that spawn at specified intervals, heights, and directions (e.g., distant starfighters, capital ships).
*   **Lighting**: Global ambient colors, character, and vehicle specific top and bottom ambient colors are defined in the sky file.
*   **Visibility**: NearScene and FarScene ranges are defined here, used for fading in/out LODs. Fog ranges and colors are also defined in this file, as well terrain bump or detail textures.

## World Lights (** .lgt **) define placed directional (up to 2), spot, and omni lights in the world.

*   **Light Types**: Directional (up to 2), Spot, and Omni lights can be placed throughout the world.
*   **Directional Lights**: These utilize a specific orientation and color but feature no falloff.
*   **Shadows & Specular**: Individual lights can be configured to cast or disable specular highlights and shadows.
*   **Advanced Properties**: Supports projecting textures through lights or limiting their influence to specific bounding light regions.
*   **Global Ambient**: The `.lgt` file also defines global "top" and "bottom" ambient colors for the environment.

## World Terrain (** .ter **) defines the vertex-terrain of the world.
*   **Water**: Only a single water layer can be defined at a time for a world.
*   **ter.option**: Companion `.ter.option` files can modify how terrain files are munged, such as number and size of lowres terrain patches, and max textures that can be layered on a single vertex.
*   **Foliage**: Up to four foliage layers can be painted onto the terrain, defined in a `.prp` file and optionally altering AI visibility.

# Logic Files
## AI & Navigation
*   **Planning (.pln)**: The connectivity graph (2D circular hubs with a set radius and 2D rectangle connections between hubs) the AI follows to reach objectives.
*   **Barriers (.bar)**: 2D rectangles that prevent specific unit types (e.g., SOLDIER or HUGE) from entering an area.
*   **Hintnodes (.hnt)**: Markers that tell AI where to snipe, lay mines, take cover, or hide from vehicles.

## Utility
*   **Regions (.rgn)**: 3D volumes (Box, Sphere, Cylinder) used for sound spaces, capture zones, and death regions.
*   **Paths (.pth)**: Catmull-Rom splines used for spline-following movement or spawn point placement.
*   **Boundaries (.bnd)**: Defines the playable area; exiting this triggers the "Return to Battle" countdown.

# Loading
World assets are loaded via Lua mission scripts using `ReadDataFile`. It is typically called during `ScriptInit` to load `.lvl` files. Certain assets will overwrite others with the same name, some will not be read at all if an asset with the same name is already loaded.

| Asset Type | Collision Behavior | Technical Impact |
| :--- | :--- | :--- |
| **ODF / Class** | First-In-Wins | Additional files with the same name are discarded. |
| **Models (.msh)** | First-In-Wins | The first version loaded into memory is locked. |
| **Textures** | Last-In-Wins | Overwritten by the most recently loaded version. |

## Recommended Loading Sequence
1.  **World**: Load the base `.lvl` containing the `.wld`.
2.  **Sky/Lighting**: Load `.sky` and `.lgt` for environmental assets.
3.  **Terrain**: Load additional `.ter` terrain files to overwrite base ones if desired.
4.  **FX**: Load world effects configurations.

# Technical Constraints
*   **Additive Properties**: Sky (`.sky`) and World FX (`.fx`) files are additive. Loading multiple is possible, but defining the same parameter (e.g., fog range) twice will cause conflicts.
*   **Terrain (.ter)**: Loading multiple terrain files is supported; the last one loaded overwrites previous data.
*   **Water Warning**: The engine typically supports only **one** water layer. Attempting to load multiple terrains with active water layers usually results in a crash.
*   **World FX**: Certain world effects (like godrays or water) must be compiled into the world `.lvl` and loaded alongside the base world file to work properly.
