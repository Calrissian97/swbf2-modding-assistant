# Combo File Format Reference
This document defines the format and available commands for combo animation files used in Battlefront 2. These files control weapon behaviors, animations, state transitions, and attack parameters for units (typically Jedi/Sith).

Sections:
- Remapping Reload Button (lines 17-31)
- Animation Block (lines 33-65)
- State Block (lines 67-107)
- AnimatedMove Block (lines 109-117)
- Attack Block (lines 119-130)
- Deflect Block (lines 132-139)
- Transition Block (lines 141-146)
- Conditions within If/Or Block (lines 148-165)
- Full Example State (lines 167-226)

---

# `RemapReloadButton("<button>")`
Since the reload button is generally unused by combo weapons, this allows it to be remapped for the soldier.

*   **`<button>`**: String parameter. Valid values:
    *   `"Fire"`: Primary fire button.
    *   `"FireSecondary"`: Secondary fire button.
    *   `"Jump"`: Jump button.
    *   `"Sprint"`: Sprint button.
    *   `"Crouch"`: Crouch button.
    *   `"Reload"`, `"None"`: Do not remap the button.

**Example:**
```cpp
RemapReloadButton("FireSecondary"); // remap to FireSecondary to use the second trigger for custom purposes
```

# `Animation("<animname>")` Block
Defines or forward-declares a combo animation. Combo animations often need to be defined ahead of time to be referenced later.

*   **`<animname>`**: String parameter. Does not include a bank name (e.g., use `stand_attack1a` instead of `human_sabre_stand_attack1a`). May optionally exclude the scope (`_upper` or `_lower`), in which case both scopes are affected.
*   **Scope `{}`**: Optional. Contains animation data (similar to a `.sanm` file). If omitted, the tag acts as a forward declaration.

## Commands within an Animation Block

| Command | Description | Parameters |
| :--- | :--- | :--- |
| `Loop([bLoop])` | Sets whether the animation loops. | `[bLoop]`: Optional. `0`, `1` (default), or `"FinalFrame"` (loops only the last frame). |
| `AimType("<aimtype>")` | Sets aiming behavior (only used by `_upper` scope). | `<aimtype>`: `"None"` (move dir), `"Head"` (look aim), `"Torso"` (turn aim), `"FullBody"` (aim dir overrides walk/run). |
| `SyncType("<name>"[, "ByTime"])` | Sets the sync class. Transitions between same classes will frame-sync. | `<name>`: Any string. `"ByTime"`: Sync to same time instead of length ratio. |
| `BlendInTime(<time>[, unit])` | Sets blend in duration. | `<time>`: `0.00 - 2.55`. `unit`: `"Seconds"` (default) or `"Frames"`. |
| `BlendOutTime(<time>[, unit])` | Sets blend out duration. | `<time>`: `0.00 - 2.55`. `unit`: `"Seconds"` (default) or `"Frames"`. |
| `BlendTimeTo("<anim>", <time>[, unit])` | Sets specific blend time to another animation. | `<anim>`: String. `<time>`: `0.00 - 2.55`. `unit`: `"Seconds"` (default) or `"Frames"`. |
| `LowResPose(<time>[, unit])` | Reduces anim to a single pose at `<time>` for low-res models. | `<time>`: `0.00 - 2.55`. `unit`: `"Seconds"` (default) or `"Frames"`. Only for attack/block. |

**Example:**
```cpp
Animation("stand_attack1a_end"); // Forward declaration

Animation("stand_attack1a")
{
    Loop();
    AimType("FullBody");
    SyncType("forward");
    BlendInTime(0.15);
    BlendOutTime(0.15);
    BlendTimeTo("stand_attack1a_end", 0.00);
    LowResPose(5, "Frames");
}
```

# `State("<statename>")` Block
Defines a state in the combo logic. All combos **must** define an initial state called `"IDLE"`.

*   **`<statename>`**: String used to reference this state in transitions.
*   **Scope `{}`**: Required.

## Basic State Control

| Command | Description |
| :--- | :--- |
| `RestartAnimation()` | Restarts the animation if transitioning from the same one. |
| `PlayExplosion()` | Plays the `WeaponMelee` explosion if defined in the ODF. |
| `MustShowOneFrame()` | Prevents exiting the state until at least one frame is rendered. |
| `Duration(<time>[, mode])` | Sets state duration. `<time>`: `0.00 - 10.22` (`0.0` is infinite, `-1` uses anim duration). `mode`: `"Seconds"` (default), `"Frames"`, or `"FromAnim"` (percentage). |
| `Animation("<name>")` | Sets the animation for the state. Also defines it if followed by `{}`. |
| `Sound("<name>"[, <time>][, unit])` | Plays `<name>` at `<time>` offset. `<time>`: `0.00 - 10.23`. `unit`: `"Seconds"` (default) or `"Frames"`. |
| `AlignedToThrust([mode])` | Aligns aim/thrust velocity to stick direction. `[mode]`: `0`, `1` (default), or `"Initial"`. |
| `Gravity(<gravity>)` | Sets gravity in g's. Value: `-12.7 - 12.7`. Default: `1.0`. |
| `GravityVelocityTarget(<vel>[, "Impulse"][, "ZeroGravity"])` | Sets Y-velocity condition for gravity. `<vel>`: `-204.7 - 204.7`. `"Impulse"`: instant accel. `"ZeroGravity"`: reset to 0.0 once met. |
| `EnergyRestoreRate(<rate>[, "FromSoldier"])` | Energy per second: `-102.2 - 102.2`. `"FromSoldier"`: offset from normal rate. |
| `TurnOffLightsaber([weapon#], ...)` | Turns off specified sabers ([0-3]). If no index specified, all turn off. |


## Input and Movement Control

### `InputLock([<duration>[, unit]][, "<control>"], ...)`
Locks controls from the soldier.
*   **`[duration]`**: `0.00 - 10.23`. `0.0` or negative means entire state.
*   **`unit`**: `"Seconds"` (default) or `"Frames"`.
*   **`[control]`**: `"All"` (default), `"Thrust"`, `"Fire"`, `"FireSecondary"`, `"Jump"`, `"Sprint"`, `"Crouch"`, `"Reload"`. Prefix with `!` to exclude (e.g., `InputLock(0.0, "All", "!Thrust")`).

### Factors
Multipliers applied to controls (Range: `0.00 - 12.75`, Default: `1.0`).
*   `ThrustFactor(<f>)`
*   `StrafeFactor(<f>)`
*   `TurnFactor(<f>)`
*   `PitchFactor(<f>)`

### `Posture("<posture>", ...)`
Forces/allowed postures. Aborts to `IDLE` if impossible.
*   **`<posture>`**: `"All"`, `"Stand"`, `"Crouch"`, `"Prone"`, `"Sprint"`, `"Jump"`, `"RollRight"`, `"RollLeft"`, `"Jet"`, `"Roll"`. Prefix with `!` to exclude.

# `AnimatedMove([set])` Block
Enables animation-driven velocity.
*   **`[set]`**: `0`, `1` (default).
*   **Commands within scope**:
    *   `VelocityZ(<v>[, "FromAnim"])`: Z velocity (m/s: `-40.96 - 40.94`). `"FromAnim"` makes `<v>` a multiplier.
    *   `VelocityX(<v>[, "FromAnim"])`: X velocity (m/s: `-40.96 - 40.94`). `"FromAnim"` makes `<v>` a multiplier.
    *   `VelocityFromThrust(<v>)`: Thrust dependent velocity (`0.00 - 12.75` m/s).
    *   `VelocityFromStrafe(<v>)`: Strafe dependent velocity (`0.00 - 12.75` m/s).
    *   `Until()` Block: Required. Defines conditions to break out of the move. Uses `Transition::If/Or` logic.

# `Attack()` Block
Defines damage parameters. Multiple blocks allowed per state.

| Command | Description | Parameters |
| :--- | :--- | :--- |
| `AttackId("<id>")` | Groups attacks to avoid double damage. | `<id>`: Arbitrary string. |
| `Edge(<index>)` | Attaches damage to a weapon blade index. | `<index>`: `0` to `numedges-1`. |
| `DamageTime(<t0>, <t1>[, mode])` | Time range for applying damage. | `<t0>, <t1>`: Numeric. `mode`: `"Seconds"`, `"Frames"`, or `"FromAnim"`. |
| `Damage([damage])` | Health units to inflict. | `<damage>`: `0 - 4094` or `"Default"` (ODF value). |
| `Push(<strength>) | Meters per second push effect. | `<strength>`: `0.0 - 25.5`. |
| `DamageLength(<len>[, mode])` | Ray length for damage detection. | `<len>`: `0.0 - 10.23`. `mode`: `"FromEdge"` (multiplier) or absolute meters. |
| `DamageWidth(<wid>[, mode])` | Ray width for damage detection. | `<wid>`: `0.0 - 2.55`. `mode`: `"FromEdge"` (multiplier) or absolute meters. |

# `Deflect()` Block
Enables ordnance deflection. Only one block per state.

| Command | Description | Parameters |
| :--- | :--- | :--- |
| `DeflectAngle(<min>, <max>)` | Angular range in XZ plane for deflection. | `<min>, <max>`: Degrees (`-180 - 180`). |
| `EnergyCost(<energy>)` | Energy cost per deflected attack. | `<energy>`: `0.0 - 102.3`. |
| `DeflectAnimation("<name>", ...)` | Poses for deflection directions. | `<name>`: Animation. Directions: `"Forward"`, `"Right"`, `"BackRight"`, `"Left"`, `"BackLeft"`, `"Back"`, `"All"`. `"Offhand"` uses left hand. |

# `Transition("<statename>")` Block
Defines a transition to another state. If omitted, defaults to unconditional transition to `IDLE` after duration.

*   **`<statename>`**: Target state.
*   **`EnergyCost(<energy>)`**: Energy required/consumed.
*   **`If()` / `Or()` Block**: Required for conditional transitions. All conditions in an `If()` must be met.

# Conditions within If/Or Scope
| Condition | Description | Parameters |
| :--- | :--- | :--- |
| `Break([time][, unit])` | Break state duration immediately. | `[time]`: `0.00 - 5.11`. `unit`: `"Seconds"` (default) or `"Frames"`. |
| `TimeStart(<t>[, mode][, unit])` | Range to check button events. | `<t>`: `-5.12 - 5.11`. `mode`: `"FromEnd"` (offset). `unit`: `"Seconds"` or `"Frames"`. |
| `TimeEnd(<t>[, mode][, unit])` | Range to stop checking events. | `<t>`: `-5.12 - 5.11`. `mode`: `"FromEnd"`. `unit`: `"Seconds"` or `"Frames"`. |
| `Button("<btn>"[, "<act>"])` | Checks for a button event. | `<btn>`: `"Fire"`, `"FireSecondary"`, `"Jump"`, `"Sprint"`, `"Crouch"`, `"Reload"`, `"FireBoth"`. `<act>`: `"Tap"` (default), `"DoubleTap"`, `"Hold"`, `"Down"`. |
| `ButtonsPressed("<btn>", ...)` | Checks if buttons are pressed. | Does not consume event. Values: `<btn>` names, `"All"`, `"Any"`, or `!<btn>`. |
| `ButtonsReleased("<btn>", ...)` | Checks if buttons are released. | Does not consume event. Values: same as `ButtonsPressed`. |
| `Posture("<p>", ...)` | Soldier posture condition. | Values: `"All"`, `"Stand"`, `"Crouch"`, `"Prone"`, `"Sprint"`, `"Jump"`, `"RollRight"`, `"RollLeft"`, `"Jet"`, `"Roll"`. |
| `TimeInPosture(op, <t>[, unit])` | Timer for current posture. | `op`: `">"` or `"<"`. `<t>`: `0.00 - 20.47`. `unit`: `"Seconds"` or `"Frames"`. |
| `Energy(op, <val>)` | Soldier energy requirement. | `op`: `">"` or `"<"`. `<val>`: `0.0 - 102.3`. |
| `Thrust(op, <val>)` | Thrust stick magnitude. | `op`: `">"` or `"<"`. `<val>`: `0.00 - 1.00`. |
| `ThrustAngle(<min>, <max>)` | Thrust angle requirement. | `0` (Fwd), `90` (L), `-90` (R), `180` (Back). Range: `-360 - 360`. |
| `VelocityXZ(op, <v>)` | Horizontal speed (m/s). | `op`: `">"` or `"<"`. `<v>`: `0.00 - 20.47`. |
| `VelocityXZAngle(<min>, <max>)` | Horizontal velocity angle. | Range: `-360 - 360`. |
| `VelocityYAbs(op, <v>)` | Vertical speed magnitude (m/s). | `op`: `">"` or `"<"`. `<v>`: `0.00 - 15.75`. |
| `VelocityY(op, <v>)` | Vertical velocity with sign (m/s). | `op`: `">"` or `"<"`. `<v>`: `-16.0 - 15.5`. |

# Full Example State
```cpp
State("ATTACK1")
{
    RestartAnimation();
    PlayExplosion();
    MustShowOneFrame();
    Duration(-1);
    Animation("stand_attack1a");
    Sound("imp_weap_lightsabre", 0.00);
    
    AnimatedMove()
    {
        VelocityZ(1.0, "FromAnim");
        VelocityX(1.0, "FromAnim");
        VelocityFromThrust(0.0);
        VelocityFromStrafe(0.0);
        Until()
        {
            Break(0.2);
            Thrust(">", 0.5477);
        }
    }

    Posture("Stand");
    EnergyRestoreRate(0.0);

    Attack()
    {
        AttackId("attack1");
        Edge(0);
        DamageTime(2, 5, "Frames");
        Damage(200);
        Push(0.0);
        DamageLength(1.0, "FromEdge");
        DamageWidth(1.0, "FromEdge");
    }

    Deflect()
    {
        EnergyCost(0.0);
        DeflectAnimation("stand_block_front1", "Forward");
        DeflectAnimation("stand_block_right1", "Right");
        DeflectAnimation("stand_block_left1", "Left");
    }

    Transition("ATTACK2")
    {
        If()
        {
            TimeStart(-1.0);
            TimeEnd(0.15);
            Button("Fire");
            ButtonsPressed("All", "!Reload");
            ButtonsReleased("Fire");
            Posture("Stand");
        }
    }
}
```
