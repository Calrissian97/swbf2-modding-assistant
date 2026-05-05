# Lighting System
This document explains the lighting system used by Star Wars Battlefront 2. The engine utilizes a Phong-shading model for world objects. Lighting is defined primarily through `.lgt` (World Lights) and `.sky` (Environmental) files. An environment map/cubemap can also be set in the `.lgt` file per world.

Sections:
- Lighting Constraints (lines 15-18)
- Shared Light Properties (lines 20-28)
- Directional Lights (lines 30-33)
- Omni Lights (lines 35-38)
- Spot Lights (lines 40-46)
- Environmental & Ambient Lighting (lines 48-62)
- Implementation (lines 64-65)

---

# Technical Constraints
*   **Per-Object Limit**: A maximum of **four lights** can affect a single object simultaneously. If more than four lights overlap an object's bounding box, additional lights are culled based on priority and proximity.
*   **Color Format**: All lights use an **RGB (0-255)** color space.
*   **Global Ambient**: Global "Top" and "Bottom" ambient colors are defined within the `.lgt` file to provide base illumination across the map.

# Common Light Properties
Every light type supports these core attributes:

*   **Static**: Determines if the light affects vertex-lit objects (useful for baked-in lighting optimizations).
*   **Cast Shadows**: Enables the light to cast dynamic shadows from objects with defined `shadowvolumes`.
*   **Cast Specular**: Enables the calculation of specular highlights on materials with specular rendertypes.
*   **Texture**: Allows the light to project a texture into the world.
    *   Supports **Clamped** or **Wrapped** addressing.
    *   Directional lights include additional projection controls: `Tile U`, `Tile V`, `Offset U`, and `Offset V`.

# Directional Lights
Directional lights act as a "sun" with boundless rays with a specific orientation but no falloff. They are typically used as the primary light sources for an environment.

*   **Bounding Region**: A unique property for directional lights that limits their influence to a specific 3D volume, rather than the entire world.

# Omni Lights
Omni lights are point sources that radiate light in a 360-degree sphere from their origin.

*   **Radius**: Defines the spherical boundary of the light. The intensity is completely attenuated (fades to zero) at this distance.

# Spot Lights
Spot lights project light in a directed cone, similar to a flashlight or searchlight.

*   **Range**: The maximum length of the light cone.
*   **Cone Angle Inner**: The radius of the inner cone where the light intensity is at its maximum (hotspot).
*   **Cone Angle Outer**: The radius of the outer cone where the light intensity falls off to zero (falloff).
*   **Bidirectional**: If enabled, projects a second identical cone in the exact opposite direction (180 degrees) of the primary cone.

# Environmental & Ambient Lighting (.sky)
The `.sky` file defines global atmospheric lighting and base ambient colors. These values are additive and provide constant illumination to objects regardless of their orientation to specific light sources.

## Ambient Color Properties
| Property | Target | Description |
| :--- | :--- | :--- |
| **`AmbientColor`** | Props/World | Base additive color applied to all world geometry. |
| **`TopDirectionalAmbientColor`** | Props (Top) | Additive color applied to the top-half of props. |
| **`BottomDirectionalAmbientColor`** | Props (Bottom) | Additive color applied to the bottom-half of props. |
| **`CharacterAmbientColor`** | Units | Specific ambient override for character models. |
| **`VehicleAmbientColor`** | Vehicles | Specific ambient override for vehicle models. |

## Color Syntax
Colors are defined as a triplet of values representing the **RGB (0-255)** color space:
`AmbientColor(128, 128, 128);`

# Implementation
Lights are typically placed using **ZeroEditor** and saved into `.lgt` files associated with specific world layers. However, they can also be defined via ODF files (ClassLabel = `light`) for attachment to model hardpoints of vehicles or props through a `AttachOdf = "odfName"` and corresponding `AttachToHardPoint = "nodeInMshName"` properties. If the prop is animated or attaching to a vehicle, a preceding `AttachDynamic = "1"` line is required.
