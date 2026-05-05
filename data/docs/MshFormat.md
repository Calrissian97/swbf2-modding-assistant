# MSH File Format
This document explains the chunk-hierarchy of the MSH file format, used as a file format for storing meshes in the Star Wars Battlefront 2 Modtools.

Sections:
 - MSH Chunk Hierarchy Visual Reference (lines 10-68)
 - Munged MSH Animation File Reference (lines 70-91)
 - Online Documentation (lines 92-93)

 ---

# Visual Hierarchy Reference
```text
HEDR (Root File Header)
├── SHVO (Has-Shadowvolume Flag)
├── MSH2 (Format Specifier)
|    ├── SINF (Scene Information)
|    |   ├── NAME (Scene Identifier)
|    |   ├── FRAM (Keyframe Range, Framerate)
|    |   └── BBOX (Scene Bounding Box)
|    ├── MATL (Material List)
|    │   └── MATD (Material Definition; One or more)
|    │       ├── NAME (Material Identifier)
|    │       ├── DATA (Diffuse, Ambient, Specular colors, specular exponent)
|    │       ├── ATRB (Rendering Flags, Rendertypes, Data0 byte, Data1 byte)
|    |       ├── TX0D (Diffuse Texture)
|    |       ├── TX1D (Optional Texture Chunk; Typically Normalmap/Bumpmap)
|    |       ├── TX2D (Optional Texture Chunk; Typically Detailmap/Lightmap)
|    │       └── TX3D (Optional Texture Chunk; Typically Envmap/Cubemap)
|    └── MODL (Model Node / Object; One or more)
|        ├── NAME (Node Identifier)
|        ├── MTYP (Model Type)
|        ├── MNDX (Model Index)
|        ├── PRNT (Parent Node Identifier)
|        ├── FLGS (Visibility Flag)
|        ├── TRAN (Translation, Rotation, and Scale Transforms)
|        ├── GEOM (Geometry Header)
|        |   ├── BBOX (Geometry Bounding Box)
|        │   ├── SEGM (Segment of Polygons)
|        |   |   ├── SHDW (Shadow Mesh Geometry Data; Optional)
|        │   |   ├── MATI (Material Index)
|        │   |   ├── POSL (Vertex Positions)
|        |   |   ├── CLRL (Color List)
|        │   |   ├── CLRB (Color Block)
|        │   |   ├── WGHT (Skinning Weights)
|        │   |   ├── NRML (Vertex Normals)
|        │   |   ├── UV0L (UV Coordinates)
|        │   |   ├── NDXL (Quad Indices)
|        │   |   ├── NDXT (Triangle Indices)
|        │   |   └── STRP (Triangle Strips)
|        |   ├── CLTH (Cloth Data; Optional)
|        |   |   ├── CTEX (Diffuse Texture of Cloth Mesh)
|        |   |   ├── CPOS (Cloth Vertex Positions)
|        |   |   ├── CUV0 (Cloth UVs)
|        |   |   ├── FIDX (Fixed Point Indices)
|        |   |   ├── FWGT (Cloth Vertex Weights)
|        |   |   ├── CMSH (Cloth Polygon Indices)
|        |   |   ├── SPRS (Cloth Spring-Constraints)
|        |   |   ├── CPRS (Cloth Cross-Constraints)
|        |   |   ├── BPRS (Cloth Bend-Constraints)
|        |   |   └── COLL (List of Cloth Collision Primitives)
|        |   └── ENVL (Envelope Data; Optional)
|        └── SWCI (Collision Primitive; Optional)
├── BLN2 (Bone Blending Factors; Optional)
├── SKL2 (Skeleton Data; Optional)
└── ANM2 (Animation Header; Optional)
|   ├── CYCL (Animation Cycle Data; Optional)
|   └── KFR3 (Keyframe Data; Optional)
└── CL1L (Closing Chunk; Indicates End Of File.)
```

# Munged MSH Animation Related (`.zaafbin`, `.zaabin`)
| Chunk | Description | Notes |
| :--- | :--- | :--- |
| **ZAFF** | Header | Root of munged animation file |
| **2HSM** | MSH Start Block | |
| **LDOM** | Joint/Model Block | Joint start block / Model block |
| **PYTM** | Model Type Block | Node type identifier |
| **EMAN** | Name | Node identifier |
| **TNRP** | Parent Block | Parent relationship |
| **NART** | Local Transform | |
| **2HSM** | Model Block | Left-handed version |
| **1HSM** | Model Block | Right-handed (Unsupported version) |
| **LEKS** | Skeleton | Standard skeleton block |
| **2LKS** | Skeleton | Alternative skeleton block |
| **DNLB** | Blend Factors | Skeleton blend factors? |
| **MINA** | Animation | Animation data |
| **2MNA** | Animation | Animation data |
| **TESM** | Material Set | Outdated material set |
| **LCYC** | Animation Cycle | |
| **2RFK** | Keyframes | Nodeanim keyframes (pos + quat format) |
| **3RFK** | Keyframes | Unknown/Reserved |
| **MRFK** | Keyframes | pos + angaxis format (Not supported) |

# Online Docs
Helpful information on the `.msh` format can be found here: https://schlechtwetterfront.github.io/ze_filetypes/msh.html#overview.
