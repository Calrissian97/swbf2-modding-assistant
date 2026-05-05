# Art Guide
This document explains conventions needed to be followed when making game art (3D models, textures) for SWBF2.

Sections:
- Creating MSH Files (lines 13-21)
- Editing MSH Files (lines 23-29)
- MSH File Conventions (lines 31-196)
- Texture Conventions (lines 198-199)
- Option Files (lines 201-297)

---

# MSH Creation
Meshes can be imported/exported as `.msh` files using the following plugins:
*   **XSI/Softimage Plugin:** https://github.com/Schlechtwetterfront/xsizetools
*   **Blender Addon:** https://github.com/Calrissian97/SWBF-msh-Blender-IO

**Geometry Notes:**
*   **Triangles** are preferred; they can be packed into efficient triangle strips.
*   **Quads** are supported.
*   **N-gons** (5+ sides) are **NOT supported** and will cause errors.

# Editing
MSH files can be edited with use of a hexeditor. That said, each chunk of a msh file has a calculated size in the chunk header, so if you add or remove any bytes it will corrupt the file. You can however overwrite bytes with no issue, useful for renaming textures called by materials, granted the filename lengths are kept the same. If you must add or remove bytes to a chunk, you will have to recalculate that chunk's size, as well as all parent chunk sizes manually. There are tools that can edit msh files and do the necessary calculations for you.
| MSH Editing Tool | Web Link |
| :--- | :--- |
| MSHConsole: https://github.com/Calrissian97/MSHConsole/releases |
| MSHEditor: https://github.com/Ben1138/MSHEditor |
If doing things the manual way, it's recommended to examine the chunk hierarchies to see what sizes need recalculating. MSH file documentation can be found here: https://schlechtwetterfront.github.io/ze_filetypes/msh.html#overview. 

# MSH Conventions
## Mesh polygon counts
Official Battlefront II guidelines:
| Object Type | Recommended Poly Count |
| :--- | :--- |
| **Props** | 0 - 500 |
| **Buildings** | 200 - 3000 (High end for large interiors) |
| **Vehicles** | 1500 - 2000 |
| **Characters** | 1500 - 2000 |

*Note: While the engine can handle ~50,000 triangle meshes, exceeding guidelines causes the engine to aggressively switch to low-res LODs. To attempt to alleviate this, you may try editing the munged model files with this tool: https://github.com/PrismaticFlower/model-edit. This tool changes the polygon counts reported to the engine*

## Vertex Colors
Vertex colors can be assigned to "bake" lighting or otherwise manipulate the resulting color of polygons. If you wish to exclude lights from affecting the mesh in-game, the msh.option file should have a -vertexlighting parameter, and be sure to flag affecting lights as `Static`.

## UV Layers
Only a single set of UVs are read by the game, additional layers will either fail to munge or not be used by the game. Default behavior of UVs set beyond the 0.0 - 1.0 range will simply repeat the texture.

## Normals
Polygon normals are also exported to msh files, you can tweak them in XSI/Softimage or Blender, but the Blender addon will fail to re-import them and recalculate them based on polygon tangents.

## Skinning
Vertex weights can be assigned to allow vertices to move with enveloped bones. Only a single bone can be weighted to a vertex unless `-softskin` is a parameter included in the msh.option companion file. In XSI/Softimage this is done by adding an Envelope to the selected mesh and selecting the bones the mesh will be weighted to. In Blender this is a vertex group named after each bone to be weighted to.

## Cloth
BFII uses constraint-based cloth simulations for unit and prop models, solving simulation every frame based on ODF properties and mesh-specific constraint data. The artist must have a parented cloth mesh separate from the unit/prop mesh. A Cloth ODF named after the cloth model name must be included, and a `ClothODF` property referencing the corresponding cloth ODF must be in the attached entity's ODF.

### Required Properties

*   **Fixed Points (Attachment):** Determines which vertices are pinned to the mesh/skeleton and animated/deformed with it.
    *   **XSI/Softimage:** Defined in the `ZECloth` mesh attribute.
    *   **Blender:** Requires a vertex group named `Pin`. If the model has a skeleton, it also requires a vertex group named `bone_<name>` (e.g., `bone_pelvis`) for the enveloped bone (not required for props with cloth).

*   **Cloth Collisions:** Lists the collision primitives that the cloth should interact with.
    *   **XSI/Softimage:** `Collisions` property within the `ZECloth` mesh attribute.
    *   **Blender:** A custom string property named `swbf_msh_cloth_collisions` (e.g., `"['c_pelvis', 'c_l_thigh']"`). If omitted, the addon defaults to all collision primitives in the file.

*   **Texture:** Cloth meshes bypass the standard material system and require a specific texture assignment.
    *   **XSI/Softimage:** `Texture` property in the `ZECloth` mesh attribute.
    *   **Blender:** Automatically uses the diffuse texture of the assigned material during export.

## Tentacles
Slightly similar to cloth, these are bones animated through physics and unit movement. They can be used for hair (Wookiee Warrior), pouches that move (Chewbacca), Twilek head-tails(Aayla Secura) or anything else you like, they can even be used to animate weapons(?).
The artist needs to include bones named bone_string_1 through bone_string_# (maximum is 20) and make sure they are in the basepose and properly parented to each other. The soldier's ODF must have the following properties to enable them:
| Property | Value Range | Description |
| :--- | :--- | :--- |
| `NumTentacles` | "1-4" | Max of 5 bones per tentacle (Can be split up, so a 12-bone tentacle can exist as 4 3-bone tentacles). |
| `BonesPerTentacle` | "1-5" | How many bones can be deformed per tentacle. |
| `TentacleCollType` | "0-2" | Specifies type of auto-generated collision. 0 is Box, the default, 1 is Sphere, 2 is Cylinder. |

## LOD Meshes
Level of Detail (LOD) meshes are lower-resolution versions of a model used by the engine to optimize performance as objects move further from the camera.

### LOD Suffix Mapping
| Mesh Suffix | Engine Result | Description |
| :--- | :--- | :--- |
| *(None)* | **LOD0** | Full Detail mesh. |
| `_lod2` | **LOD1** | Medium detail level. |
| `_lod3` | **LOD2** | Lower detail level. |
| `_lowres` | **LOWD** | Minimum detail mesh for the "Far Scene". |
| `_lowrez` | **LOWD** | Alias for `_lowres`. |

**Grouping Logic:**
Objects sharing the same suffix (e.g., `door_lod2` and `frame_lod2`) are automatically merged into the same LOD level within the resulting `.model` file upon munging.

## Shadowvolumes
Shadowvolumes mimic the model's profile to cast shadows on terrain/objects and enable self-shadowing.
1. **Mesh Creation:** Create a low-poly, completely closed mesh slightly smaller than the original. It should not "poke through" the original geometry. The silhouette is the most important part. Global center must be `0,0,0`.
2. **Naming:** Name the mesh `shadowvolume`. For multiple volumes, use `shadowvolume1`, `shadowvolume2`, etc. For BFII, the preferred naming is `sv_meshNameHere`.
3. **Hierarchy:** Parent the shadowvolume to its related mesh or bone (for skinned models).
4. Select the shadowvolume mesh. 
5. In the Animate menu, select Create -> Parameter -> New Custom Parameter. 
6. In the dialogue box, rename the Parameter Name to shadowvolume. Uncheck the Animatable Characteristic Button. 
7. Hide the shadowvolume mesh before export 

## Collisions
Collision meshes are simple low-poly meshes that are used by the game engine to calculate when and how objects collide with each other. There are 2 types of collision objects used in SW BattleFront: collision meshes and collision primitives. 

### Collision Mesh
1. This is usually a low-poly yet fairly conforming version of the original mesh. It is most often used for soldier and ordnance collision since those are most obvious ways to see collision mesh correctness. For example, you can see the ordnance collision on an object by shooting at it with any weapon. If the collision is sloppy and covers gaps or is not correctly aligned with the original mesh, then you will see the laser blasts hit empty space or inside the actual geometry of the model. The collision mesh has to be named "collision", or if there are more than one, "collision", "collision1", "collision2", etc. Multiple collision meshes will all get merged into one when munged. This is very important when considering rule #3. Do make the collision mesh a child of the root node or its corresponding node, and make sure its global center is at 0,0,0. 
2. Enabling the Collision Mesh: if the vehicle .MSH file has a corresponding .OPTION file, then it might contain the argument "-nocollision". This is to prevent generation of a default collision mesh using the model's full geometry. If you have specified a collision mesh in XSI, you will need to remove this argument from the .OPTION file. 
3. Collision meshes can NOT be used on moving parts (turrets, bones etc). When the vehicle is munged, all collision mesh nodes are merged into a single non-articulated collision mesh. If a moving part on a vehicle requires collision, it will have to be specified with a primitive. 
4. If a vehicle has a collision mesh, it will automatically be used when colliding with soldiers and ordnance. Collision meshes (on vehicles) are not used for any other type of collision. Primitives must be used when vehicles collide with terrain, buildings, and other vehicles. Collision Primitives

### Collision Primitives
Primitives are computationally cheaper and the only option for animated parts.
*   **Cubes:** Scalable in X, Y, Z. Keep base size at 8 units and scale from there.
*   **Cylinders/Spheres:** **NOT** scalable via transform. You must use the object's radius and length properties.
*   **Stability:** Do not "Freeze" or reset the primitive. Do not move the object's center point.

#### Naming Conventions (BFII)
BFII allows defining collision types directly in the name using `p_-xxx-name` (Primitive) or `collision_-xxx-name` (Mesh).

| Code | Collision Type |
| :--- | :--- |
| `s` | Soldier (Soft) |
| `v` | Vehicle (Rigid) |
| `b` | Building (Static) |
| `o` | Ordnance |
| `t` | Terrain |

**Example Names:**
*   `p_-sv-MyBox`: Box for soldier and vehicle collision.
*   `collision_-o-MyMesh`: Mesh for ordnance collision only.

**Important Rules:**
*   **Merging:** All collision meshes are merged into ONE at munge-time. If you name one part `collision_-s-1`, the entire merged mesh becomes soldier-only.
*   **Limits:** Maximum **64** collision objects total (e.g., 63 primitives + 1 merged mesh).
*   **Stability:** Avoid Cylinders for vehicles; they often have bounding box issues. Use Boxes or Spheres.

### Cloth Collision Primitives
SWBF2 utilizes specific cloth collision primitives. These are similar to standard collision primitives but follow different naming and behavioral rules:

*   **Supported Geometry:** Use only a Cube, Sphere, or Cylinder primitive with unmodified topology. For the Blender addon, shape and size must be defined only via un-applied transforms and scaling.
*   **Naming Conventions:**
    *   **Prefix:** Must start with `c_` (unlike the `p_` used for standard primitives).
    *   **Suffix:** Conventionally named after the bone they are parented to (e.g., `c_pelvis`).
    *   **Note:** While the addon supports both shape-based naming or heuristic geometry detection, you should explicitly follow the `c_boneName` or `c_shapeType` conventions for reliable results.
*   **Hierarchy:**
    *   Can be parented to the Armature/Bone (to move with the skeleton) or directly to the `dummyroot`.
*   **Important - Transforms:** 
    *   Do **not** "Apply" transforms or scaling (e.g., Ctrl+A in Blender). 
    *   Primitives must retain their raw transform data; if transforms are applied, they will default to the transform and scale of the `dummyroot` upon export.

## Terrain Cutters
In .msh files any object starting with "terraincutter" results in it "cutting" a hole into the terrain when it is used as a prop in Zero Editor. They cannot be concave meshes, but multiple can be used to achieve the effect. Name them `terraincutter1`, `terraincutter2`, ...

## Hard Points
Any object that begins with "hp_" is treated as a hardpoint by modelmunge. Hardpoints are used as reference points for a variety of things, like attaching a light or particle effect to a model or setting the seat location of a vehicle to name a few. In XSI/Softimage these are referred to as Nulls, in Blender they are called Empties. Non-mesh objects can be hardpoints (and commonly are) but modelmunge must be explicitly told to keep them in the munged file via a `-keep objectNameHere` or `-keepall` parameter in the companion msh.option file.

## Materials
Materials define how a mesh surface is rendered, including shaders and texture blending. Materials can have up to four textures associated for special rendering depending on the rendertype (TX0D, TX1D, TX2D, TX3D).

### Material Flags
*   **Unlit:** The material is unaffected by dynamic lights. Useful for surfaces intended to appear self-illuminated.
*   **Glow:** Functions as *Unlit* but enables a **Glow Map** via the diffuse alpha channel.
    *   **Behavior:** Lighter alpha = more glow; darker alpha = less glow.
    *   **Logic:** This brightens the material to exceed the map's bloom threshold (defined in the world's `.fx` file HDR settings), triggering the engine's bloom effect.
*   **Per-Pixel Lighting:** Calculates diffuse lighting per-pixel rather than the default per-vertex.
*   **Specular Lighting:** Enables specular reflection in addition to diffuse lighting.
    *   **Gloss Map:** Uses the alpha channel of the diffuse or normal map to attenuate strength (Lighter = more specular, darker = less specular).
    *   **Specular Color:** Controls the tint of the reflected highlights globally across the material.

### Transparency Flags
*   **Single-sided:** Standard alpha-blended gradient transparency. Controlled by the diffuse alpha channel.
*   **Double-sided:** Same as single-sided, but backface culling is disabled, rendering both sides of the geometry.
*   **Additive:** The material is added to the scene color, making objects behind it appear brighter.
*   **Hardedged:** Alpha cutout/clip transparency. Pixels with an alpha value below 0.5 (128) are discarded.
    *   *Advantage:* This method avoids the alpha sorting and depth-ordering issues common with blended transparency.

### Material Rendertypes
| Rendertype | Rendertype Num | ATRB Data0 | ATRB Data1 | TX0D | TX1D | TX2D | TX3D |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Normal** | 0 | Detail Map Tiling U | Detail Map Tiling V | Diffuse Map | | Detail Map | |
| **Scrolling** | 3 | Scroll Speed U | Scroll Speed V | Diffuse Map | | Detail Map | |
| **Specular** | 4 | Detail Map Tiling U | Detail Map Tiling V | Diffuse Map | | Detail Map | |
| **Envmapped** | 6 | Detail Map Tiling U | Detail Map Tiling V | Diffuse Map | | Detail Map | Env Map |
| **Animated** | 7 | Animation Length | Animation Speed | Diffuse Map | | Detail Map | |
| **Refractive** | 22 | Detail Map Tiling U | Detail Map Tiling V | Diffuse Map | Distortion Map | | |
| **Normalmapped Tiled** | 24 | Normal Map Tiling U | Normal Map Tiling V | Diffuse Map | Normal Map | Detail Map | |
| **Blink** | 25 | Blink Min Brightness | Blink Speed | Diffuse Map | | Detail Map | |
| **Normalmapped Envmapped** | 26 | Detail Map Tiling U | Detail Map Tiling V | Diffuse Map | Normal Map | Detail Map | Env Map |
| **Normalmapped** | 27 | Detail Map Tiling U | Detail Map Tiling V | Diffuse Map | Normal Map | Detail Map | |
| **Normalmapped Tiled Envmapped** | 29 | Normal Map Tiling U | Normal Map Tiling V | Diffuse Map | Normal Map | Detail Map | Env Map |

** Note ** There are rendertypes for each number from 0 - 31 but several are deprecated and therefore not listed.

# Texture Conventions
Textures must be a power of 2 (except for cubemaps). Standard format is TGA without RLE compression. Textures with an alpha channel will use the alpha for various material effects such as transparency, specular, or glow. Bump maps and normal maps should always have a `-format ` parameter specifiying a bump type (terrain_bump, bump, bump_alpha, etc.). Grayscale bump maps should also always have either a `-bumpmap` or `-hiqbumpmap` parameter which will convert the grayscale heightmap into a colored normal map. Bump scale can be adjusted through the `-bumpscale <float>` parameter (default is 6.0).

# Option Files
## MSH.option Files
### Model Munge Parameters
| Option | Platform | Description |
| :--- | :--- | :--- |
| `-keep <string>` | Any | Keep the named object as a hardpoint in the exported skeleton. |
| `-keepall` | Any | Keep all objects as hardpoints. |
| `-keepmaterial <string>` | Any | Do not combine geometry attached to the named node; used for dynamic material properties (e.g., scrolling). |
| `-righthanded` / `-lefthanded` | Any | Sets handedness. `-righthanded` is the default. |
| `-scale <float>` | Any | Rescale the model. Default is 1.0. |
| `-maxbones <int>` | Any | Max bones per skinned segment. Default: 32 (Console), 16 (PC). |
| `-lodgroup <string>` | Any | Set LOD group: `model`, `bigmodel`, `soldier`, or `hugemodel`. |
| `-lodbias <float>` | Any | Adjust LOD distance. Default is 1.0. |
| `-nocollision` | Any | Do not export collision geometry. |
| `-nogamemodel` | Any | Do not export LODing data. |
| `-hiresshadow <int>` | Any | Generate shadow volume from geometry for the given LOD. |
| `-shadowon` | PS2 | Export shadow volumes (always on for PC/Xbox). |
| `-softskinshadow` | Xbox/PC | Export full 3-bone skinning weights for shadow volumes. |
| `-hardskinonly` | Any | Force 1-bone skinning on all segments. |
| `-softskin` | Any | Export full 3-bone skinning weights. |
| `-donotmergeskins` | Any | Prevent merging non-skinned segments into a hard-skinned segment. |
| `-vertexlighting` | Any | Interpret vertex colors as burned-in lighting. |
| `-additiveemissive` | Any | Interpret unlit materials as additive blended. |
| `-bump <string>` | Xbox/PC | Convert materials with specified diffuse texture to use bump mapping. |
| `-boundingboxscale <float>` | Any | Scale the model's bounding box. |
| `-boundingboxoffsetx/y/z` | Any | Translate the bounding box position. Use `-boundingboxoffsetnz` for negative Z. |
| `-ambientlighting "r=<float> g=<float> b=<float>"` | Any | How much light to add/subtract from each color channel of the vertex colors. |
| `-attachlight “<nodename> <lightname>”` | Any | Make emissive polygons animate according to the light intensity / flicker. |

## TGA.option Files
### Texture Munge Parameters

| Option | Platform | Description |
| :--- | :--- | :--- |
| `-maps <int>` | Any | Number of mipmaps. 0 = down to 1x1. Default 4 (PS2), 0 (PC). |
| `-bordercolor <hex>` | Any | Set color of 1-pixel border. |
| `-saturation <float>` | Any | 0.0 (grayscale) to 1.0 (fully saturated). Default 0.5. |
| `-32bit` / `-8bit` / `-4bit`| PS2 | Export non-palettized (32), 256-color (8), or 16-color (4). |
| `-cubemap` | PC/Xbox | Convert cross-unwrapped texture into a cubemap. |
| `-volume` | PC/Xbox | Convert into a volume map; requires `-depth`. |
| `-bumpmap` | PC/Xbox | Convert grayscale height map to RGB normal map. |
| `-hiqbumpmap` | PC/Xbox | High-quality bumpmap algorithm (prevents pixel offset). |
| `-bumpscale <float>` | PC/Xbox | Scale the heightmap steepness for normal generation. |
| `-format <string>` | PC/Xbox | Set output format (e.g., `DXT1`, `A8R8G8B8`). |
| `-detailbias <int>` | PC | Prevents resolution reduction on lower settings (0-7). |

### Format Details
**Special Formats:**
| Special Format | Platform | Description |
| :--- | :--- | :--- |
| `Detail` | Any | Grayscale detail map. Average value should be ~128. |
| `Terrain_Detail` | Any | Terrain-specific detail map. |
| `Terrain_Bump` | PC/Xbox | Terrain-specific bump map. |
| `Terrain_Bump_Alpha` | PC/Xbox | Terrain-specific bump map with alpha. |
| `Compressed_Alpha` | PC/Xbox | Force 1-bit or 4-bit alpha; uses `DXT1`, `DXT3`, or `L8`. |
| `Bump` | PC/Xbox | Normal map without alpha. |
| `Bump_Alpha` | PC/Xbox | Normal map with alpha. |
| `Compressed` | PC/Xbox | Force 1-bit alpha; uses `L8` or `DXT1`. |

**Standard Formats:**
| Format | Platform | Description |
| :--- | :--- | :--- |
| `DXT1` | PC/Xbox | 4 bpp. Block compressed, 0 or 1 bit alpha. |
| `DXT3` | PC/Xbox | 8 bpp. Block compressed, 4 bit alpha. |
| `A8R8G8B8` | PC/Xbox | 32 bpp. 8-bit color + 8-bit alpha. |
| `X8R8G8B8` | PC/Xbox | 32 bpp. 8-bit color, no alpha. |
| `A1R5G5B5` | PC/Xbox | 16 bpp. 5-bit color, 1-bit alpha. |
| `R5G6B5` | PC/Xbox | 16 bpp. 5-bit+ color, no alpha. |
| `X1R5G5B5` | PC/Xbox | 16 bpp. 5-bit color, no alpha. |
| `A4R4G4B4` | PC/Xbox | 16 bpp. 4-bit color, 4-bit alpha. |
| `A8L8` | PC/Xbox | 16 bpp. 8-bit gray, 8-bit alpha. |
| `A8` | PC/Xbox | 8 bpp. color forced to white, 8-bit alpha. |
| `L8` | PC/Xbox | 8 bpp. 8-bit gray, no alpha. |
| `A4L4` | PC/Xbox | 8 bpp. 4-bit gray, 4-bit alpha. |

### Detail Bias Chart (PC)
Controls texture resizing for Low/Medium settings. Square texture maximum sizes:

| Format | Low (bias 0) / Med (bias 0) | Low (bias 1) / Med (bias 1) | Low (bias 2) / Med (bias 2) | Low (bias 3) / Med (bias 3) |
| :--- | :--- | :--- | :--- | :--- |
| **DXT1** | 256 | 256 | 512 | 512 |
| **DXTn / L8** | 128 | 256 | 256 | 512 |
| **16bit** | 128 | 128 | 256 | 256 |
| **32bit** | 64 | 128 | 128 | 256 |

## TER.option Files
### Terrain Munge Parameters
| Option | Platform | Description |
| :--- | :--- | :--- |
| `-maxlayers <int> | Any | Maximum texture layers to interpolate at any given vertex.
| `-lowres_numpatches <int> | Any | Number of patches the lowres terrain will have.
| `-lowres_patchsize <int> | Any | Size of patches the lowres terrain will have.
| `-reducewater <int> | Any | Unconfirmed, possibly patch size of water in farscene.
| `-watercutter_patchsize <int> | Any | Unknown.

## FFF.option Files
Only known parameter is `-texsize <float>` which may correspond to the resulting texture size.
