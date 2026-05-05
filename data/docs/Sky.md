# World Skies
This document explains how world skies/environments are staged. Worlds use sky dome msh files referenced in the `.sky` file to stage environments, with additional sky file parameters adjusting various world fog/lighting/rendering properties.

Sections:
 - Platform-Specific Blocks (lines 16-17)
 - Sky Info/Scene Range Block (lines 19-53)
 - Sun Info Block (lines 55-68)
 - Dome Info Block (lines 70-147)
 - Sky Object Blocks (lines 149-163)
 - Water Info Block (lines 165-176)
 - Flat Info Block (lines 178-189)
 - World Envmap Definition (lines 191-196)

 ---

# Valid Definitions
Note that in any point in the sky file platform-specific parameters can be defined by creating `PC(){...}`, `XBOX(){...}`, or `PS2(){...}` segments.

# Sky Info
The required Sky Info section of the sky file defines several global parameters for scene ranges, fogs, and colors.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Enable(<int>);` | Enables (1) or disables (0) the sky system. | `Enable(1);` |
| `FogRamp(<int>);` | Controls the density curve/ramp of the fog. | `FogRamp(3);` |
| `ObjectVisibility(<float>, <float>, <float>);` | Sets distance-based visibility thresholds for objects. | `ObjectVisibility(100.0, 400.0, 800.0);` |
| `VisibilityRange(<int>);` | Sets the maximum distance at which any entity is rendered. | `VisibilityRange(1200);` |
| `EnableFadeAdjustWithZoom(<int>);` | Enables adjustment of visibility fading based on camera zoom. | `EnableFadeAdjustWithZoom(1);` |
| `FogColor(<int>, <int>, <int>);` | Global RGB fog color (0-255). | `FogColor(128, 128, 128);` |
| `ReflectionFogColor(<int>, <int>, <int>);` | RGB fog color applied specifically to reflected surfaces. | `ReflectionFogColor(100, 100, 100);` |
| `FogRange(<float>, <float>);` | Near and Far distances for the standard scene fog. | `FogRange(20.0, 500.0);` |
| `WorldFogRange(<float>, <float>);` | Near and Far distances for the world/terrain fog. | `WorldFogRange(50.0, 1000.0);` |
| `NearSceneRange(<float>, <float>, <float>, <float>);` | Defines rendering distances for the Near Scene. | `NearSceneRange(30.0, 160.0, 40.0, 200.0);` |
| `NearSplitScreenRange(<float>, <float>, <float>, <float>);` | Near Scene range overrides for Split-Screen mode. | `NearSplitScreenRange(0.0, 5.0, 25.0, 50.0);` |
| `FarSceneRange(<float>, <float>);` | Defines rendering distances for the Far Scene (lowres). | `FarSceneRange(500.0, 3000.0);` |
| `FarSplitScreenRange(<float>);` | Far Scene range override for Split-Screen mode. | `FarSplitScreenRange(2000.0);` |
| `TopDirectionalAmbientColor(<int>, <int>, <int>);` | RGB ambient light color applied to the top-half of props. | `TopDirectionalAmbientColor(60, 60, 80);` |
| `BottomDirectionalAmbientColor(<int>, <int>, <int>);` | RGB ambient light color applied to the bottom-half of props. | `BottomDirectionalAmbientColor(20, 20, 25);` |
| `AmbientColor(<int>, <int>, <int>);` | Global base RGB ambient color for all geometry. | `AmbientColor(40, 40, 40);` |
| `CharacterAmbientColor(<int>, <int>, <int>);` | Specific RGB ambient override for character units. | `CharacterAmbientColor(80, 80, 80);` |
| `VehicleAmbientColor(<int>, <int>, <int>);` | Specific RGB ambient override for vehicles. | `VehicleAmbientColor(70, 70, 70);` |
| `SplitOptions()` | Opens a configuration block for Split-Screen settings. | `SplitOptions() { ... }` |

## Split Options
Overwrite or add rendering parameters to be used when playing in SplitScreen.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `PropClusterEnable(<int>);` | Enables or disables prop clustering in split-screen. | `PropClusterEnable(1);` |
| `PropClusterFadeAdj(<float>);` | Adjusts the fade distance for clusters in split-screen. | `PropClusterFadeAdj(0.8);` |
| `PropClusterDensity(<float>);` | Controls the density of prop clusters in split-screen. | `PropClusterDensity(0.5);` |

# Sun Info
The optional Sun Info section of the sky file defines sun parameters.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Angle(<float>, <float>);` | Horizontal and vertical orientation of the sun. | `Angle(-45.0, 30.0);` |
| `Color(<int>, <int>, <int>);` | RGB color of the sun light. | `Color(255, 255, 240);` |
| `ShadowColor(<int>, <int>, <int>);` | RGB color of the shadows cast by the sun. | `ShadowColor(40, 40, 50);` |
| `Texture("<string>");` | The sprite texture used to represent the sun in the sky. | `Texture("sun_flare");` |
| `Degree(<float>);` | Size or spread of the sun texture. | `Degree(5.0);` |
| `BackAngle(<float>, <float>);` | Orientation for the secondary "back" light. | `BackAngle(135.0, 20.0);` |
| `BackColor(<int>, <int>, <int>);` | RGB color of the secondary back light. | `BackColor(50, 50, 70);` |
| `BackDegree(<float>);` | Size or spread of the back light. | `BackDegree(10.0);` |

# Dome Info
The required Dome Info section of the sky file defines sky dome parameters as well as optional terrain parameters.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Texture("<string>");` | Base texture for the sky dome. | `Texture("sky_texture");` |
| `Angle(<float>);` | Horizontal rotation/orientation of the dome. | `Angle(180.0);` |
| `Ambient(<float>, <float>, <float);` | Ambient light multipliers for the dome surface? | `Ambient(1.0, 1.0, 1.0);` |
| `TerrainColorDarkening()` | Enables terrain colors to be darkened based on world lighting. | `TerrainColorDarkening();` |
| `Filter(<int>);` | Unknown. | `Filter(1);` |
| `Threshold(<int>);` | Brightness threshold for sky bloom/glow? | `Threshold(150);` |
| `Intensity(<int>);` | Global intensity of the dome colors? | `Intensity(255);` |
| `Softness(<int>);` | Softness/blur value for sky rendering? | `Softness(1);` |
| `SoftnessParam(<int>);` | Additional softness tuning parameter? | `SoftnessParam(1);` |
| `TerrainBumpTexture("<string>", <float>);` | Texture name and scale for terrain bump/normal mapping. | `TerrainBumpTexture("ter_bump", 1.0);` |
| `TerrainBumpDetail("<string>", <float>, <float>);` | Detail texture name and UV tiling for terrain. | `TerrainBumpDetail("ter_det", 2.0, 2.0);` |
| `TerrainBumpSpecularTexture("<string>", <float>);` | Specular map and scale for terrain highlights (Deprecated?). | `TerrainBumpSpecularTexture("ter_spec", 1.0);` |
| `DomeModel()` | Opens a configuration block for the Sky Dome mesh. | `DomeModel() { ... }` |
| `LowResTerrain()` | Opens a block for far-scene terrain settings. | `LowResTerrain() { ... }` |
| `Stars()` | Opens a block to configure the procedural star field. | `Stars() { ... }` |
| `CloudLayer()` | Opens a block to spawn a layer of cloud entities. | `CloudLayer() { ... }` |
| `TerrainEnable(<int>);` | Enables or disables terrain rendering (Possibly BF1 only). | `TerrainEnable(1);` |

## Dome Model
The Dome Model definitions define the geometry, offsets, and movement of sky dome models. At least one is required.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Geometry("<string>");` | The `.msh` file used for the sky dome. | `Geometry("sky_dome");` |
| `Offset(<float>);` | Offset for the dome model. | `Offset(-100.0);` |
| `MovementScale(<float>);` | Parallax movement multiplier relative to camera travel. | `MovementScale(0.01);` |
| `RotationSpeed(<float>, <float>, <float>, <float>);` | Rotation speeds for X, Y, Z axes and a global scalar. | `RotationSpeed(0.0, 0.001, 0.0, 1.0);` |
| `Effect("<string>", "<string>", <float>);` | Attaches a particle effect to a hardpoint on the dome. | `Effect("clouds", "hp_clouds", 1.0);` |
| `Reflect()` | Enables reflections on the dome mesh (Possibly BF1 only). | `Reflect();` |

## LowResTerrain
The optional LowResTerrain definitions define the heightmap used for farscene terrain and fog.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Texture("<string>");` | Heightmap for the low-res terrain. | `Texture("lowres_ter");` |
| `TextureScale(<float>);` | Scaling for the low-res terrain heightmap. | `TextureScale(10.0);` |
| `PatchResolution(<int>);` | Grid resolution for the generated terrain patches. | `PatchResolution(32);` |
| `FogNear(<float>);` | Fog start distance for the low-res terrain. | `FogNear(500.0);` |
| `FogFar(<float>);` | Fog end distance for the low-res terrain. | `FogFar(2500.0);` |
| `FogColor(<int>, <int>, <int>, <int>);` | RGBA fog color specific to the low-res terrain. | `FogColor(100, 100, 100, 255);` |
| `DetailTexture("<string>");` | Secondary detail texture for the far terrain. | `DetailTexture("ter_detail");` |
| `DetailTextureScale(<float>);` | Scaling for the far terrain detail texture. | `DetailTextureScale(5.0);` |
| `MaxDistance(<int>);` | Maximum rendering distance for the low-res terrain. | `MaxDistance(4000);` |

## Stars
If present, stars will be added to the sky dome. 

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `RandomSeed(<int>);` | Seed used for random star placement. | `RandomSeed(1234);` |
| `TwinkleFactor(<float>);` | Intensity of the twinkling animation. | `TwinkleFactor(0.6);` |
| `TwinkleFrequency(<float>);` | Speed of the twinkling animation. | `TwinkleFrequency(1.2);` |
| `Color(<int>, <int>, <int>, <int>);` | RGBA color for the star field. | `Color(255, 255, 255, 255);` |
| `EnableBottom(<int>);` | Enables rendering stars below the horizon line. | `EnableBottom(0);` |
| `NumStars(<int>);` | Total number of stars to generate. | `NumStars(8000);` |
| `StarTexture("<string>");` | Sprite texture used for each star. | `StarTexture("star_flare");` |
| `BrightStarPercent(<float>);` | Percentage of stars that are rendered larger/brighter. | `BrightStarPercent(0.1);` |
| `AlphaMin(<int>);` | Minimum alpha value for the dimmest stars (0-255). | `AlphaMin(50);` |
| `ColorSaturation(<float>);` | Adjusts the color saturation of the star field. | `ColorSaturation(0.5);` |

## Cloud Layer
If present, a layer of dusteffect entities will be spawned at a given height.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Height(<float>);` | Altitude at which the cloud layer is generated. | `Height(250.0);` |
| `Odf("<string>");` | ODF name of the `dusteffect` to use for clouds. | `Odf("bes1_prop_cloud");` |

# Sky Objects
If present, collision-less models will fly at specified heights and directions.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Geometry("<string>");` | MSH file used for the sky objects. | `Geometry("imp_fly_destroyer_dome");` |
| `NumObjects(<int>);` | Number of simultaneous instances to spawn. | `NumObjects(3);` |
| `Height(<int>, <int>);` | Min and Max altitude for spawning. | `Height(300, 500);` |
| `VelocityY(<int>, <int>);` | Min and Max vertical velocity range. | `VelocityY(-5, 5);` |
| `VelocityZ(<int>, <int>);` | Min and Max horizontal velocity range. | `VelocityZ(50, 100);` |
| `Acceleration(<float>, <float>, <float>);` | Acceleration vector (X, Y, Z). | `Acceleration(0.0, 0.0, 10.0);` |
| `Distance(<int>);` | Distance from the world center to spawn objects. | `Distance(1500);` |
| `InDirectionFactor(<int>);` | Factor determining movement directionality. | `InDirectionFactor(2);` |
| `LifeTime(<float>);` | Time in seconds before an instance is destroyed. | `LifeTime(80.0);` |

# Water Info
Function unknown, possibly additional water rendering parameters? Found on fel1.sky. 

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `TopColor(<int>, <int>, <int>);` | RGB color for the water surface/upper layer. | `TopColor(0, 50, 100);` |
| `BottomColor(<int>, <int>, <int>);` | RGB color for the water depth/lower layer. | `BottomColor(0, 10, 30);` |
| `TopRange(<float>);` | Range/Depth of the top color layer. | `TopRange(5.0);` |
| `BottomRange(<float>);` | Range/Depth of the bottom color layer. | `BottomRange(20.0);` |
| `BottomDrop(<float>);` | Vertical drop/offset for the water layer. | `BottomDrop(2.0);` |
| `Enabled(<int>);` | Enables or disables these specific water parameters. | `Enabled(0);` |

# Flat Info
Function unknown, possibly shadow map? Found on end1.sky.

Valid Definitions:
| Definition | Description | Example |
| :--- | :--- | :--- |
| `Height(<float>, <float>);` | Height range for the flat projection. | `Height(0.0, 10.0);` |
| `Texture("<string>");` | Texture applied to the flat layer. | `Texture("flat_shadow");` |
| `Color(<int>, <int>, <int>, <int>);` | RGBA color for the flat layer. | `Color(0, 0, 0, 128);` |
| `Modulate(<int>);` | Modulation/blending mode index. | `Modulate(1);` |
| `TextureSpeed(<float>, <float>);` | UV scroll speed (U, V). | `TextureSpeed(0.1, 0.05);` |
| `TileSize(<float>);` | Tiling size for the flat texture. | `TileSize(100.0);` |

# EnvTexture
If a texture is specified, the game will treat it as a cubemap/environment map for the world. (Applies to rendertypes that allow environment maps but don't specify a texture).

| Definition | Description | Example |
| :--- | :--- | :--- |
| `EnvTexture("<string>");` | Filename of the global cubemap texture. | `EnvTexture("world_cubemap");` |
