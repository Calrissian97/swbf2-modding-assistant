# BF2_modtools.exe (Debugging/Programmer's Build)
This document explains the debugging executable used to run the game in debug mode. This is a programmer's build/debugger of the game called BF2_modtools.exe that when placed in the game's GameData directory allows the user to hit ` on the keyboard to display a code console where predefined functions can be called, and also produces a text log file of information including errors encountered while running.

Sections:
- Console Commands (lines 10-86)
- Limitations (lines 88-89)

---

# Console Commands
Console commands can be accessed through a dev console that will popup when the `~` key is pressed. Pressing the tab key will toggle through all available commands, and autocomplete all available sub-commands per command e.g., Lighting. -> TAB -> SunColor. This list is not comprehensive, but contains a few of the more commonly-used commands.

| Command | Description |
| :--- | :--- |
| `ai.aimaxflyheight <int>` | Set max fly height for AI. |
| `ai.cps` | Lists command posts with spawn weights and value properties. |
| `ai.notext` | Disables showing what state each AI is in while `aimode` is on. |
| `ai.playermaxflyheight <int>` | Set max fly height for player. |
| `ai.showallpaths` | Shows AI pathing as red lines. |
| `ai.showconnectivitygraph` | Shows the AI planning hubs and connections as yellow circles and lines. |
| `ai.showHintNodes` | Toggles visibility of world hintnodes as colored cylinders, shows type and stance up-close.|
| `ai.showobstacles` | Shows world AI barriers. `aimode` must be enabled first. |
| `aidiff` | Lists AI difficulty values, such as profile difficulty setting, AIAutoBalance setting, and base/lua difficulty values. |
| `aigoals` | Lists AI goals and their weights for each team. |
| `aimode` | Toggles AI mode, showing AI state information. |
| `anim.show` | Displays currently-running animations on units, frame range, current frame number, and blending percentages. |
| `Blur.Enable` | Toggles blur effect. |
| `Blur.MaxDepth` | Sets the maximum depth for blur. |
| `Blur.MinDepth` | Sets the minimum depth for blur. |
| `ColorControl.Enable` | Toggles color control. |
| `ColorControl.GammaBrightness` | Sets gamma brightness. |
| `ColorControl.GammaContrast` | Sets gamma contrast. |
| `ColorControl.WorldBrightness` | Sets world brightness. |
| `ColorControl.WorldContrast` | Sets world contrast. |
| `ColorControl.WorldSaturation` | Sets world saturation. |
| `combo.damage` | Displays melee weapons' damage edges with red lines and spheres. |
| `debugmenu.InfiniteReinforce` | Sets team reinforcements to infinity. |
| `debugmenu.renderhitlocations` | Render critical hit locations on entities. |
| `debugmenu.ToggleUnlockAllClasses` | Makes all unit classes available for selection by player. |
| `debugmenu.unlimitedammo` | Gives infinite ammo to player. |
| `debugmenu.UnlimitedEnergyAll` | Gives infinite energy to all entities. |
| `dumpcamera` | Dump the current camera values to a AddCameraShot line in a cameracoordinates.txt file. |
| `EnableAllAwards` | Enables all award weapons to the player. |
| `EnableHeroes` | Enables team-hero selection to the player. |
| `fixframerate <int>` | Fixes framerate target to set value. |
| `fog.color <int> <int> <int> <int>` | Set fog RGBA color. |
| `fog.range <float> <float>` | Set fog near and far ranges. |
| `ForceDefeat` | Immediately forces player defeat. |
| `ForceVictory` | Immediately forces player victory. |
| `framerate` | Display current framerate. |
| `invincible` | Toggles invincibility for the player. |
| `InvincibleAll` | Sets all entities as invincible. |
| `Lighting.AmbientColor <red> <green> <blue>` | Sets the ambient color for static objects/buildings. Can be used without parameters to print the current value. |
| `Lighting.BottomAmbientColor <red> <green> <blue>` | Sets the bottom ambient color for dynamic objects/characters. Can be used without parameters to print the current value. |
| `Lighting.Draw` | Renders lights as wireframe spheres. |
| `Lighting.Enable` | Toggles rendering lights. |
| `Lighting.SetGlobalDirColor <int> <int> <int>` | Sets the global directional RGB color. |
| `Lighting.ShadowColor <red> <green> <blue>` | Sets the shadow color. Can be used without parameters to print the current value. |
| `Lighting.SunColor <red> <green> <blue>` | Sets the sun's color. Can be used without parameters to print the current value. |
| `Lighting.SunDirection <heightangle> <directionangle>` | Sets the sun's direction. Can be used without parameters to print the current value. |
| `Lighting.TopAmbientColor <red> <green> <blue>` | Sets the top ambient color for dynamic objects/characters. Can be used without parameters to print the current value. |
| `Lua <code>` | Run arbitrary Lua code. |
| `Map.displayall` | Toggles displaying *all* entities on the minimap.|
| `mem` | Displays memory usage by game systems. |
| `particles.Enable` | Toggle rendering particle effects. |
| `PrintPlayerCoords` | Dump current player world coordinates to the Bfront2.log. |
| `Reflections.Draw` | Toggles rendering wireframe reflection regions. |
| `Reflections.Enable` | Toggles rendering reflections. |
| `render_cloth_connections` | Toggles rendering cloth debug view. |
| `renderOrdCollision` | Render ordnance collision primitives and collision meshes. |
| `renderSoftCollision` | Render soldier/vehicle? collision primitives and collision meshes. |
| `renderTerrainCollision` | Render terrain collision primitives and collision meshes. |
| `setcontrols` | Toggles player input affecting entity controls. |
| `Shadow.BlurEnable` | Toggles blur effect for shadows. |
| `Shadow.Enable` | Toggles rendering shadows. |
| `Shadow.Intensity` | Sets the shadow intensity. |
| `showflyerheights` | Show max fly heights for this world. |
| `slowmo <int>` | Slow down entire game by a given denominator. Set to 1 to reset to normal playback rate. |
| `snd.display` | Disables display / prints out snd.display options. |
| `snd.display chase` | Displays properties of the object being chased by the camera. |
| `snd.display space` | Displays listener's space. |
| `snd.display voice` | Displays the active virtual voice list. |
| `snd.set` | Set a sound object's parameter value. |
| `snd.unused` | Displays sounds and samples loaded which are not referenced. |
| `snd.view` | Displays a sound object's settings. |
| `Weapon.render` | Toggles rendering weapons. |

# Debugger Limitations
The debugger has a few limitations and exhibits altered behaviors compared to the full game. The debugger cannot play the game in multiplayer. It also cannot enable/disable barriers or adjust AI planning connections even if programmed to do so in the lua. For very large addons, it may crash due to limited memory more quickly than the full game will.
