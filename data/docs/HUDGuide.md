# HUD Configuration Documentation
This document explains how the Heads-Up-Display (HUD) system works in Star Wars Battlefront 2.

Sections:
- Viewports For Splitscreen (lines 24-64)
- Shared Element Properties (lines 66-91)
- Text Elements (lines 93-122)
- Bitmap Elements (lines 124-150)
- 3D Model Elements (lines 152-251)
- Bordered Boxes (lines 253-270)
- Multiline Text (lines 272-303)
- Bar Bitmap (lines 305-326)
- Segmented Bar (lines 328-356)
- Procedural Bar Bitmap (lines 358-393)
- Minimap (lines 395-609)
- Vehicle Seating (lines 611-647)
- Viewport (lines 649-750)
- HUD-Triggered Sounds (lines 752-762)
- In-Game HUD Editor (lines 764-787)
- HUD Events Reference (lines 789-875)

---

# Supported Viewports
The first item of a HUD configuration file should specify information about the file like the filename and which split-screen modes the HUD supports.

*   **FileInfo(filename)**: `filename` is the name of the file you want the editor to write out.
*   **SplitMode(mode0, mode1)**: `mode` is either `"Horizontal"` (top/bottom split screen) or `"Vertical"` (side by side split screen). Only Xbox supports the `"Vertical"` mode with two viewports.
*   **Widescreen(enable)**: When set to 1, the file will only be loaded when widescreen is enabled; set to 0 to load the file when widescreen isn't enabled.

## Examples

**Vertical two-player split screen:**
```hud
SplitMode("Vertical")
Viewports(2)
```

**Vertical or horizontal split screen with 2 or 4 players:**
```hud
SplitMode("Vertical", "Horizontal")
Viewports(2, 4)
```

The second item of a HUD configuration file should always specify the number of viewports (players) the HUD supports.

`Viewports(numViewports0, numViewports1, numViewportsN)`

**Example: `reticuledisplay.hud`**
```hud
FileInfo("reticuledisplay")
{
    Viewports(1, 2, 4)
    SplitMode("Vertical", "Horizontal")
}
```

**Example: Tooltips (Single Viewport Only)**
```hud
FileInfo("tooltips")
{
    Viewports(1)
}
```

# Common Properties Across All Elements
All HUD elements have the following properties...

*   **Position(x, y, z, rel)**: Position of the group (positive Z is into the screen). If `rel` is set, coordinates are relative to the screen's width/height. Values for `rel`:
    *   `"Pixels"`: X, Y pixel values.
    *   `"Viewport"`: X, Y relative to the element's viewport.
    *   `"Frame"`: X, Y relative to the element's container group.
    *   `"Screen"`: X, Y relative to the screen.
*   **Rotation(x, y, z)**: Rotation of the element about the X, Y, and Z axes in degrees.
*   **Scale(x, y, z)**: Scales the model (greater than 1 is larger).
*   **ZOrder(zorder)**: Sorting order (0 is front, 255 is back).
*   **Alpha(alpha)**: Transparency (0.0 to 1.0).
*   **Color(r, g, b)**: Color of the element (0-255 for each channel).
*   **ColorChange(r, g, b)**: Color when it receives the change event.
*   **ColorChangeRate(rate)**: Rate of interpolation (0 stops, 1 is immediate).
*   **ColorPulseRate(rate)**: Rate of pulsing to the change color.
*   **UseChangeColor(use)**: Set to 1 to enable color change on events.
*   **FadeInTime / FadeHoldTime / FadeSustainTime / FadeOutTime**: Timing parameters for visibility transitions.
*   **BlendMode(mode)**: Either `"Alpha"` or `"Additive"`.
*   **EditOnly(editOnly)**: If 1, only displays when the game is run with the `/hud` switch.
*   **EventEnable / EventChange / EventDisable**: Input events that trigger activation, changes, or deactivation.
*   **EventFadeOut**: Event FIRED when the element starts to fade out.
*   **EventColor / EventPulseRate**: Events that dynamically set color or pulse rate.
*   **AnimEnable / AnimDisable / AnimChange**: Procedural animations played on state transitions.
*   **ViewPort(num)**: Forces the element to a specific viewport (0 is full screen, 1-4 are players).
*   **Scalable(enable)**: **PC ONLY**: Allows the application to scale the element (useful for reticules).

# Text Elements
Text elements have the following properties...

*   **TextBox(w, h)**: Bounding box for text (fraction of screen/parent, 0..1).
*   **Text(text)**: Sets the text (localization string).
*   **TextFont(font)**: Font used to draw text.
*   **TextClip(clipStyle)**: Currently only supports `"Character"`.
*   **TextAlignment(h, v)**: Horizontal (`"Left"`, `"Right"`, `"Center"`) and Vertical (`"Top"`, `"Bottom"`, `"Center"`, `"Baseline"`).
*   **TextScale(w, h)**: Scale factor for text size.
*   **TextCharacterSpacing / TextTabSpacing**: Pixel spacing values.
*   **TextBreak(break)**: Wrapping algorithm: `"None"`, `"Word"`, `"No Reformat"`, `"Word Reformat"`.
*   **TextStyle(style)**: `"Normal"`, `"Shadow"`, or `"Selected"`.
*   **EventText / EventNumber**: Events that change the text content or display a numeric value.
*   **IntegerFormat / FloatFormat**: `printf` style formatting strings.
*   **NumberToTime(format)**: Converts a number to a time string using `%d`, `%h`, `%m`, `%s`.
*   **Percent(enable)**: If 1, displays a value (0..1) as a percentage (0% to 100%).
*   **InfiniteDashes(enable)**: If 1, displays `--` for infinite numbers.

**Example:**
```hud
Text()
{
    Position(0.0, 0.0, 0.0)
    Text("interface.weapon")
    TextAlignment("Left", "Top")
    TextScale(2.0, 2.0)
    TextFont("console")
    EventText("player1.weapon.text")
}
```

# Bitmap Elements
Bitmap elements have the following properties...

*   **Bitmap(textureName)**: Specifies the texture to display.
*   **BitmapStyle(style)**: Either `"Normal"` or `"Shadow"`.
*   **BitmapRect(w, h, halign, valign, rel)**: Bounding rectangle in pixels. `halign`/`valign` set alignment. `rel` defines the coordinate space (Pixels, Viewport, Frame, Screen).
*   **TexCoords(l, t, r, b)**: Texture coordinates (0..1). Default is 0, 0, 1, 1.
*   **Mask(textureName)**: 1-bit texture used as a mask (BitmapMasked elements only).
*   **Hardpoint(hardpointName)**: Position relative to a model hardpoint.
*   **EventBitmap(event)**: Sets the bitmap via an event.

**Examples:**
```hud
Bitmap()
{
    Position(0.0, 0.0, 0.0)
    Bitmap("rifle")
}

BitmapMasked()
{
    Position(50.0, 0.0, 0.0)
    Bitmap("map")
    Mask("circularmask")
    TexCoords(0, 0, 0.5, 1)
}
```

# 3D Model Elements
3D Model elements have the following properties...

*   **Mesh(meshName)**: Name of the mesh to display.
*   **Lighting(enable)**: 1 to enable, 0 to disable.
*   **Depth(depth)**: Controls perspective (Default: 0.1).
*   **EventMesh(event)**: Event that changes the displayed mesh.
*   **InheritMeshInfo(element)**: Inherits MeshInfos from another element.
*   **MeshInfo(meshName)**: Sub-section defining position, rotation, and scale for specific meshes.

**Example:**
```hud
Model3D("healthitem")
{
    Position(100, 0, 0)
    Mesh("com_weap_inf_medkit")
    Lighting(1)
    
    MeshInfo("com_weap_inf_medkit")
    {
        Position(150, 0, 0, 0)
        Scale(1, 1, 1)
        Rotation(30, 0, 0)
        Depth(0.03)
    }
}

## Group Elements

Group elements are areas which can contain other HUD elements or more group 
elements.  Coordinates of HUD elements added to a group element are 
relative to that group element's coordinates.   Group elements have the 
following additional properties...

Rect(w, h, halign, valign, rel)  - 
                              w is the width of the group element 
                              relative to the width of the screen (0..1).
                              h is the height of the group 
                              element relative to the height of the 
                              screen (0..1).  Elements added to the group 
                              that overlap the group's region are NOT 
                              clipped to the region.  This property 
                              is used by other group elements like 
                              BorderedBox and MultilineText.  halign can
                              be "left", "center" or "right".  valign can
                              be "top", "center" or "bottom".
                              When rel can be set to the following...
                             "Pixels"   - w, h pixel values
                             "Viewport" - w, h relative to the element's viewport 
                             "Frame"    - w, h relative to the element's container group
                             "Screen"   - w, h relative to the screen 
EventPosition(event)        - Event which updates the position of 
                              the element
PropagateAlpha(enable)      - set enable to 1 to propagate the groups 
                              alpha to children of the group
EventScale(event)           - Expects a vector3 event which
                              is used to scale the group.
EventRotation(event)        - Expects a vector3 event which rotates the group

Example...

// health / ammo group
Group()
{
    Position(10.0, 10.0, 0.0)
    ZOrder(0)
    Alpha(0.75)
    FadeInTime(1.0)
    FadeHoldTime(4.0)
    FadeOutTime(3.0)
    BlendMode("Alpha")
    EventActivate("player1.weapon.changed")
    EventActivate("player1.health.changed")
    Rect(1.0, 1.0)

    Text()
    {
        Position(0.0, 0.0, 0.0)
        Text("interface.health")
    }

    Bitmap()    
    {
        Position(20.0, 0.0, 0.0)
        Bitmap("healthbar")
    }

    Text()
    {
        Position(0.0, 10.0, 0.0)
        Text("interface.weapon.rifle")
    }

    Bitmap()
    {
        Position(20.0, 10.0, 0.0)
        Bitmap("weap_rifle")
    }   
}
```

# BorderedBoxes
A BorderedBox uses a background texture with a non-stretched border.

*   **Background(name)**: Texture name.
*   **Rect(width, height)**: Display size (0..1).
*   **Border(width, height)**: Thickness of the border in pixels.

**Example:**
```hud
BorderedBox()
{
    Background("border_3_pieces")
    Rect(0.5, 1.0)
    Border(8, 8)
    EventEnable("player1.objectivelist.enable")
    EventDisable("player1.objectivelist.disable")
}
```

# MultilineText
A group element for displaying scrolling text logs (like kill feeds).

*   **NumLines(lines)**: Max lines in queue.
*   **DisplayTime(time)**: Seconds a line remains before scrolling.
*   **AlwaysScroll(enable)**: 1 to scroll even if not full.
*   **DisableOnEmpty(enable)**: 1 to disable when empty.
*   **AddToTop(enable)**: 1 to add new text at the top, 0 at the bottom.
*   **ScrollSpeed(speed)**: Lines per second.
*   **Format**: A nested `Text()` or `Format()` element defining how each line looks.

**Example:**
```hud
MultilineText()
{
    Position(0.25, 0.25, 0.0, 1)
    Rect(0.5, 0.5)
    NumLines(80)
    DisplayTime(3.0)
    AlwaysScroll(1)
    ScrollSpeed(0.5)
    EventText("player1.spawnDisplay.message")
    Format()
    {
        TextBox(0.5, 0.1)
        TextFont("gamefont_tiny")
        TextClip("Character")
        TextAlignment("Left", "Center")
        TextScale(1.0, 1.0)
    }
}
```

# BarBitmap
Displays a status bar (Health, Ammo, etc.) using a bitmap.

*   **Value / MinValue / MaxValue**: Initial, minimum, and maximum range.
*   **ScaleTexture(scale)**: If 1, texture stays constant size. If 0, UVs stay constant.
*   **ScaleSize(scale)**: 1 to scale the bar's dimensions, 0 to just change UVs.
*   **EventValue(event)**: Event providing the 0..1 value.
*   **FlashyIncFadeOutTime / FlashyDecFadeOutTime**: Timing for "flash" effects on value changes.

**Example:**
```hud
BarBitmap("player1weapon1ammobar")
{
    EventValue("player1.weapon1.totalAmmoFraction")
    Position(0.1, 0.1, 0.000000, 1)
    Bitmap("hud_ammobar")
    BitmapRect(0.1, 0.05, "Top", "Left", 1)
    TexCoords(0, 0, 1, 1)
    EventEnable("player1.weapon1.totalAmmoFraction")
    EventDisable("player1.weapon1.disable")
}
```

# BarSegmented
A bar made of multiple repeating segments.

*   **Circular(enable)**: 1 for a radial bar, 0 for linear.
*   **AngleStart / AngleEnd**: Angles for circular bars (in degrees).
*   **NumSegments(segments)**: Number of bitmap blocks.
*   **Segment**: Bitmap sub-element definition.

**Example:**
```hud
BarSegmented("mycircularbar")
{
    Position(0.5, 0.5, 0.0, 1)
    Rect(0.25, 0.25)
    Circular(1)
    AngleStart(-150)
    AngleEnd(150)
    NumSegments(30)
    EventValue("player1.weapon1.totalClipFraction")
    EventEnable("player1.weapon1.totalClipFraction")
    EventDisable("player1.weapon1.disable")
    Segment("barsegment")
    {
        Bitmap("white")
        BitmapRect(0.1, 0.05, "Center", "Center", 1)
        TexCoords(0, 0, 1, 1)
    }
}
```

# ProceduralBarBitmap
Displays a procedurally animated bitmap bar (used for lightsaber/hero bars). Properties include `GlowAlphaBase`, `GlowAlphaScale`, `NoiseFreq`, and `NoiseRoughness`.

**Example:**
```hud
Group("player1herobar")
{
    Position(0.3, 0.06, 0, 1)  
    EventEnable("player1.hero.healthFraction")
    EventDisable("player1.hero.disable")
    BarBitmap("player1herobarback")
    {
        EventValue("player1.energyFraction")
        Bitmap("greenlaser_l")
        BitmapRect(0.3, 0.03, "Left", "Top", 1)
        ScaleTexture(0) 
        ZOrder(253)
        Alpha(0.8)
        Color(255, 255, 255)
        EventEnable("initialize")
    }

    ProceduralBarBitmap("player1herobarglow")
    {
        EventValue("player1.energyFraction")
        Bitmap("lightsabreglow")
        BitmapRect(0.3, 0.03, "Left", "Top", 1)
        Scale(1.0, 1.0, 1.000000)
        ScaleTexture(0) 
        ZOrder(253)
        Alpha(0.3)
        Color(255, 255, 255)
        EventEnable("initialize")
    }
}
```

# Map
The map/minimap. Bounds are defined by a "mapbounds" region or command posts. Key properties include `EventChangeMapMode`, `EventToggleMapMode`, `PostFlashRate`, and various `Backdrop` types (`Small`, `Large`, `Spawn`).

**Example:**
```hud
Map("player1map")
{
    EventChangeMapMode("player1.mapMode")
    EventToggleMapMode("player1.mapModeToggle")
    EventPostHide("player1.mapHideCPs")
    EventRefreshTarget("player1.mapRefreshTarget")
    EventRefreshPost("player1.mapRefreshPost")
    EventRefreshMarker("player1.mapRefreshMarker")
    EventPlayerIndex("player1.index")
    EventDisable("player1.mapDisable")
    Position(0.3, 0.8, 0.0, 1)    
    TargetLarge("largetarget")
    {
        BitmapRect(30, 30, "Center", "Center")
    }
}



Target
------

Battlefront's targeting / lock on display.  Has all of the default element and group 
properties with the addition of...

EventResetTargetCommon(event) - Event which resets a target, should be
                                set to "targetResetCommon"
EventResetTargetPlayer(event) - Event which resets a player specific target,
                                e.g "player1.targetResetPlayer"
EventPlayerIndex(event)       - Event which sets which local player is 
                                associated with this targetting display.  
                                Should be set to a player's event e.g
                                EventPlayerIndex("player1.index")
FourSegmentLockOn(enable)     - 4 bitmap elements are used for the lock on 
                                icon.
                                
AttackerOffScreen             - Bitmap element used to represent off 
                                screen attacker
AttackerOffScreenBehind       - Bitmap element used to represent off
                                screen attacker behind something
AttackerOnScreen              - Bitmap element used to represent on
                                screen attacker
AttackerOnScreenBehind        - Bitmap element used to represent on
                                screen attacker behind something
LockedOffScreen               - Bitmap element used to represent off 
                                screen locked target
LockedOffScreenBehind         - Bitmap element used to represent off
                                screen locked target behind something
LockedOnScreen                - Bitmap element used to represent on
                                screen locked target
LockedOnScreenBehind          - Bitmap element used to represent on
                                screen locked target behind something
HintOffScreen                 - Bitmap element used to represent off 
                                screen hint / target of oppotunity
HintOffScreenBehind           - Bitmap element used to represent off
                                screen hint / target of oppotunity
                                behind something
HintOnScreen                  - Bitmap element used to represent on
                                screen hint / target of oppotunity
HintOnScreenBehind            - Bitmap element used to represent on
                                screen hint / target of oppotunity
                                behind something
ObjectiveOffScreen            - Bitmap element used to represent off 
                                screen objective
ObjectiveOffScreenBehind      - Bitmap element used to represent off
                                screen objective behind something
ObjectiveOnScreen             - Bitmap element used to represent on
                                screen objective
ObjectiveOnScreenBehind       - Bitmap element used to represent on
                                screen objective behind something

Each of the bitmap elements within the Target also have the following 
properties...

ColorInterp(rate) - rate of interpolation of the color of the target
MinScale(scale)   - scale factor of the bitmap when it's close to the camera
MaxScale(scale)   - scale factor of the bitmap when it's far away from the camera

For example...

Target("player1target")
{
    EventEnable("player1.spawn")
    EventDisable("player1.die")
    EventPlayerIndex("player1.index")
    EventResetTargetCommon("targetResetCommon")
    EventResetTargetPlayer("player1.targetResetPlayer")
    
    AttackerOffScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    AttackerOffScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    AttackerOnScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_onscreen")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    AttackerOnScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_onscreen")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    LockedOffScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    LockedOffScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    LockedOnScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_onscreen")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    LockedOnScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_onscreen")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    HintOffScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    HintOffScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    HintOnScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_onscreen")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    HintOnScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_onscreen")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    ObjectiveOffScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    ObjectiveOffScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_target_pointer")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
    ObjectiveOnScreen()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_objective_icon")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
    }
    ObjectiveOnScreenBehind()
    {
        MinScale(1.000000)
        MaxScale(0.500000)
        Bitmap("hud_objective_icon")
        BitmapRect(32.000000, 32.000000, "Center", "Center", 0)
        Alpha(0.5)
    }
}
```

# VehicleSeating
Displays vehicle occupancy.
*   **EventPlayerIndex**: Sets local player association.
*   **Backdrop**: The vehicle model mesh (use `EventMesh` with `player1.vehicle.seatingMesh`).
*   **Empty / Self / Player / AI**: Models used for different seat states.

**Example:**
```hud
VehicleSeating("player1vehicleseating")
{
    EventPlayerIndex("player1.index")
    PropagateAlpha(1)
    EventEnable("player1.spawn")
    EventDisable("player1.die")
    Position(0.5, 0.5, -1592.276367, 1)
    Backdrop()
    {
        EventMesh("player1.vehicle.seatingMesh")
    }
    Empty()
    {
        Mesh("hud_vehicle_seatingchart_empty_icon")
    }
    Self()
    {
        Mesh("hud_vehicle_seatingchart_player1_icon")
    }
    Player()
    {
        Mesh("hud_vehicle_seatingchart_player1_icon")
    }
    AI()
    {
        Mesh("hud_vehicle_seatingchart_ai_icon")
    }
}
```

# Viewport
The `Viewport` group duplicates child elements for each player's viewport in split-screen.
*   **EventNameFilter**: String filter (e.g., `"player%"`) that automatically replaces placeholders with the viewport number (player1, player2, etc.).

**Example:**
```hud
Viewport("healthbars")
{
    EventNameFilter("player%")
    
    BarBitmap("player1weapon1ammobar")
    {
        EventValue("player1.weapon1.totalAmmoFraction")
        Position(0.1, 0.1, 0.000000, 1)
        Bitmap("hud_ammobar")
        BitmapRect(0.1, 0.05, "Top", "Left", 1)
        TexCoords(0, 0, 1, 1)
        EventEnable("player1.weapon1.totalAmmoFraction")
        EventDisable("player1.weapon1.disable")
    }
}
```

## Transforms

Transforms filter or convert event types.

### TransformNumberColor
Converts a number into a color.
*   **NumberColor(num, r, g, b)**: Maps a value to a color.
*   **WrapInput(wrap)**: 1 to wrap, 0 to clamp.

**Example (Ammo Color):**
```hud
TransformNumberColor("ammotextcolor")
{
    EventInput("ammo")
    EventOutput("ammotextcolor")
    NumberColor(0, 255, 0, 0)    // Red
    NumberColor(200, 200, 200, 30)
    NumberColor(400, 0, 255, 0)  // Green
    WrapInput(0)
}
```

### TransformNumberColorBlend
Extends `TransformNumberColor` with blending.
*   **EventBlend**: Color event to blend.
*   **BlendMode**: `"Alpha"` or `"Additive"`.

**Example:**
```hud
TransformNumberColorBlend("ammocolorflasher")
{
    EventInput("ammo")
    EventBlend("ammotextcolor")
    EventOutput("ammotextflashycolor")
    NumberColor(0, 0, 0, 0) 
    NumberColor(2, 255, 255, 255)
    NumberColor(4, 0, 0, 0) 
    BlendMode("Additive")
    WrapInput(1)
}
```

### TransformNumberVector3
Converts a number into a Vector3 (useful for scale/rotation).

**Example:**
```hud
TransformNumberColor("ammotextcolor")
{
    EventInput("player1.weapon1.charge")
    EventOutput("player1.weapon1.chargescale")
    NumberVector3(0.5, 1.0, 1.0, 1.0)
    NumberVector3(1.0, 0.5, 0.5, 0.5)
    WrapInput(0)
}
```

### TransformNameMesh
Maps a name event (like a weapon ODF name) to a specific HUD mesh.
*   **NameMesh(name, meshName)**: Mapping entry.
*   **TransformNameMesh(name)**: Inherit mappings from another transform.

**Example:**
```hud
TransformNameMesh("player1primaryweapons")
{
    EventInput("player1.weapon1.change")
    EventOutput("player1.weapon1.mesh")
    NameMesh("all_weap_inf_rifle",        "all_weap_inf_rifle");
    NameMesh("cis_weap_inf_wristblaster", "cis_weap_inf_wristblaster_hud");
}

TransformNameMesh("player2primaryweapons")
{
    EventInput("player2.weapon1.change")
    EventOutput("player2.weapon1.mesh")
    TransformNameMesh("player1primaryweapons")
}
```

# Sound
Plays a sound property based on HUD events.

**Example:**
```hud
Sound("player1pointssound")
{
    Sound("shell_menu_accept")
    EventTrigger("player1.statistics.points")
}
```

# In-Game HUD Editor
Enable by running the game with `/hud` and pressing `CTRL+E`.

## Controls (Console / PC Mappings)

**HUD Element Selection:**
*   **D-Pad Up/Down**: Select element.
*   **D-Pad Left/Right**: Scroll quickly.
*   **R1 (Page Up)**: Select element.
*   **L2 (End)**: Toggle name overlay position.

**Property Selection:**
*   **D-Pad Up/Down**: Select property.
*   **R1 (Page Up)**: Edit property.
*   **L1 (Home)**: Back to element selection.

**Property Edit Mode:**
*   **D-Pad Left/Right**: Adjust 1st value.
*   **D-Pad Up/Down**: Adjust 2nd value.
*   **X / B / Y / A (Numpad)**: Adjust 3rd and 4th values.

**General:**
*   **Select / Back (Insert)**: Save current layout to file.
*   **R2 (Page Down)**: Toggle safe zone display.

# Battlefront 2 HUD Events Reference
This section lists the dynamic events available for use in HUD properties like `EventEnable`, `EventText`, or `EventValue`. 

**Note on Placeholders:**
*   `[p]`: The player index (typically 1-4). On PC, this is usually 1.
*   `[w]`: The weapon index (typically 1 or 2).
*   `[t]`: The team index (0 for player team, 1 for enemy).

## Global Events
*   `initialize`: Fired on the first HUD update.
*   `objectivetimer`: Current value of the active objective timer.
*   `levelHintText`: Localization string for level start hints.
*   `targetResetCommon`: Resets targeting info for all players.

## Player Lifecycle & Health
*   `player[p].spawn` / `die`: Lifecycle transition events.
*   `player[p].healthFraction`: Soldier health percentage (0..1).
*   `player[p].bonusHealthFraction`: Over-health or bonus health percentage.
*   `player[p].healthRegenPulseRate`: Dynamic pulsing rate for health regeneration.
*   `player[p].healthDisable`: Fired when health display should be hidden.
*   `player[p].hero.healthFraction`: Health for Hero units.
*   `player[p].vehicle.healthFraction`: Health for the current vehicle.
*   `player[p].jetFuelFraction`: Jetpack fuel level (0..1).
*   `player[p].shieldFraction`: Vehicle or personal shield level (0..1).
*   `player[p].energyFraction`: Stamina or secondary energy bar (0..1).

## Weapon & Ammo
*   `player[p].weapon[w].change`: Fired when switching weapons.
*   `player[p].weapon[w].name`: Localization string for the weapon name.
*   `player[p].weapon[w].totalAmmoFraction`: Total remaining ammo (0..1).
*   `player[p].weapon[w].totalClipFraction`: Current clip ammo (0..1).
*   `player[p].weapon[w].ammoInfinite`: Fired if the weapon has infinite ammo.
*   `player[p].weapon[w].heat`: Current heat level for overheating weapons (0..1).
*   `player[p].weapon[w].charge`: Charge-up level for weapons like the Spartan Laser (0..1).
*   `player[p].weapon[w].refire`: Fired during weapon refire cycles.
*   `player[p].weaponsOverheat`: Global event for all weapons overheating.

## Targeting & Lock-On
*   `player[p].weapon[w].target.name`: Name of the targeted unit.
*   `player[p].weapon[w].target.healthFraction`: Target's health percentage.
*   `player[p].weapon[w].target.teamColor`: Color associated with the target's team.
*   `player[p].weapon[w].target.hit`: Fired when a shot lands on target.
*   `player[p].weapon[w].target.hitCritical`: Fired on headshots/critical hits.
*   `player[p].weapon[w].reticule.position`: World-to-screen position of the reticule.
*   `player[p].lockOnDistance`: Distance to the locked target in world units.
*   `player[p].lockOnHealthFraction`: Health of the unit being locked onto.
*   `player[p].missileLock`: Fired when a missile lock is acquired.

## Vehicle & Seating
*   `player[p].vehicle.seatingMesh`: The mesh representing the current vehicle's seating chart.
*   `player[p].vehicle.hackingTimeFraction`: Progress bar for vehicle hacking (0..1).

## Map & Objectives
*   `player[p].map.mode`: Current zoom or display mode of the minimap.
*   `player[p].map.modeToggle`: Event to toggle between map modes.
*   `player[p].map.hideCPs`: Fired when command post icons should be hidden.
*   `player[p].map.spawn`: Fired when the spawn selection map is active.
*   `player[p].objectivelist.enable` / `disable`: Visibility of the objective list.
*   `player[p].objectivesUpdated`: Fired when objectives change.

## Messaging & UI
*   `player[p].centerMessage`: Primary objective or status text (Center screen).
*   `player[p].message`: Secondary feed or kill-log text.
*   `player[p].chatMessage`: Incoming player chat text.
*   `player[p].tooltips`: Tooltip hint text.
*   `player[p].spawnDisplay.message`: Text shown on the spawn screen.
*   `player[p].heroSelect.message`: "Play as Hero?" prompt text.

## Teams & Statistics
*   `player[p].team[t].reinforcements`: Current ticket count.
*   `player[p].team[t].reinforcementsFraction`: Tickets as a percentage of starting value.
*   `player[p].team[t].points`: Current team score.
*   `player[p].team[t].bleedRate`: Ticket bleed speed.
*   `player[p].statistic.points`: Local player total points.
*   `player[p].statistic.kills`: Local player total kills.
*   `player[p].statistic.deaths`: Local player total deaths.
*   `player[p].statistic.GetCommandPostPoints`: Points earned from captures.

## CTF / Flag Events
*   `player[p].flag.player.carried`: Fired if the local player is carrying the flag.
*   `player[p].flag.friend.carried.number`: Number of flags captured by the player's team.
*   `player[p].flag.enemy.carried.number`: Number of flags captured by the enemy team.

## Command Post Events
*   `player[p].commandPost.charge`: Capture progress of the current command post (0..1).
*   `player[p].commandPost.color`: Ownership color of the command post.
*   `player[p].commandPost.disputeEnable`: Fired when a command post is being contested.
