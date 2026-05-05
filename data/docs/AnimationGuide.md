# Animation Guide
This document explains the Star Wars Battlefront 2 animation system. SWBF utilizes a "munge" process to convert 3D mesh data into compressed binary formats. The pipeline typically involves exporting animations from 3D software (like Softimage/XSI or Blender) as `.msh` files. These are then processed by `ZenAsset.exe` for initial munging and `BinMunge.exe` for final compilation into the game's native formats.

Sections:
- Animation Hierarchy and Inheritance (lines 15-108)
- Animation Categories (lines 110-175)
- Animation Banks (lines 177-191)
- Animation Creation (lines 193-213)
- Low Resolution Animations (lines 215-222)
- First Person Animations (lines 224-228)
- ODF Animation Parameters Reference (lines 230-253)

---

# Animation Hierarchy and Inheritance
The Soldier Animation System organizes animations through a strict hierarchy of characters, weapons, and postures.

## Visual Hierarchy of Animation Banks
**Character Animations**
```text
Human (0-1; Rifle, 2; Bazooka, 3; Pistol, Tool, 4; Misc.)
├── Bdroid
├── Bothanspy
├── Chewbacca (Skeleton-Only)
├── Clonecommander
├── Deathstarleia (Skeleton-Only)
├── Ewok
├── Fett
├── Geo (Skeleton-Only)
├── Geowings (Skeleton-Only)
├── Gungan (Skeleton-Only)
├── Hansolo
├── Ig88 (Skeleton-Only)
├── Impofficer
├── Jawa (Skeleton-Only)
├── Magnaguard
├── Marksperson (Skeleton-Only)
├── Nabooqueen (Skeleton-Only)
├── Sbdroid
├── Wookie (Skeleton-Only)
├── Wookiewarrior (Skeleton-Only)
├── Human_Sabre (Melee)
|   ├── Aalya
|   ├── Acklay
|   ├── Dooku
|   ├── Ep3Obiwan
|   ├── Gam
|   ├── Grevious
|   ├── KiAdiMundi
|   ├── Mace_Windu
|   ├── Maul
|   ├── Sidious
|   ├── Vader
|   ├── Wampa
|   └── Yoda
└── Humanlz (Low-res)
    ├── Acklaylz
    ├── Bdroidlz (Skeleton-Only)
    ├── Ewoklz (Skeleton-Only)
    ├── Gamlz
    ├── Geolz (Skeleton-Only)
    ├── Greviouslz
    ├── Jawalz (Skeleton-Only)
    ├── Leialz (Skeleton-Only)
    ├── Magnaguardlz (Skeleton-Only)
    ├── Sbdroidlz (Skeleton-Only)
    ├── Sidiouslz
    ├── Vaderlz (Skeleton-Only)
    ├── Wampalz (Skeleton-Only)
    ├── Wookielz (Skeleton-Only)
    └── Yodalz (Skeleton-Only)
```

## 1. Character Hierarchy
Soldier animations are organized at the top level by character types.

| Type | Description |
| :--- | :--- |
| **human** | The root character type. All other types inherit from this by default. |
| **[custom]** | Examples: `bdroid`, `ewok`. These use custom skeletons and can override movement/action animations regardless of weapon. Defined via `SkeletonName` or `AnimationName` in soldier ODFs. |

## 2. Weapon Hierarchy
Animations are further categorized by weapon types. Custom weapons must specify a standard type or previously defined custom type as their parent.

| Weapon Type | Parent Type | Supports Alert States |
| :--- | :--- | :--- |
| **rifle** | Root | Yes |
| **bazooka** | rifle | No (always alert) |
| **tool** | rifle | Yes |
| **pistol** | tool | Yes |
| **grenade** | tool | Yes |
| **melee** | tool | No (always alert) |
| **[custom]** | Varies | Varies |

## 3. Postures & Scopes
*   **Postures:** `stand`, `crouch`, `prone`, `standalert`, `crouchalert`, `pronealert`. Alert postures occur for a few seconds after shooting to prevent animation "popping."
*   **Scopes:**
    *   `upper`: Animates top half (standard for weapon actions).
    *   `lower`: Animates bottom half (standard for turning).
    *   `full`: Animates the entire soldier.

## 4. Animation Parameters
| Parameter | Description |
| :--- | :--- |
| **Loop** | Whether the animation repeats. |
| **Blend Time** | Duration (seconds) to transition into the animation. |
| **Scope** | Which body parts are affected (defaults vary by type). |
*Note: Loop and blend times for standard animations are hardcoded in the engine (defined in SoldierAnimation.SANM).*

# Animation Categories
## Weapon Animations
**Actions:** `shoot`, `shoot2`, `shoot_secondary`, `shoot_secondary2`, `charge`, `reload`.
**Naming Convention:** `<character>_<weapon>_<posture>_<anim>[_<scope>]` (e.g., `human_bazooka_stand_reload`).

*   **Properties:**
    *   **Loop:** False.
    *   **Scope:** Defaults to `upper`.
    *   **Blend Time:** 0.02s for `shoot*`, 0.5s for others.
*   **Inheritance Rules (in order):**
    1.  `<character_parent>_<weapon>_<posture>_<anim>`
    2.  For `shoot*` anims: Inherit from other shoot indices (e.g., `shoot2` -> `shoot`).
    3.  For `crouch`: Inherit from `stand` posture version.
    4.  `<character>_<weapon_parent>_<posture>_<anim>`
    
*Note: Inheritance is resolved character-by-character. All `human_*` animations are resolved before a custom character (like `bdroid`) attempts to inherit from them.*

## Movement Animations
**Actions:** `idle_emote`, `idle_checkweapon`, `idle_lookaround`, `turnleft`, `turnright`, `walkforward`, `runforward`, `walkbackward`, `runbackward`, `walkright`, `runright`, `walkleft`, `runleft`.

Movement animations cover turning and walking. If both walk and run are defined for left/right, the character sidesteps instead of twisting. 

*   **Properties:**
    *   **Loop:** True (except `turn*`).
    *   **Scope:** Defaults to `full` for human_rifle_*, `lower` for `turn*`, `upper` for others.
    *   **Blend Time:** 0.4s for prone, 0.15s for others.
*   **Inheritance Rules (in order):**
    0.  If weapon doesn't support alert: Copy results from non-alert posture.
    1.  `<character>_<weapon_parent>_<posture>_<anim>`. For alert postures, it skips parents that do not support alert states.
    2.  `<character_parent>_<weapon>_<posture>_<anim>`.
    3.  `<character>_<weapon>_<nonalert_posture>_<anim>`.
    4.  For `idle` / `turn`: Inherit from `idle_emote`, then `stand_idle_emote`.

## Action Animations
**Actions:** `sprint`, `jump`, `jump_up/forward/etc`, `landsoft`, `landhard`, `fall`, `thrown_*`, `diveforward`, `jetpack_hover`, `stand_getup*`, `stand_getdown_prone`, `crouch_getdown_prone`, `prone_getup_*`, `stand_death_*`.

*   **Properties:**
    *   **Loop:** True for `thrown_flail`, `thrown_tumble*`, `jetpack_hover`. False for others.
    *   **Scope:** Defaults to `full` for human_rifle_*, `upper` for others.
    *   **Blend Time:** 
        *   0.8s: `fall`
        *   0.5s: `thrown_flail`
        *   0.4s: `jump*`, `thrown_land*`
        *   0.1s: `thrown_tumble*`, `thrown_bounce*`
        *   0.05s: `landsoft`, `landhard`
        *   0.15s: All others.
*   **Inheritance Rules (in order):**
    1.  `<character>_<weapon_parent>_<anim>`.
    2.  `<character_parent>_<weapon>_<anim>`.
    *   *Special Cases:* `jump_*` inherits from `jump`, `sprint` from `stand_runforward`, and `jetpack_hover` from `jump`.
    *   All final action animations must be defined for the `full` body scope.

## Combo Animations
Controlled via **Combo Files** (`.combo`). These define their own blend times, looping, and FSM (Finite State Machine) logic.

## Custom Animations
Used for vehicle piloting or specific triggers (e.g., Sarlacc).
**Naming Convention:** `<character>_<weapon>_<anim>` or `<character>_<anim>`.

*   **Properties:**
    *   Always **full body**.
    *   No loop or blend support.
*   **Inheritance Rules (in order):**
    0.  `<character>_<weapon_parent>_<anim>`.
    1.  `<character>_<anim>` (No weapon).
    2.  `<character_parent>_<weapon>_<anim>`.

# Animation Banks
Banks are expected to be named either <character> or <character>_<weapon>. Any bank may additionally be broken into multiple parts in order to deal with the size limitation imposed by the in game loader. The resulting parts must be named with an appended '_0', '_1', and so on. human.zaabin, for instance, is split into human_0 through human_4. ODF properties AnimationName and SkeletonName are synonyms, and can be set like so in soldier ODFs: `AnimationName = "<animBank> <parentAnimBank>"` or for units with melee weapons a combo variant can be defined: `ComboAnimationBank = "<animBank> <weapon> <comboFile>"`. Weapon ODFs can have their banks specified like so: `AnimationBank = "<weapon>"`.

### Size Limitations
Due to engine loading limits, large banks like `human` are split into parts (`human_0.zaabin` through `human_4.zaabin`). Only the skeleton (`.zafbin`) associated with the `_0` part is strictly required at load time.

## Output Formats
*   **.zaabin**: Contains the actual keyframe and transformation data.
*   **.zafbin**: Contains the skeleton/bone hierarchy definition.
*   **.anims**: A text format (utfc) list of all animations contained within the companion `.zaabin` files.
*   **SoldierAnimation.SANM**: A configuration file (found in `Data/Common/config/`) that controls looping, blending, and properties for standard high-res soldier animations.

## Animation Naming
Animations are named based on the `.msh` filename used during the munge process. By convention, the skeleton is defined in a `basepose.msh`, while individual animations (like `walk`, `run`, `idle`) are exported as separate msh files. Appending `_upper` or `_lower` ensures only the upper or lower half of the animation will affect the unit, with the rest affected by parent animation sets.
Banks should only contain animations starting with the bank name (e.g., `bdroid.zaabin` should only contain `bdroid_*` animations).

# Animation Creation
## What to keyframe
Only the bones within the defined skeleton hierarchy should be keyframed (named objects starting with `bone`), never roots, effs, or hardpoints. For `basepose.msh` files, it is standard practice to provide a two-frame sequence (0-1) to establish the resting state of the skeleton. Only keyframe rotations primarily and translations as needed, never scaling.

## How to interpolate
The engine generally handles linear interpolation between keyframes. To ensure smooth playback in-game, ensure that loops (like walk cycles) have matching start and end frames to avoid "hitching".

## Creating Unit Animations
Unit animations are stored in `SoldierAnimationBank` folders. These are highly dependent on the specific skeleton used by the unit (e.g., `human`, `sbdroid`, `droideka`). Do *not* animate the mesh itself, roots, or effectors in the skeleton, only the bones themselves, or the parent traversal bone. Bones should be in a hierarchy, as children of the mesh. If a traversal bone is used (typically called "dummyroot"), be sure to have a world bone (typically called "grounddummy") as the top-most parent to offset animation starting-points in the world. The "grounddummy" world bone should *not* be transformed from the origin. The "dummyroot" traversal bone must have only two keyframes: one at the beginning and one at the end of the animation.

### Unit Skeletons
High-resolution models and low-resolution (lz) models often use different skeletons; `humanlz` animations use a simplified bone set to save memory. Aside from bones, skeletons also contain "hardpoints" that are typically nulls named "hp_..." that act as reference points for placing weapons, events, etc. The most common hardpoint is "hp_weapons" which is what weapons will be constrained to on unit models. Weapons may have a matching "hp_active" hardpoint which is what will constrain to "hp_weapons" on the unit with the weapon, otherwise the weapon model will be constrained at it's origin to "hp_weapons".

## Creating Vehicle Animations
Vehicle animations sometimes include 9-pose animations for hovers, several walk cycles for walkers, and a takeoff animation to be played forwards when taking off and played backwards when landing for flyers.

### Vehicle Skeletons
Vehicle skeletons are typically simpler than unit skeletons but must include hardpoints (`hp_`) for weapon fire, engine effects, and entry points.

## Creating Prop Animations
Prop animations are used for environment objects like doors, elevators, or moving platforms. These are defined as `animatedprop` or `door` ClassLabels in ODF files. They often use `AnimationTrigger` properties to play sequences based on unit proximity to a named hardpoint in the msh.

# Soldier Low Resolution Animation System
Low-res (lz) animations are used for units at a distance to save memory. 
*   **Characters:** `humanlz` is the root. Custom types like `bdroidlz` inherit from `humanlz` by default.
*   **Properties:** Most are single-frame shared poses. 
*   **Pools:** 
    *   **Run:** Uses a pool of 3 looping animators. If more than 3 `humanlz` units are running, they begin to share poses.
    *   **Death:** Uses a pool of 8 non-looping animators. If more than 8 are dying, the oldest animator is stolen for the newest death.
*   **Custom Anims:** Must be named `[bank]_ride_stap` or `[bank]_rifle_ride_stap`. Alternate weapon support is limited.

# Soldier First Person Animation System
First person (fp) animations are grouped by character type (e.g., `humanfp`, `droidekafp`).
*   **Weapons:** Standard types (`rifle`, `bazooka`, `tool`, `grenade`) are supported; custom weapon types are not supported in first person.
*   **Animations:** `idle`, `run`, `shoot`, `shoot2`, `charge`, `reload`, `repair`, `jump`, `flail`, `handsdown`.
*   **Logic:** Loaded via a hardcoded table. Missing animations default to `humanfp_tool_idle`.

# ODF Property Reference
### Soldier ODFs
| Property | Description |
| :--- | :--- |
| `AnimationName` | `"<char> [<parent>]"` - Specifies skeleton and character hierarchy. |
| `SkeletonName` | Synonym for `AnimationName`. Defaults to `human`. |
| `AnimationLowRes` | `"<char>"` - Specifies custom low-res bank. Defaults to `humanlz`. |
| `SkeletonLowRes` | Synonym for `AnimationLowRes`. |

### Weapon ODFs
| Property | Description |
| :--- | :--- |
| `AnimationBank` | `"[<char>_]<weapon>"` - Specifies the weapon type. Character prefix is ignored at runtime as it uses the wielder's type. |
| `CustomAnimationBank`| `"[<char>_]<weapon> <parent> [alert/noalert]"` - Defines a new weapon type in the hierarchy and alert support. |
| `ComboAnimationBank` | `"[<char>_]<weapon> <parent> <combofile>"` - Defines a melee weapon using a `.combo` FSM. |

### Other/Controllable ODFs
| Property | Description |
| :--- | :--- |
| `AnimationName` | `"<bankname>"` - Specifies a skeleton and bank for a general object. |
| `...Animation` | `"<animname>"` - Specifies a specific animation within a loaded bank. |
| `PilotAnimation` | `"<animname>"` - Generates a requirement for `human_<animname>`. |
| `SoldierAnimation` | `"<animname>"` - Used by Ordnace/AreaEffects; requires `human_<animname>`. |
| `AttachTrigger` | `"<name> <...> <anim> <soldier_anim>"` - Used by props to trigger soldier animations. |
