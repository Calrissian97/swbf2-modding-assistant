# World Regions
This document explains how regions work in Star Wars Battlefront 2.

Sections:
 - RainShadow Regions (lines 20-31)
 - Shadow Regions (lines 33-46)
 - Reflection Regions (lines 48-54)
 - Fly/Danger Regions (lines 56-62)
 - Rumble Regions (lines 64-70)
 - Sound and Foley Regions (lines 72-81)
 - Damage Regions (lines 83-101)
 - AIVis Regions (lines 103-108)
 - Death Regions (lines 110-115)
 - MapBounds Regions (lines 117-122)
 - Branch-Path Regions (lines 124-129)

 ---

# Region Types
# RainShadow Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `rainshadow` |
| **Parameters** | None |
| **Usage** | Use box, cylinder, or sphere type. |
| **Results** | Within the region, precipitation effects (rain or snow) will be disabled. |

**Note on Precipitation:** Since the precipitation effect works by tiling one box of simulated rain or snow around the camera, the effect is disabled based on box boundaries, which may leave some artifacts. The size of these boxes is determined by the `PrecipitationEffect` parameters in the world's `.fx` file.

## Rotations
RainShadow regions **cannot be rotated** within ZeroEditor; doing so will cause them to break.

# Shadow Regions
Dynamic objects (characters, vehicles, and items) within the region will use the given lighting parameters instead of the global environment parameters. Lighting parameters blend with the global parameters over a 5-meter radius on the outside edge of each region.

**Note on Props:** If world props do not seem to inherit ambient colors, ensure that `Lighting = "Dynamic"` is defined in the corresponding prop `.odf` file.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `directional` | `<float(0.0-1.0)>` | Set the intensity of the global directional light (sun light). Matches `d=`, `di=`, `dir=`, etc. |
| `directional1` | `<float(0.0-1.0)>` | Set the intensity of the second global directional light. |
| `ambient` | `<float(0.0-1.0)>` | Set the intensity of global ambient light relative to local ambient color. `0.0` = all local, `0.5` = blend. Matches `a=`, `am=`, `amb=`, etc. |
| `color` | `<int>,<int>,<int>` | Set the local ambient color (RGB) for the region. Matches `c=`, `co=`, `col=`, etc. |
| `colortop` | `<int>,<int>,<int>` | Set the local top ambient color (RGB) for Xbox/PC. Matches `colort=`, `colorto=`, etc. |
| `colorbottom` | `<int>,<int>,<int>` | Set the local bottom ambient color (RGB) for Xbox/PC. Matches `colorb=`, `colorbo=`, etc. |
| `envmap` | `"<string>"` | Overrides world envmap with a local texture for environment-mapped materials. |

# Reflection Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `reflection` |
| **Parameters** | None |
| **Usage** | Use box or cylinder type; the bottom plane represents the reflection plane. |
| **Results** | Objects supporting faked reflection are rendered a second time, reflected by the bottom plane. |

# Fly/Danger Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `danger` |
| **Parameters** | None |
| **Usage** | Use any type. |
| **Results** | Flyer AI will avoid these regions. |

# Rumble Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `rumble` |
| **Parameters** | `<string(rumbleclassname)> <string(rumbleOdfName)>` |
| **Usage** | Use any type. Name must be **exactly** `rumble`. |
| **Results** | Triggers the rumble and attached particle effects when the player enters the region. |

# Sound and Foley Regions
| Type | Name Prefix | Parameters | Result |
| :--- | :--- | :--- | :--- |
| **Sound Trigger** | `soundtrigger` | `<string(propertyname)>` | Triggers a sound on entry. |
| **Sound Space** | `soundspace` | `<string(soundspaceid)>` | Changes sound space parameters on entry. |
| **Static Sound** | `soundstatic` | `<string(id)> <float(divisor)>` | Triggers a static sound on entry. |
| **Sound Stream** | `soundstream` | `<string(id)> <float(divisor)>` | Triggers a sound stream on entry. |
| **Foley FX** | `foleyfx` | `<string(groupid)>` | Triggers a foley change on entry. |

*Note: For sound regions, names must be exactly the prefix (e.g., `soundspace`). Appending numbers like `soundspace0` will break functionality.*

# Damage Regions
Damage Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `damage` |
| **Usage** | Use box, cylinder, or sphere type. |
| **Results** | Damage will be applied to objects within the region. |

**Parameters (key=value):**
| Parameter | Type | Description |
| :--- | :--- | :--- |
| `damagerate` | `<float>` | Damage per second applied to objects. |
| `personscale` | `<float>` | Scale factor for damage to people. |
| `animalscale` | `<float>` | Scale factor for damage to animals. |
| `droidscale` | `<float>` | Scale factor for damage to droids. |
| `vehiclescale` | `<float>` | Scale factor for damage to vehicles. |
| `buildingscale` | `<float>` | Scale factor for damage to buildings. |
| `buildingdeadscale` | `<float>` | Scale factor for damage to dead buildings. |
| `buildingunbuiltscale` | `<float>` | Scale factor for damage to undamaged/unbuilt buildings. |

# AIVis Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `aivis` |
| **Parameters** | `<float(crouch_mult)>, <float(stand_mult)>` |
| **Results** | Modifies the visual range of AI within this region. |

# Death Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `deathregion` |
| **Parameters** | None |
| **Results** | Entities die immediately upon entering this region. |

# MapBounds Regions
| Attribute | Description |
| :--- | :--- |
| **Name Prefix** | `mapbounds` |
| **Parameters** | None |
| **Results** | Used to determine the scale and bounds of the minimap. |

# Branch-Path Regions
When an entity reaches the end of a path, it uses parameters like `PathFollowerBranchPaths`, `PathFollowerBranchRange`, and `PathFollowerBranchMaxAngle` to determine the next path. Spherical regions can enclose path nodes to define branching destinations.

**Naming Format:** `"entitypathbranch {regionname}"` (e.g., `"entitypathbranch xwingStrafeStarDestroyer"`).

A branch region is referenced by a path node using the `BranchRegion` property. For example, a node with `BranchRegion("xwingStrafeStarDestroyer")` forces entities to branch to a node within that specific region. If no suitable paths are found inside the region, the engine selects the path closest to it.
