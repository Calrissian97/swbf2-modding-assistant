# World FX
This document explains how world effects are defined in Star Wars Battlefront 2.

Sections:
 - Platform-Specific Blocks (lines 24-25)
 - Water Effect (lines 27-69)
 - Precipitation Effect (lines 71-93)
 - Lightning Flash Effect (lines 95-111)
 - Lightning Bolt Effect (lines 113-135)
 - Blur Effect (lines 137-146)
 - Color Control (lines 148-166)
 - Bloom Effect (HDR) (lines 168-178)
 - Godrays Effect (lines 180-199)
 - Fog Effect (Volumes) (lines 201-214)
 - Sun/Lens Flare Effect (lines 216-232)
 - Post-Processing and Shadows (lines 234-241)
 - Wind Effect (lines 243-250)
 - Space Dust (lines 252-269)
 - Heat Shimmer (lines 271-281)
 - Loading Constraints (lines 283-287)

---

# Valid Definitions
Note that in any point in the fx file platform-specific parameters can be defined by creating `PC(){...}`, `XBOX(){...}`, or `PS2(){...}` segments.

# Water Effect
`Effect("Water") { ... }`

| Definition | Description |
| :--- | :--- |
| `PatchDivisions(<int>, <int>)` | Divisions for the water patches. |
| `Tile(<float>, <float>)` | Global texture tiling. |
| `OceanEnable(<int>)` | Enables large waves (used on Kamino). |
| `PhillipsConstant(<float>)` | Phillips spectrum constant for wave calculation. |
| `FoamTexture("<string>")` | Texture used for surface foam. |
| `FoamTile(<float>, <float>)` | Tiling for the foam texture. |
| `WindDirection(<float>, <float>)` | UV direction vector for wind-blown surface effects. |
| `WindSpeed(<float>)` | Wind speed scalar. |
| `WaterRingColor(<int>, <int>, <int>, <int>)` | RGBA color for water rings. |
| `WaterWakeColor(<int>, <int>, <int>, <int>)` | RGBA color for object wakes. |
| `WaterSplashColor(<int>, <int>, <int>, <int>)` | RGBA color for splash effects. |
| `DisableLowRes()` | Disables the low-resolution rendering fallback. |
| `Velocity(<float>, <float>)` | Base UV scroll velocity for the surface. |
| `LODDecimation(<int>)` | Distance-based LOD detail factor. |
| `MainTexture("<string>")` | Primary diffuse texture. |
| `NormalMapTextures("<string>", <int>, <float>)` | Prefix, frame count, and scale for animated normal maps. |
| `BumpMapTextures("<string>", <int>, <float>)` | Prefix, frame count, and scale for animated bump maps. |
| `SpecularMaskTextures("<string>", <int>, <float>)` | Prefix, frame count, and scale for specular highlight masks. |
| `MinDiffuseColor(<int>, <int>, <int>, <int>)` | Minimum RGBA value for the diffuse surface. |
| `MaxDiffuseColor(<int>, <int>, <int>, <int>)` | Maximum RGBA value for the diffuse surface. |
| `BorderDiffuseColor(<int>, <int>, <int>, <int>)` | RGBA value applied to diffuse borders. |
| `LightAzimAndElev(<float>, <float>)` | Light azimuth and elevation for the water shader. |
| `RefractionColor(<int>, <int>, <int>, <int>)` | RGBA color for background refraction. |
| `ReflectionColor(<int>, <int>, <int>, <int>)` | RGBA color for scene reflections. |
| `UnderwaterColor(<int>, <int>, <int>, <int>)` | RGBA color/fog applied when camera is submerged. |
| `FresnelMinMax(<float>, <float>)` | Min/Max values for the Fresnel effect. |
| `SpecularMaskTile(<float>, <float>)` | Tiling for the specular mask. |
| `SpecularMaskScrollSpeed(<float>, <float>)` | UV scroll speed for the specular mask. |
| `SpecularColor(<int>, <int>, <int>, <int>)` | Primary RGBA color for specular highlights. |
| `SpeckleSpecularColor(<int>, <int>, <int>, <int>)` | RGBA specular color for "speckle" micro-waves. |
| `SpeckleAmbientColor(<int>, <int>, <int>, <int>)` | RGBA ambient color for speckles. |
| `SpeckleTextures("<string>", <int>, <float>)` | Prefix, frame count, and scale for speckle textures. |
| `SpeckleTile(<float>, <float>)` | Tiling for speckles. |
| `SpeckleScrollSpeed(<float>, <float>)` | UV scroll speed for speckles. |
| `SpeckleCoordShift(<float>, <float>)` | Coordinate offset for speckles. |
| `SpeckleBlendSpeed(<float>)` | Texture blending speed for speckles. |
| `OscillationEnable(<int>)` | Enables/disables physical geometry oscillation. |
| `FarSceneRange(<float>)` | Clipping range for water in the far scene. |

# Precipitation Effect
`Effect("Precipitation") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) the effect. |
| `Type("<string>")` | Particle type: `"Quads"` or `"Streaks"`. |
| `Texture("<string>")` | Texture used for particles. |
| `ParticleSize(<float>)` | Size of each particle quad/streak. |
| `Color(<int>, <int>, <int>)` | RGB color of the particles. |
| `Range(<float>)` | Spatial radius around the camera for spawning. |
| `Velocity(<float>)` | Vertical speed of falling particles. |
| `VelocityRange(<float>)` | Random variance in particle speed. |
| `ParticleDensity(<float>)` | Amount of particles generated. |
| `ParticleDensityRange(<float>)` | Random variance in spawn density. |
| `CameraCrossVelocityScale(<float>)` | Horizontal streak scale based on camera rotation. |
| `CameraAxialVelocityScale(<float>)` | Forward streak scale based on camera movement. |
| `AlphaMinMax(<float>, <float>)` | Transparency range for particles. |
| `RotationRange(<float>)` | Random rotation intensity. |
| `GroundEffect("<string>")` | Name of the ODF spawned on ground impact (splashes). |
| `GroundEffectSpread(<int>)` | Search radius for finding valid ground collision. |
| `StreakLength(<float>)` | Length of streaks when `Type` is `"Streaks"`. |
| `GroundEffectsPerSec(<int>)` | Spawning rate limit for ground impacts. |

# Lightning Flash Effect
`Effect("Lightning") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) flashes. |
| `Color(<int>, <int>, <int>)` | RGB color of the sky flash. |
| `SunlightFadeFactor(<float>)` | Dimension factor for sun lighting during flash. |
| `SkyDomeDarkenFactor(<float>)` | Darkening factor for the sky dome during flash. |
| `BrightnessMin(<float>)` | Baseline intensity of the flash. |
| `FadeTime(<float>)` | Duration of the flash fade-out. |
| `TimeBetweenFlashesMinMax(<float>, <float>)` | Random range for primary flash timing. |
| `TimeBetweenSubFlashesMinMax(<float>, <float>)` | Random range for rapid rapid sub-flash timing. |
| `NumSubFlashesMinMax(<int>, <int>)` | Range for number of sub-flashes per event. |
| `HorizonAngleMinMax(<int>, <int>)` | Vertical angle range from horizon for light origin. |
| `SoundCrack("<string>")` | Sound property ID for main thunder crack. |
| `SoundSubCrack("<string>")` | Sound property ID for sub-flash crack. |

# Lightning Bolt Effect
`LightningBolt("<string>") { ... }`

| Definition | Description |
| :--- | :--- |
| `Texture("<string>")` | Texture used for bolt geometry. |
| `Width(<float>)` | Width of the main bolt quad. |
| `FadeTime(<float>)` | Persistence duration. |
| `BreakDistance(<float>)` | Distance between joint segments. |
| `TextureSize(<float>)` | UV tiling scale. |
| `SpreadFactor(<float>)` | Random displacement intensity. |
| `MaxBranches(<float>)` | Maximum secondary branches per bolt. |
| `BranchFactor(<float>)` | Likelihood of branching at joints. |
| `BranchSpreadFactor(<int>)` | Displacment intensity for branches. |
| `BranchLength(<float>)` | Total branch length limit. |
| `InterpolationSpeed(<float>)` | Speed of procedural vertex movement. |
| `NumChildren(<int>)` | Tertiary bolt count. |
| `ChildBreakDistance(<float>)` | Segment length for children. |
| `ChildTextureSize(<float>)` | UV scale for children. |
| `ChildWidth(<float>)` | Width of child bolts. |
| `ChildSpreadFactor(<float>)` | Displacement intensity for children. |
| `Color(<int>, <int>, <int>, <int>)` | RGBA color of the main bolt. |
| `ChildColor(<int>, <int>, <int>, <int>)` | RGBA color of child bolts. |

# Blur Effect
`Effect("Blur") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) screen blur. |
| `Mode(<int>)` | Blurring mode index. |
| `MinMaxDepth(<float>, <float>)` | Distance range where blurring starts and stops. |
| `ConstantBlend(<float>)` | Global blend/alpha factor. |
| `DownSizeFactor(<float>)` | Resolution reduction factor (e.g., 0.25). |

# Color Control
`Effect("ColorControl") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) color adjustments. |
| `GammaContrast(<float>)` | Gamma curve adjustment for contrast (affects UI). |
| `GammaBrightness(<float>)` | Gamma curve adjustment for brightness (affects UI). |
| `GammaCorrection(<float>)` | Global gamma correction scalar. |
| `GammaHue(<float>)` | HUD/Global hue shift (neutral at 0.5). |
| `GammaColorBalance(<float>)` | HUD/Global color balance (neutral at 0.5). |
| `WorldContrast(<float>)` | Contrast applied to the 3D scene (excludes interface). |
| `WorldBrightness(<float>)` | Brightness applied to the 3D scene (excludes interface). |
| `WorldSaturation(<float>)` | Saturation applied to the 3D scene (excludes interface). |

Notes:
*   `0.5` is the neutral value for all color controls.
*   Adjusting **Gamma** parameters is performance-free but affects HUD/Interface images.
*   Adjusting **World** parameters is significantly more expensive. Set to `0.5` to disable.

# Bloom Effect (HDR)
`Effect("hdr") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) bloom. |
| `DownSizeFactor(<float>)` | Buffer fraction for bloom (min 0.25). |
| `NumBloomPasses(<int>)` | Blur pass count (higher is more expensive). |
| `GlowThreshold(<float>)` | Luminance threshold for a pixel to begin blooming. |
| `GlowFactor(<float>)` | Dimming scalar for the overall bloom appearance. |
| `MaxTotalWeight(<float>)` | Intensity boost for blooming areas. |

# Godrays Effect
`Effect("Godray") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) godrays. |
| `MaxGodraysInWorld(<int>)` | Global limit for ray instances. |
| `MaxGodraysOnScreen(<int>)` | Limit for rendered rays in camera view. |
| `DustVelocity(<float>, <float>, <float>)` | XYZ drift velocity for ray particles. |
| `MaxViewDistance(<float>)` | Maximum distance rays are visible. |
| `FadeViewDistance(<float>)` | Distance where rays begin to fade. |
| `MaxLength(<float>)` | Maximum procedural ray length. |
| `OffsetAngle(<float>)` | Global angle offset relative to the sun. |
| `MinRaysPerGodray(<int>)` | Minimum sub-rays per ray cluster. |
| `MaxRaysPerGodray(<int>)` | Maximum sub-rays per ray cluster. |
| `RadiusForMaxRays(<float>)` | Spatial radius for ray placement. |
| `Texture("<string>")` | Quad sprite texture. |
| `TextureScale(<float>, <float>)` | UV scaling for the ray texture. |
| `TextureVelocity(<float>, <float>, <float>)` | UV scroll speed for ray animation. |
| `TextureJitterSpeed(<float>)` | Frequency of procedural UV jitter. |

# Fog Effect (Volumes)
`Effect("FogCloud") { ... }`

| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) particle volumes. |
| `Texture("<string>")` | Quad sprite texture for fog. |
| `Range(<float>, <float>)` | Near/Far distance limits for the fog layer. |
| `Color(<int>, <int>, <int>, <int>)` | RGBA color of the particles. |
| `Velocity(<float>, <float>)` | Drift speed for fog quads. |
| `Rotation(<float>)` | Quad spin velocity. |
| `Height(<float>)` | World altitude of the layer. |
| `ParticleSize(<float>)` | Scale of fog quad quads. |
| `ParticleDensity(<float>)` | Quantity of fog quads in the layer. |

# Sun/Lens Flare Effect
`SunFlare() { ... }`
*Note: Can be defined multiple times for multiple suns.*

| Definition | Description |
| :--- | :--- |
| `Angle(<float>, <float>)` | Sun positioning (azimuth, elevation). |
| `Color(<int>, <int>, <int>)` | RGB color of the sun disc and beams. |
| `Size(<float>)` | Scale of the central sun disc. |
| `FlareOutSize(<float>)` | Maximum light beam length. |
| `NumFlareOuts(<int>)` | Beam smoothing factor. High values increase rendering cost. |
| `InitialFlareOutAlpha(<int>)` | Initial beam transparency. |
| `HaloInnerRing(<float>, <int>, <int>, <int>, <int>)` | Radius and RGBA color for the inner halo. |
| `HaloMiddleRing(<float>, <int>, <int>, <int>, <int>)` | Radius and RGBA color for the middle halo. |
| `HaloOutterRing(<float>, <int>, <int>, <int>, <int>)` | Radius and RGBA color for the outer halo. |
| `SpikeColor(<int>, <int>, <int>, <int>)` | RGBA color for solar spikes. |
| `SpikeSize(<float>)` | Length scalar for solar spikes. |

# Post-Processing and Shadows

| Effect Name | Schema | Definition | Description |
| :--- | :--- | :--- | :--- |
| **Motion Blur** | `Effect("MotionBlur")` | `Enable(<int>)` | Enables full-scene motion blurring. |
| **Scope Blur** | `Effect("ScopeBlur")` | `Enable(<int>)` | Enables blur at screen edges while scoped. |
| **World Shadow Map** | `Effect("WorldShadowMap")` | `Enable(<int>)`, `Texture("<string>")`, `LightName("<string>")`, `TextureScale(<float>)`, `AnimationFrequency(<float>)`, `AnimationAmplitude0(<float>, <float>)`, `AnimationAmplitude1(<float>, <float>)` | Projected canopy shadow map (seen on Endor). |
| **World Shadows** | `Effect("Shadow")` | `Enable(<int>)`, `BlurEnable(<int>)`, `Intensity(<float>)` | Global character/blob shadow intensity and softening. |

# Wind Effect
`Effect("Wind") { ... }`
| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) the system. |
| `Velocity(<float>, <float>)` | UV horizontal velocity vector. |
| `VelocityRange(<float>)` | Random variance in speed. |
| `VelocityChangeRate(<float>)` | Frequency of gusts/directional shifts. |

# Space Dust
`Effect("SpaceDust") { ... }`
| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0). |
| `Texture("<string>")` | Quad sprite texture. |
| `SpawnDistance(<float>)` | Radial radius around camera for spawning. |
| `MaxRandomSideOffset(<float>)` | Sideways variance for moving particles. |
| `CenterDeadZoneRadius(<float>)` | Radius in front of camera where dust is culled. |
| `MinParticleScale(<float>)` | Minimum size scalar. |
| `MaxParticleScale(<float>)` | Maximum size scalar. |
| `SpawnDelay(<float>)` | Time between spawn events. |
| `ReferenceSpeed(<float>)` | Speed at which particles look "round" before streaking. |
| `DustParticleSpeed(<float>)` | Scalar for particle travel speed. |
| `SpeedParticleMinLength(<float>)` | Minimum streak elongation limit. |
| `SpeedParticleMaxLength(<float>)` | Maximum streak elongation limit. |
| `ParticleLengthMinSpeed(<float>)` | Threshold speed where elongation begins. |
| `ParticleLengthMaxSpeed(<float>)` | Threshold speed for max elongation. |

# Heat Shimmer
`Effect("HeatShimmer") { ... }`
| Definition | Description |
| :--- | :--- |
| `Enable(<int>)` | Enables (1) or disables (0) screen-space distortion. |
| `WorldHeight(<float>)` | Vertical altitude limit for the effect. |
| `GeometryHeight(<float>)` | Vertical altitude limit for affecting geometry. |
| `ScrollSpeed(<float>)` | Animation scroll rate. |
| `Tessellation(<int>)` | Grid quality for the distortion mesh. |
| `BumpMap("<string>", <float>, <float>)` | Normal texture name and UV tiling. |
| `DistortionScale(<float>)` | Intensity of the distortion shimmer. |

# Loading Constraints
*   **Compilation Requirement:** Worlds utilizing **GodRays** or **Water** MUST have the `.fx` file munged and compiled directly into the world `.lvl` to display correctly.
*   **Post-Load Limitations:** Loading an `.fx` file containing `GodRay` definitions via script *after* the `.wld` is loaded will result in no rays spawning.
*   **Stability Warning:** Loading `Water` definitions post-world loading typically causes game crashes.
*   **Multi-File Usage:** You may load multiple `.fx` files; typically, critical definitions (Water/GodRays) are included in the base world, while environmental effects are loaded via secondary `.fx` files.
