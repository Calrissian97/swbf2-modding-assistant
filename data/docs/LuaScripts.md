# Lua Scripting
This document explains how Star Wars Battlefront 2 uses lua scripting for game interfaces and gameplay.

Sections:
- Lua Version (lines 34–35)
- Paths In Lua (lines 37–38)
- ScriptCB Functions (lines 40–129)
- Audio/Music Functions (lines 132–152)
- World/Map/Camera Functions (lines 154–191)
- Teams/Units/AI Functions (lines 193–228)
- World Regions Functions (lines 230–238)
- Vehicles/Walkers Functions (lines 240–245)
- Objectives Functions (lines 247–259)
- Space Assault Functions (lines 261–270)
- Timers Functions (lines 272–288)
- Objects Functions (lines 290–304)
- Entities Functions (lines 306–326)
- Characters Functions (lines 328–343)
- World Animations Functions (lines 345–352)
- Particle Effects Functions (lines 354–364)
- Utility Functions (lines 366–396)
- In-Game Event Callbacks (lines 398–477)
- Interface Scripting Overview (lines 482–499)
- Interface Objects and Properties (lines 501–513)
- Interface Functions (lines 515–567)
- In-Game Elements Script Example (lines 570–730)
- In-Game Menus Script Example (lines 732–953)
- Userscripts (lines 958–1033)
- Galactic Conquest Scripts (lines 1035–1388)
- UnOfficial Patch Additions (lines 1390–1416)

---

# Version information
BF2 uses lua version 5.0.2, slightly modified by Pandemic Studios for their custom functions that serve various roles.

# Paths
All paths supplied to the game via lua scripts will be referenced relative to the installed game directory: `GameData/data/_lvl_pc`. A shortcut specific to each addon will be `"dc:"` which will resolve to that addon's folder under `GameData/Addon/...` where the ellipses represent the three-character addon sequence unique to each addon.

# Pandemic Studios ScriptCBs
| Function | Description |
| :--- | :--- |
| `ScriptCB_DoFile(luaFilename)` | Reads/includes another lua file. |
| `ScriptCB_IsFileExist(filePath)` | Returns `1` if the file exists, otherwise returns `0`. |
| `ScriptCB_IsMissionSetupSaved()` |  Returns true if mission setup is saved, false otherwise. |
| `ScriptCB_LoadMissionSetup()` | Returns table containing mission setup data.|
| `ScriptCB_EnableCommandPostVO(enabled)` | Enables CP voice overs. |
| `ScriptCB_EnableHeroMusic(enabled)` | Enables specific hero music when playing as a hero. |
| `ScriptCB_EnableHeroVO(enabled)` | Enables hero unit voice overs. |
| `ScriptCB_InMultiplayer()` | Returns `1` if current mission is a multiplayer session, else `0`. |
| `ScriptCB_PlayerSuicide(viewport)` | Kills the player of the specified HUD viewport (starting at 1). |
| `ScriptCB_tounicode(string)` | Converts a string to Unicode format for use in certain functions. |
| `ScriptCB_PlayInGameMusic(musicID)` | Plays the specified music sample. |
| `ScriptCB_StopInGameMusic()` | Stops music played via `ScriptCB_PlayInGameMusic`. |
| `ScriptCB_SetDopplerFactor(factor)` | Increases or reduces doppler effects. |
| `ScriptCB_SetMovieAudioBus(busID)` | Sets the audio bus that controls movie playback volume. |
| `ScriptCB_SetSpawnDisplayGain(g, f)` | Sets gain of the ingame audio bus when spawn display is viewed. |
| `ScriptCB_SndBusFade(n, g, g, g)` | Fades the specified sound bus. |
| `ScriptCB_SndPlaySound(soundID)` | Plays the specified sound property. |
| `ScriptCB_TriggerSoundRegionEnable(n, b)`| Enables or disables the specific sound trigger region. |
| `ScriptCB_GetVolumes()` | Returns levels (0-10) for Music, SFX, Speech, Battle, Unknown, Total. |
| `ScriptCB_SetVolumes(m, s, sp, b, t)` | Sets volume levels. The 5th value (Unknown) is read-only. |
| `ScriptCB_SoundDisable()` | Mutes menu UI sounds until the match ends. |
| `ScriptCB_SoundEnable()` | Re-enables menu sounds. |
| `ScriptCB_OpenMovie(file, "")` | Opens a movie file for playback. |
| `ScriptCB_CloseMovie()` | Closes the currently open movie. |
| `ScriptCB_PlayMovie(n, l, nx, l, t, w, h)`| Plays a movie at the specified screen position. |
| `ScriptCB_StopMovie()` | Stops the currently playing movie. |
| `ScriptCB_IsMoviePlaying()` | Returns whether a movie is currently playing. |
| `ScriptCB_AreMoviePropertiesPlaying(n)` | Returns whether specified movie properties are playing. |
| `ScriptCB_PlayInGameMovie(f, id)` | Plays an in‑game movie. |
| `ScriptCB_StopInGameMovie()` | Stops the currently playing in‑game movie. |
| `ScriptCB_DisableFlyerShadows()` | Disables shadows on flyers, used for PS2 version. |
| `ScriptCB_GetNumCameras()` | Returns the number of cameras/players. |
| `ScriptCB_SetNumBots(botsNum)` | Sets the number of bots. |
| `ScriptCB_GetCONNumBots()` | Returns the configured number of bots from game settings for Conquest gamemode. |
| `ScriptCB_GetASSNumBots()` | Returns the configured number of bots from game settings for Assault gamemode. |
| `ScriptCB_GetCTFNumBots()` | Returns the configured number of bots from game settings for Capture the Flag gamemode. |
| `ScriptCB_GetCTFCaptureLimit()` | Returns the configured capture limit from game settings for Capture the Flag gamemode. |
| `ScriptCB_GetAssaultScoreLimit()` | Returns the configured score limit from game settings for Assault gamemode. |
| `ScriptCB_ShowHuntScoreLimit(displayType)` | Shows the score limit for Hunt mode on the HUD. |
| `ScriptCB_SetUberScoreLimit(scoreLimit)` | Sets the score limit for ubermode. |
| `ScriptCB_GetCONMaxTimeLimit()` | Returns the configured time limit from game settings for Conquest gamemode. |
| `ScriptCB_GetCTFMaxTimeLimit()` | Returns the configured time limit from game settings for Capture the Flag gamemode. |
| `ScriptCB_GetHuntMaxTimeLimit()` | Returns the configured time limit from game settings for Hunt gamemode. |
| `ScriptCB_GetMissionTime()` | Returns the current mission time. |
| `ScriptCB_GetAwardStats()` | Returns player award stats for award screen. |
| `ScriptCB_GetPlatform()` | Returns the current platform: "PC", "PS2", or "XBOX". |
| `ScriptCB_GetLanguage()` | Returns the configured language from game settings. |
| `ScriptCB_GetConnectType()` | Returns the network connection type: "LAN", "GameSpy", "XLive". |
| `ScriptCB_InNetGame()` | Returns true if playing an online match. |
| `ScriptCB_GetGameRules()` | Returns gamemode type: "metagame", "instantaction", "campaign" |
| `ScriptCB_SetGameRules(ruleset)` | Sets gamemode type: "metagame", "instantaction", "campaign" |
| `ScriptCB_GetAmHost()` | Returns true if hosting a multiplayer match, false otherwise. |
| `ScriptCB_CanClientLeaveStats()` | Returns boolean value as to whether the client can leave the stats page yet. |
| `ScriptCB_QuitFromStats()` | Quits from the stats page. |
| `ScriptCB_QuitToWindows()` | Quits to Windows. |
| `ScriptCB_Unpause(viewport)` | Unpauses the game. |
| `ScriptCB_RestartMission()` | Restarts the mission. |
| `ScriptCB_IsGameOver()` | Returns boolean as to whether the mission is over. |
| `ScriptCB_Freecamera()` | Enables freecamera. |
| `ScriptCB_PushScreen(screen)` | Adds a new interface screen to the stack. |
| `ScriptCB_SetIFScreen(screen)` | Sets the current interface screen. |
| `ScriptCB_PopScreen()` | Removes current interface screen from the stack. |
| `ScriptCB_GetScreenInfo()` | Returns screeninfo: r, b, v, widescreen. |
| `ScriptCB_GetSafeScreenInfo()` | Returns width, height slightly inset from fullscreen. |
| `ScriptCB_IsSplitscreen()` | Returns boolean as to whether the game is in split screen. |
| `ScriptCB_IsHorizontalSplitScreen()` | Returns boolean as to whether the game is split horizontally. |
| `ScriptCB_getlocalizestr(localizationKey)` | Returns a localized string. |
| `ScriptCB_usprintf(localizationKey)` | Returns a localized string in ASCII. |
| `ScriptCB_GetFontHeight(font)` | Returns the height of the specified font. |
| `ScriptCB_GetCareerMedalLevel(num, category)` | Returns career medal level. |
| `ScriptCB_GetCareerMedals(characterIdx, category)` | Returns career medals. |
| `ScriptCB_IsInShell()` | Returns boolean as to whether the shell/interface is active. |
| `ScriptCB_GetShellActive()` | Returns boolean as to whether the shell/interface is active. |
| `ScriptCB_GetPlayerIDAtRank(characterIdx, teamIdx)` | Returns the player ID at the specified rank and team. |
| `ScriptCB_GetCareerPersonalStats(characterIdx, category)` | Returns career personal stats. |
| `ScriptCB_GetPersonalStats(characterIdx, category)` | Returns personal stats. |
| `ScriptCB_SetPlayerStatsPoints(pointsTable)` | Sets player point rewards for various actions. |
| `ScriptCB_GetTeamstats(category)` | Returns player-team stats. |
| `ScriptCB_GetError()` | Returns last registered error level and error message. |
| `ScriptCB_GetPausingViewport()` | Returns viewport currently paused. |
| `ScriptCB_GetGeneralOptions()` | Returns configured general game options table. |
| `ScriptCB_SetGeneralOptions(generalOptionsTable)` | Sets general game options configuration. |
| `ScriptCB_ResetGameOptionsToDefault()` | Resets game options to default values. |
| `ScriptCB_EnableCursor(enabled)` | Enables/disables cursor. |
| `ScriptCB_GetProfileName(profileIdx)` | Returns the current profile name. |
| `ScriptCB_SetVictoryMovie()` | **Deprecated.** |
| `ScriptCB_SetDefeatMovie()` | **Deprecated.** |

# Other Defined Game Functions
# Audio and Music
| Function | Description |
| :--- | :--- |
| `SetBleedingVoiceOver(playerTeam, bleedTeam, streamName, bleedingStartorStop)` | Sets sound stream for when a team starts (1) or stops (0) bleeding. |
| `SetBleedingRepeatTime(time)` | Sets bleeding sound repeat time. |
| `SetPlanetaryBonusVoiceOver(playerTeam, bonusNum, streamName)` | Sets VO for a planetary bonus. |
| `SetSoundEffect(type, prop, team)` | Assigns a sound effect to an event. |
| `SetLowReinforcementsVO(playerTeam, lowReinforcementTeam, streamName, reinforcementsNum, isPercentage)` | Sets VO for low reinforcements (supports percentage). |
| `SetOutOfBoundsVO(team, snd)` | Sets out‑of‑bounds VO. |
| `SetAmbientMusic(playerTeam, reinforcementCount, musicName, gameStage, isPercentage)` | Sets ambient music based on reinforcement count and stage (begin 0, middle 1, end 2). |
| `SetAttackingTeam(teamIndex)` | Sets which team’s music/VO plays in splitscreen. |
| `SetVictoryMusic(team, id)` | Sets victory music. |
| `SetDefeatMusic(team, id)` | Sets defeat music. |
| `PlayAudioStream(streamFilename, streamID, segmentID, gain, busName, streamIndex)` | Plays a stream segment. |
| `PlayAudioStreamUsingProperties(streamFilename, streamID, noOpen)`| Plays a stream using preset properties. noOpen=1 to play using a previously opened stream. |
| `StopAudioStream(index, close)` | Stops (and optionally closes) a stream. |
| `OpenAudioStream(file, id)` | Opens a stream. |
| `AudioStreamAppendSegments(streamFilename, streamID, streamIndex)` | Appends one stream to another. |
| `AudioStreamComplete(streamID)` | Returns whether a stream is playing. |
| `ScaleSoundParameter(g, p, s)` | Scales a sound group parameter. |
| `BroadcastVoiceOver(id, team)` | Plays sound stream for all or a specific team. |

# World, Map, and Camera
| Function | Description |
| :--- | :--- |
| `ScriptPreInit()` | Optional tasks to run before `ScriptInit`. |
| `ScriptInit()` | Load assets and set configurations. |
| `ScriptPostLoad()` | Tasks to run after asset loading in `ScriptInit`. |
| `SetWorldExtents(amount)` | Sets world collision extents. |
| `AddCameraShot(quatW, quatX, quatY, quatZ, posx, posy, posz)` | Adds spectator camera shot (quaternion + position). |
| `SetCameraRotation(w, x, y, z)` | Sets camera rotation. |
| `SetCameraPosition(x, y, z)` | Sets camera position. |
| `MoveCameraToEntity(entity)` | Moves camera to entity. |
| `SetMapCameraPosition(x, y, z)` | Sets Galactic Conquest map camera position. |
| `SetMapCameraOffset(zoom, posX, posY, posZ)` | Sets Galactic Conquest camera offset. |
| `SetMinPlayerFlyHeight(h)` | Sets player min fly height. |
| `SetMaxPlayerFlyHeight(h)` | Sets player max fly height. |
| `SetMaxFlyHeight(h)` | Sets max AI fly height. |
| `SetMinFlyHeight(h)` | Sets min AI fly height. |
| `SetMemoryPoolSize(pool, size)` | Sets memory pool size (e.g., Soldier, Cloth). |
| `MapAddRegionMarker(region, markerClass, size, teamIndex, color, showOnHUD, pulseOpacity, pulseSize)` | Attaches a map marker to the specified region class. |
| `MapAddEntityMarker(objectPtr, icon, iconScale, teamATT, color, enabled)` | Attaches a map marker to the specified entity. |
| `MapRemoveEntityMarker(objectPtr)` | Detaches a map marker from the specified entity. |
| `MapHideCommandPosts()` | Hides all CP markers from the minimap and radar. |
| `GetCommandPostTeam(post)` | Returns the team number of the specified CP. |
| `SetMapNorthAngle(angle, int)` | Sets the north angle on the minimap. |
| `DisableSmallMapMiniMap()` | Removes the small minimap from the HUD. |
| `MapAddClassMarker(className, teamIcon, iconScale, teamATT, color, enabled)` | Adds a team-specific icon to the minimap for all entities of that class. |
| `MapRemoveClassMarker(className, teamATT)` | Removes team-specific icons from entity classes from the minimap. |
| `SetParticleLODBias(distance)` | Adjust LOD bias of particle effects. |
| `SetMaxCollisionDistance(distance)` | Used to adjust asteroid collisions in space levels. |
| `FillAsteroidRegion(regionName, int<60-120>, OdfName, count, minx, miny, minz, maxx, maxy, maxz)` | Fills a world region with asteroid entities. |
| `FillAsteroidPath(pathName, OdfName, count, minx, miny, minz, maxx, maxy)` | Fills a path with asteroid entities. |
| `SpaceAssaultEnable(enabled)` | Enables space assault scoring for critical capital ship systems. |
| `SpaceAssaultGetScoreLimit()` | Returns the score limit for space assault. |
| `GetCommandPostBleedValue(cpName, teamATT)` | Returns the ticket bleed value of the specified CP for the given team. |
| `SetNumBirdTypes(int)` | Set count of bird types. |
| `SetBirdType(typeIndex, sizeFloat, "birdTexture")` | Sets the bird texture for this type. |
| `SetNumFishTypes(int)` | Set count of fish types. |
| `SetFishType(typeIndex, sizeFloat, "fishTexture")` | Sets the fish texture for this type |

# Teams, Units, and AI
| Function | Description |
| :--- | :--- |
| `SetAIDifficulty(playerTeamDiffNum, enemyTeamDiffNum, diffStr)` | Adds or subtracts difficulty values from player and enemy teams, optionally only affecting a profile (diffStr="easy|medium|hard")  |
| `SetPlayerTeamDifficulty(num)` | Sets player team difficulty from 1-20 (higher is smarter). |
| `SetEnemyTeamDifficulty(num)` | Sets enemy team difficulty from 1-20 (higher is smarter). |
| `DisableAIAutoBalance()` | Disables AI auto-balancing to make the AI team smarter. |
| `EnableAIAutoBalance()` | Enables AI auto-balancing to make the AI team smarter. |
| `SetTeamName(team, key)` | Sets team localized name. |
| `SetTeamAggressiveness(t, val)` | Sets AI aggressiveness (0.0 - 1.0). |
| `SetUberMode(enabled)` | Enables >32 units per team. |
| `SetTeamAsEnemy(team, other)` | Makes team treat other as enemy. |
| `SetUnitCount(team, count)` | Sets AI unit count for a team. |
| `SetReinforcementCount(t, n)` | Sets starting team reinforcements/tickets. |
| `AddUnitClass(t, class, min, max)` | Adds unit class to team spawn table. |
| `SetHeroClass(team, class)` | Sets hero class for a team. |
| `UnlockHeroForTeam(team)` | Manually unlocks team hero. |
| `SetBleedRate(team, rate)` | Sets reinforcement/ticket bleed rate. |
| `AddTeamPoints(teamIndex, points)` | Adds team points to specified team. |
| `ShowTeamPoints(teamIndex, enabled)` | Toggles team points display on HUD. |
| `AddAIGoal(team, type, weight)`| Adds an AI goal (conquest, deathmatch, etc). |
| `AICanCaptureCP(cpName, teamIdx, canCapture)` | Sets whether the specified team can capture the specified Command Post. |
| `ForceAIOutOfVehicles(teamIndex, enabled)` | Forces AI to exit vehicles. |
| `SetAIVehicleNotifyRadius(radius)` | Sets distance at which AI will notice vehicles. |
| `GetNumTeamMembersAlive(teamIndex)` | Returns count of living units on team. |
| `SetAIDamageThreshold(characterIdx, threshold)` | Sets the damage threshold for a character. |
| `AllowAISpawn(teamIdx, canSpawn)` | Sets whether the specified team can spawn. |
| `AISnipeSuitabilityDist(distance)` | Sets the distance at which AI will consider sniping. |
| `SetAttackerSnipeRange(distance)` | Sets the distance at which AI attackers will consider sniping. |
| `SetDefenderSnipeRange(distance)` | Sets the distance at which AI defenders will consider sniping. |
| `SetAIViewMultiplier(multiplier)` | Sets the multiplier for AI view distances. |
| `EnableSPHeroRules()` | Sets hero unlock rules to standard configurated unlock from game options. |
| `EnableSPScriptedHeroes()` | Sets hero unlock rules to a scripted unlock. |
| `AcceptHero(enable)` | Input 1 for reject, 0 for accepting hero manually. |
| `SetDenseEnvironment(enableStr)` | Alters AI behavior to be more aware of dense environments. Synonymous with `SetUrbanEnvironment`. |
| `SetUrbanEnvironment(enableStr)` | Alters AI behavior to be more aware of dense environments. Synonymous with `SetDenseEnvironment`. |

# World Regions
| Function | Description |
| :--- | :--- |
| `AddDeathRegion(regionName)` | Registers a death region. |
| `AddLandingRegion(regionName)` | Registers a landing region. |
| `IsCharacterInRegion(id, region)` | Returns whether character is in region. |
| `ActivateRegion(name)` | Enables region. |
| `DeactivateRegion(name)` | Deactivates region. |
| `GetRegion(regionName)` | Returns truthy value if region currently exists on this level. |

# Vehicles and Walkers
| Function | Description |
| :--- | :--- |
| `ClearWalkers()` | Clears walker allocations. |
| `AddWalkerType(numPairs, count)` | Adds walkers, first param is leg pair count, second is entity count. |
| `SetGroundFlyerMap(enabled)` | Makes flyers aware of terrain. |

# Objectives
| Function | Description |
| :--- | :--- |
| `AddMissionObjective(teamIndex, text, popupText)` | Registers objective. |
| `ActivateObjective(text)` | Activates objective. |
| `CompleteObjective(text)` | Completes objective. |
| `AddMissionHint(hintText)` | Adds mission hint. |
| `SetFlagGameplayType(type)` | Sets flag mode: "1flag", "2flag", "campaign", "none". |
| `AddFlagCapturePoints(characterIdx)` | Sets flag capture points |
| `ShowObjectiveTextPopup(localizationKey)` | Freezes game and displays a message; game resumes when cleared. |
| `MissionVictory(teamIndex)` | Initiates a victory for the specified team. |
| `MissionDefeat(teamIndex)` | Initiates a defeat for the specified team. |
| `SetMissionEndMovie(sourceFilename, movieID)` | Sets the movie to play once the mission has ended. |

# Space Assault
| Function | Description |
| :--- | :--- |
| `SpaceAssaultEnable(enabled)` | Enables space assault scoring. |
| `SpaceAssaultAddCriticalSystem(name, pointValue, hudPosX, hudPosY, enabled)` | Adds critical system (name, pointValue, hudX, hudY, displayHUDMarker). |
| `SpaceAssaultLinkCriticalSystems(objectNames)` | Links critical system objects in a table as one HUD marker. |
| `AddSpaceAssaultDestroyPoints(chrIdx, entityName)` | Assigns destruction points for the specified object. |
| `SpaceAssaultSetupTeamNumbers(unknown)` | Unused; exact functionality unknown. |
| `SpaceAssaultSetupBitmaps(shipBitmapATT, shipBitmapDEF, shieldBitmapATT, shieldBitmapDEF, critSysBitmapATT, critSysBitmapDEF)` | Sets HUD bitmaps for ships, shields, and critical systems. |
| `SpaceAssaultGetScoreLimit()` | Returns the score limit for space assault. |

# Timers
| Function | Description |
| :--- | :--- |
| `FindTimer(timerHandler)` | Returns whether the specified Timer handler exists. |
| `ShowTimer(timerObject)` | Toggles visibility of a timer on the HUD. |
| `CreateTimer(name)` | Creates a new Timer and returns its handler. |
| `DestroyTimer(timerHandler)` | Deletes the specified Timer. MUST be called or match playlist will end due to improper timer cleanup. |
| `StartTimer(timerHandler)` | Activates the specified Timer. |
| `StopTimer(timerHandler)` | Deactivates the specified Timer. |
| `SetTimerValue(timerHandler, value)` | Sets the value of the specified Timer. |
| `GetTimerValue(timerHandler)` | Returns the value of the specified Timer. |
| `SetTimerRate(timerHandler, rate)` | Sets the countdown/up rate of the specified Timer. |
| `GetTimerRate(timerHandler)` | Returns the rate of the specified Timer. |
| `GetTimerName(timerHandler)` | Returns the name of the specified Timer. |
| `SetDefeatTimer(handler, teamIndex)` | Sets the defeat Timer (displayed on HUD). |
| `SetVictoryTimer(handler, teamIndex)` | Sets the victory Timer (displayed on HUD). |
| `SetMissionTimer(timerHandler)` | Sets the mission timer; failure to finish before it elapses causes defeat. |

# Objects
| Function | Description |
| :--- | :--- |
| `GetObjectPtr(objectName)` | Returns the object pointer of the specified object. |
| `ActivateObject(objectName)` | Activates the specified object. |
| `DeactivateObject(objectName)` | Deactivates the specified object. |
| `SetObjectTeam(name, teamIndex)` | Assigns the specified object to the specified team. |
| `GetObjectTeam(objectName)` | Returns the team index of the specified object. |
| `IsObjectAlive(objectName)` | Returns whether the specified object is alive. |
| `GetObjectHealth(objectName)` | Returns object health (CurHealth, MaxHealth, AddHealth). |
| `GetObjectShield(objectName)` | Returns object shields (CurShield, MaxShield, AddShield). |
| `GetObjectLastHitWeaponClass(name)` | Returns the name of the weapon class that most recently hit the object. |
| `KillObject(objectName)` | Kills the object; flags are returned to their start location. |
| `RespawnObject(objectName)` | Respawns the specified object. |
| `SetProperty(name, property, value)` | Sets a property value for the specified object. |

# Entities
| Function | Description |
| :--- | :--- |
| `FindEntityClass(className)` | Returns the entity class of the specified class name. |
| `GetEntityPtr(object)` | Returns the entity pointer of the specified object or character unit index. |
| `GetEntityName(entity)` | Returns the name of the specified entity. |
| `GetEntityClass(entity)` | Returns the class of the entity. |
| `GetEntityClassName(entity)` | Returns the class name string of the specified entity. |
| `SetEntityMatrix(entity, matrix)` | Sets the transformation matrix of the specified entity. |
| `GetEntityMatrix(entity)` | Returns the transformation matrix of the specified entity. |
| `CreateEntity(class, matrix, name)` | Creates a new instance of the specified entity. |
| `DeleteEntity(entity)` | Deletes the specified entity instance. |
| `GetEntityClassPtr(entity)` | Returns the entity class pointer. |
| `EntityFlyerTakeOff(flyer)` | Forces the specified flyer to take off. |
| `EntityFlyerLand(flyer)` | Forces the specified flyer to land. |
| `EntityFlyerInitAsFlying(flyer)` | Initializes the flyer in a flying state. |
| `EntityFlyerInitAsLanded(flyer)` | Initializes the flyer in a landed state. |
| `EnterVehicle(entity, vehicle)` | Forces the specified entity into the specified vehicle. |
| `ExitVehicle(entity)` | Forces the specified entity out of its current vehicle. |
| `GetScreenPosition(entity)` | Returns the screen coordinates relative to the entity. |
| `AddShieldStrength(entity, value)` | Adds the specified amount to the entity’s `MaxShields`. |

# Characters
| Function | Description |
| :--- | :--- |
| `GetTeamMember(team, unitIdx)` | Returns the character index of a specific unit on a team. |
| `GetCharacterTeam(characterIdx)` | Returns the team index of the specified character. |
| `SelectCharacterTeam(char, team)` | Manually selects the team for the character. |
| `IsCharacterHuman(characterIdx)` | Returns `true` if the character is a human player. |
| `SelectCharacterClass(char, class)` | Manually selects the class for the character. |
| `GetCharacterClass(characterIdx)` | Returns the numeric index of the character's class (starting at 0). |
| `SpawnCharacter(idx, pathPoint)` | Spawns the character at the specified path node. |
| `GetCharacterUnit(characterIdx)` | Returns the entity pointer for the character index. |
| `GetCharacterVehicle(idx)` | Returns the vehicle entity pointer for the character index. |
| `GetCharacterRemote(entity)` | Returns the integer index from a RemoteTerminal entity. |
| `GetCharacterControllable(entity)` | Returns the vehicle index from a Controllable entity. |
| `CanCharacterInteractWithFlag(idx)` | Returns whether the character can interact with flags. |
| `GetFlagCarrier(flag)` | Returns the character unit carrying the specified flag. |

# World Animations
| Function | Description |
| :--- | :--- |
| `PlayAnimation(groupName)` | Resumes playback of the specified animation group. |
| `PauseAnimation(groupName)` | Pauses the animation group. |
| `RewindAnimation(groupName)` | Rewinds the animation group to the start. |
| `SetAnimationStartPoint(group)` | Sets current object positions as the new start point. |
| `PlayAnimationFromTo(group, b, e)` | Plays the animation group from `beginTime` to `endTime`. |

# Particle Effects
| Function | Description |
| :--- | :--- |
| `CreateEffect(effectFilename)` | Spawns a new particle effect and returns its handler. |
| `RemoveEffect(effect)` | Deletes the specified particle effect instance. |
| `AttachEffectToObject(fx, obj)` | Attaches the particle effect to a game object. |
| `AttachEffectToMatrix(fx, mat)` | Attaches the particle effect to a transformation matrix. |
| `GetEffectMatrix(effect)` | Returns the transformation matrix of the effect instance. |
| `SetEffectMatrix(effect, mat)` | Sets the transformation matrix of the effect instance. |
| `IsEffectActive(effect)` | Returns whether the particle effect is currently active. |
| `SetEffectActive(effect, active)` | Sets the active state of the specified particle effect. |

# Utility
| Function | Description |
| :--- | :--- |
| `ReadDataFile(sourceFilename)` | Loads a LVL file (with optional sub‑LVLs). |
| `ReadDataFileInGame(filename)` | Loads a LVL file during gameplay runtime. |
| `SetClassProperty(class, prop, val)`| Sets a default property for an object class. |
| `EnableFlyerPath(pathID, enable)` | Enables/disables a flyer path for entity following. |
| `CreateMatrix(rotRadians, rotX, rotY, rotZ, posX, posY, posZ, matrix)` | Creates a new matrix from rotation, position, and starting point.|
| `GetPathPoint(pathName, nodeIdx)` | Returns the path point of the specified node. |
| `SetupTempHeap(bytes)` | Allocates a temporary memory pool. |
| `ClearTempHeap()` | Clears the temporary memory pool. |
| `SetPS2ModelMemory(bytes)` | Sets extra PS2-specific model memory. |
| `StealArtistHeap(bytes)` | Takes memory from the art heap on the PS2 to reallocate. |
| `SetState(state)` | Restarts the game shell/interface. |
| `BeginScreenTransition(viewport, fadeInTime, fadeHoldTime, fadeOutTime, fadeEffect)` | Begins a screen transition with custom timing and types: "FADE" or "SWIPE_RAND" on XBOX. |
| `SetHistorical()` | Obsolete; sets mission as historical (SWBF1 legacy). |
| `IsCampaign()` | Returns `1` if using campaign rules. |
| `GetWorldFilename()` | Returns the name of the first `.wld` file loaded. |
| `GetWorldPosition(objectName)` | Returns the `x, y, z` coordinates of an object. |
| `Print("string")` | Prints input to output Bfront2.log file. |
| `ShowMessageText(key, team)` | Prints localized text in the player's HUD message box. |
| `ShowPopup(localizationKey)` | Freezes game and displays a blocking message. |
| `ShowSelectionTextPopup(key)` | Shows a selection popup (e.g., console control choice). |
| `EnableBuildingLockOn(name, b)` | Sets whether a building can be targeted by weapons. |
| `TogglePlanningGraphArcs(conn)` | Toggles blocking for AI planning connections. |
| `BlockPlanningGraphArcs(conn)` | Blocks the specified AI planning connections. |
| `UnblockPlanningGraphArcs(conn)` | Unblocks the specified AI planning connections. |
| `ToggleBarriers(barrierID)` | Toggles enabled state of a specific AI barrier. |
| `EnableBarriers(barrierID)` | Enables the specified AI barrier. |
| `DisableBarriers(barrierID)` | Disables the specified AI barrier. |
| `TranslateAICommand(id)` | Translates AI command numeric IDs to strings. |

# Callbacks
## Character Callbacks
| Function | Description |
| :--- | :--- |
| `OnCharacterDeath(func)` | Triggered when any character dies. |
| `OnCharacterDeathName(func, name)` | Triggered when a character with a specific name dies. |
| `OnCharacterDeathTeam(func, team)` | Triggered when a character of the specified team dies. |
| `OnCharacterDeathClass(func, class)`| Triggered when a character of the specified class dies. |
| `OnCharacterSpawn(func)` | Triggered when any character spawns. |
| `OnCharacterSpawnName(func, name)` | Triggered when a specific character spawns. |
| `OnCharacterSpawnTeam(func, team)` | Triggered when a character of the specified team spawns. |
| `OnCharacterSpawnClass(func, class)`| Triggered when a character of the specified class spawns. |
| `OnCharacterDispensePowerup(func)` | Triggered when a character drops a health/ammo pickup. |
| `OnCharacterDispenseControllable(func)`| Triggered when a controllable item (turret/droid) is dropped. |
| `OnCharacterLandedFlyer(func)` | Triggered when a character lands a flyer. |
| `OnCharacterEnterVehicle(func)` | Triggered when a character enters a vehicle or turret. |
| `OnCharacterChangeClass(func)` | Triggered when a player confirms a class change in the UI. |
| `OnCharacterIssueAICommand(func)` | Triggered when a player issues a command to AI. |
| `ReleaseCharacterDeath(handler)` | Deregisters a death event callback. |
| `ReleaseCharacterSpawn(handler)` | Deregisters a spawn event callback. |

## Command Post Callbacks
| Function | Description |
| :--- | :--- |
| `OnBeginNeutralize(func)` | Triggered when a unit begins neutralizing a CP. |
| `OnAbortNeutralize(func)` | Triggered when a unit stops neutralizing a CP. |
| `OnFinishNeutralize(func)` | Triggered when a unit finishes neutralizing a CP. |
| `OnBeginCapture(func)` | Triggered when a unit begins capturing a neutral CP. |
| `OnFinishCapture(func)` | Triggered when a unit finishes capturing a neutral CP. |
| `OnCommandPostKill(func)` | Triggered when a Command Post is destroyed. |
| `OnCommandPostRespawn(func)` | Triggered when a Command Post spawns/respawns. |
| `ReleaseFinishCapture(handler)` | Deregisters a capture completion event handler. |

## Flag Callbacks
| Function | Description |
| :--- | :--- |
| `OnFlagPickUp(func)` | Triggered when a character picks up a Flag. |
| `OnFlagDrop(func)` | Triggered when a character drops a Flag. |
| `OnFlagReturn(func)` | Triggered when a character returns an allied Flag. |
| `OnFlagCapture(func)` | Triggered when a character captures a neutral/enemy Flag. |
| `OnFlagReset(func)` | Triggered when a flag resets. |
| `ReleaseFlagCapture(handler)` | Deregisters a flag capture event handler. |

## Object Callbacks
| Function | Description |
| :--- | :--- |
| `OnObjectCreate(func)` | Triggered on creation, before properties are set. |
| `OnObjectInit(func)` | Triggered after initialization and properties are set. |
| `OnObjectDamage(func)` | Triggered whenever an Object takes damage. |
| `OnObjectRepair(func)` | Triggered when a character finishes repairing an Object. |
| `OnObjectHack(func)` | Triggered when a character hacks a vehicle. |
| `OnObjectKill(func)` | Triggered when an Object is destroyed. |
| `OnObjectHeadshot(func)` | Triggered when a soldier entity is shot in the head. |
| `OnObjectRespawn(func)` | Triggered when an Object respawns. |
| `OnObjectDelete(func)` | Triggered when an Object is deleted. |
| `OnTeamChange(func)` | Triggered when an Object changes teams. |
| `OnHealthChange(func)` | Triggered when an Object’s health changes. |
| `OnShieldChange(func)` | Triggered when an Object’s shield changes. |
| `ReleaseObjectKill(handler)` | Deregisters an object death event handler. |

## Region Callbacks
| Function | Description |
| :--- | :--- |
| `OnEnterRegion(func, region)` | Triggered when a Character enters a Region. |
| `OnLeaveRegion(func, region)` | Triggered when a Character leaves a Region. |
| `ReleaseEnterRegion(handler)` | Deregisters an enter region event handler. |
| `ReleaseLeaveRegion(handler)` | Deregisters a leave region event handler. |

## Team Callbacks
| Function | Description |
| :--- | :--- |
| `OnTicketCountChange(func)` | Triggered when reinforcement counts change. |
| `OnTicketBleedChange(func)` | Triggered when reinforcement bleed rates change. |
| `ReleaseTicketCountChange(h)` | Deregisters a ticket count event handler. |

## Timer Callbacks
| Function | Description |
| :--- | :--- |
| `OnTimerElapse(func, timer)` | Triggered when a timer reaches zero. |
| `ReleaseTimerElapse(handler)` | Deregisters a timer elapse event handler. |

# Interface Scripting
This infomation was pulled from a helpful Gametoast forum post by jedimoose32.

## Overview
The interface system consists of objects inheriting from a base C-level API. While custom object types cannot be created, existing types are highly extensible. 

**Note:** In the shell, boolean logic typically uses `1` for true and `nil` for false.

| Component | Description |
| :--- | :--- |
| `IFShellScreen` | A table defining a complete interface screen (buttons, images, text). |
| `Enter(this, bFwd)`| Lifecycle function run when entering the screen. |
| `Update(this, fDt)`| Lifecycle function run every frame (approx. every 0.125s). |
| `Exit(this, bFwd)` | Lifecycle function run when leaving the screen. |
| `Input_Back(this)` | Triggered by "Back" inputs (e.g., ESC key). |
| `Input_Accept(this)`| Triggered by "Accept" inputs (e.g., Left-click, Enter). |
| `IFContainer` | A grouping object/template used to share properties among children. |
| `IFText` | A text box element. |
| `IFImage` | An image element. |
| `this` | Reference to the current screen table being defined. |
| `AddIFScreen()` | Registers the defined table as an active game screen. |

## Objects & Properties
| Object Type | Available Properties |
| :--- | :--- |
| **Common** | `type`, `x`, `y`, `width`, `height`, `alpha`, `ScreenRelativeX`, `ScreenRelativeY`, `ZPos`, `vis`, `ColorR`, `ColorG`, `ColorB` |
| `NewBorder` | `localpos_l`, `localpos_t`, `localpos_r`, `localpos_b`, `localpos_w`, `localpos_h` |
| `NewIFModel` | `scale`, `depth`, `lighting` |
| `NewIFText` | `string`, `font`, `halign`, `valign`, `textw`, `texth`, `style`, `flashy`, `startdelay`, `bg_width`, `bg_tail`, `bgleft`, `bgmid`, `bgright` |
| `NewIFImage` | `texture`, `localpos_l`, `localpos_t`, `localpos_r`, `localpos_b` |
| `NewPCIFButton` | `btnw`, `btnh`, `bg_width`, `hotspot_x/y`, `hotspot_width/height`, (Supports `IFText` properties) |
| `NewEditBox` | `string`, `MaxChars`, `MaxLen`, `bPasswordMode` |
| `NewHSlider` | `thumbwidth`, `thumbposn`, `texturebg`, `texturefg` |
| `NewIFContainer` | (Inherits **Common** properties) |
| **Animation** | `fTotalTime`, `fStartAlpha/fEndAlpha`, `fStartX/fEndX`, `fStartY/fEndY`, `fStartW/fEndW`, `fStartH/fEndH` |

## Functions
### General Object (`IFObj`)
| Function | Description |
| :--- | :--- |
| `IFObj_fnSetZPos(obj, z)` | Sets the object's depth layer (1 is front, 99 is back). |
| `IFObj_fnSetPos(obj, x, y, z)` | Sets position coordinates. Pass `nil` to maintain current values. |
| `IFObj_fnSetVis(obj, vis)` | Sets visibility (`1` or `nil`). |
| `IFObj_fnGetVis(obj)` | Returns boolean visibility. |
| `IFObj_fnSetColor(obj, r, g, b)`| Sets RGB color (0-255). |
| `IFObj_fnSetAlpha(obj, alpha)` | Sets transparency (0.0 to 1.0). |
| `IFObj_fnCreateHotspot(obj)` | Enables click/hover interactivity for the object. |
| `IFObj_fnTestHotSpot(obj)` | Returns true if the object's hotspot was triggered. |

### Text (`IFText`)
| Function | Description |
| :--- | :--- |
| `IFText_fnSetString(obj, str)` | Sets the text string or localization key. |
| `IFText_fnSetFont(obj, font)` | Sets the font (e.g., `"gamefont_medium"`). |
| `IFText_fnSetScale(obj, h, v)` | Sets scale; may cause visual distortion. |
| `IFText_fnSetLeading(obj, val)` | Sets line spacing (leading). |
| `IFText_fnGetExtent(obj)` | Returns the pixel width of the current string. |
| `IFText_fnGetDisplayRect(obj)` | Returns `L, T, R, B` extents from the object origin. |
| `IFText_fnSetTextBox(obj, w, h)`| Configures dimensions for the internal text buffer. |
| `IFText_fnSetTextBreak(obj, type)`| Sets line break behavior (usually `"none"`). |

### Image (`IFImage`)
| Function | Description |
| :--- | :--- |
| `IFImage_fnSetTexturePos(obj, l, t, r, b)` | Sets UV/Position offsets from the center of the image. |
| `IFImage_fnSetTexture(obj, tex, alpha)` | Sets the texture name and optional transparency. |

### Model (`IFModel`)
| Function | Description |
| :--- | :--- |
| `IFModel_fnSetMsh(obj, msh)` | Sets the `.msh` model referenced in assets. |
| `IFModel_fnSetOmegaY(obj, omega)`| Sets Y-axis rotation frequency. |
| `IFModel_fnSetScale(obj, scale)` | Sets 3D model scale. |
| `IFModel_fnSetDepth(obj, z)` | Sets model depth position. |
| `IFModel_fnAttachModel(obj, model, hp)` | Attaches a child model to a specific hardpoint. |
| `IFModel_fnSetTranslation(obj, x, y, z)` | Sets the 3D relative position. |
| `IFModel_fnSetRotation(obj, s, x, y, z)` | Sets the rotation; `s` is typically `nil`. |

### Animation & Screen Management
| Function | Description |
| :--- | :--- |
| `AnimationMgr_ClearAnimations(obj)` | Removes all active animations from an object. |
| `AnimationMgr_AddAnimation(obj, t)` | Adds an animation using a template table. |
| `AddIFScreen(table, name)` | Finalizes and registers the screen table to the engine. |
| `ScriptCB_GetFontHeight(font)` | Returns the pixel height of a font. |
| `ScriptCB_EnableCursor(toggle)` | Toggles the visibility of the mouse cursor (`1` or `nil`). |
| `ScriptCB_PushScreen(name)` | Loads a registered screen onto the UI stack. |
| `ScriptCB_PopScreen()` | Removes the active top-level screen from the stack. |
| `ScriptCB_GetScreenInfo()` | Returns `width, height` (along with several other engine values). |

## Examples
### Additional in-game elements
```lua
-- This script will create an interface overlay that simulates additional HUD elements

local screenWidth, screenHeight = ScriptCB_GetScreenInfo() -- get the screen dimensions, could come in handy later
local lock = 0
local txtLock = false

ifs_assnstars = NewIFShellScreen { -- my screen name here is ifs_assnstars, if this followed my example it would be ifs_blindness

bNohelptextPC = 1,
bNohelptext_back = 1, -- making this 1 would remove the default "back" button
bNohelptext_backPC = 1, -- PC version of variable, potentially useless
bNohelptext_accept = 1, -- Remove the default "accept" button
bg_texture = nil, -- Background texture name
movieBackground = nil, -- We don't have a movie background
movieIntro = nil, -- We don't have a movie intro
bDimBackdrop = nil, -- Dims backdrop if 1

Enter = function(this, bFwd) -- runs once on entering the screen
gIFShellScreenTemplate_fnEnter(this, bFwd) -- a generic function, does behind-the-scenes stuff, don't worry about this at all, ever

AnimationMgr_ClearAnimations(this.starUpdate) -- clears some animations for text that will be defined later
AnimationMgr_ClearAnimations(this.livesCounter)

IFObj_fnSetVis(this.starUpdate, nil) -- this makes the starUpdate text invisible

-- getting information from the Assassination gamemode is really easy because I set it up as a proper gamemode using Lua's limited object-oriented programming
-- capabilities... basically the game stores some basic global variables in the AssassinMode table (e.g. playerLives, below)
-- in my map/mission script (JERc_con) I make an instance of AssassinMode, like so:
-- "assassination = AssassinMode:New{...}" just like conquest, "conquest = ObjectiveConquest:New{...}"
-- you will likely need to implement a similar system for your mode, but I don't know how you've coded yours so maybe I'm wrong
local livesFd = assassination.playerLives
IFText_fnSetString(this.livesCounter, "game.assn.lives" .. livesFd) -- yep, you can change text on the fly this easily
AnimationMgr_AddAnimation(this.livesCounter, { fTotalTime = 3.0, fStartAlpha = 1, fEndAlpha = 0, }) -- the fade-out animation for "lives remaining"

end, -- since NewIfShellScreen is a table, always remember your commas

-- Function runs repeatedly (this = screen name, fDt = function delay time)
Update = function(this, fDt) -- fDt is a timer that elapses and resets every .125 seconds
gIFShellScreenTemplate_fnUpdate(this, fDt) -- another generic, behind-the-scenes function that you can ignore
ScriptCB_EnableCursor(nil) -- you can guess what this is for, really important for a custom HUD overlay

local lvl = assassination:DumpDefconLevel(false) -- get some more info from AssassinMode
if lock ~= lvl and lvl ~= nil then -- this section of code constantly checks to see if the player's stars have updated
lock = lvl
IFObj_fnSetVis(this.starUpdate, 1) -- remember we made this invisible before, we want to show it now
if lvl == 0 then
IFImage_fnSetTexture(this.starC.star1, "assn_star_blank") -- if the player's star level is 0,
IFImage_fnSetTexture(this.starC.star2, "assn_star_blank") -- make all 5 star slots empty
IFImage_fnSetTexture(this.starC.star3, "assn_star_blank")
IFImage_fnSetTexture(this.starC.star4, "assn_star_blank")
IFImage_fnSetTexture(this.starC.star5, "assn_star_blank")
IFText_fnSetString(this.starUpdate, "ANONYMOUS") -- look at us changing text on the fly again... remember this line when I discuss text boxes
else
for i=1, lvl do
IFImage_fnSetTexture(this.starC["star" .. i], "assn_star_active") -- if the star level is >=1 then show the correct number of stars
end
IFText_fnSetString(this.starUpdate, "game.assn." .. lvl .. "star") -- and some text to tell us how many
end
end

local txtFd = assassination.textFade -- these next 8 lines are a fade animation for the star update text
if txtLock ~= txtFd and txtFd ~= nil then
txtLock = txtFd
if txtFd == true then
AnimationMgr_AddAnimation(this.starUpdate, { fTotalTime = 5.0, fStartAlpha = 1, fEndAlpha = 0, })
assassination.textFade = false
end
end

end, -- again, never forget commas

-- Function runs on exiting the screen (this = screen name, bFwd = nil unless not backing out)
Exit = function(this, bFwd) -- in my case, nothing needed to happen on exiting the screen
end,

Input_Back = function(this) -- Input_Back is I think only bound to the Esc key
ScriptCB_PopScreen() -- so of course if the player presses escape we want to "pop" (hide) this screen so the player can see the pause menu
end,

-- Function runs on call, button select, or by the default "enter" button (this = screen name)
Input_Accept = function(this)
-- If base class handled this work, then we're done (not sure what this does)
if(gShellScreen_fnDefaultInputAccept(this)) then -- this is another of those things you can leave alone
return
end
--ifelm_shellscreen_fnPlaySound(this.acceptSound) -- you really don't want that jingly "accept button" sound playing every time the player left-clicks
end,

starC = NewIFContainer { -- at last, our first screen object, a container... I used this one for shared star properties (e.g. on-screen y coordinates)
ZPos = 10, -- ZPos is the object's "depth" on screen, 1 is front, 99 is back
ScreenRelativeX = 0.5, -- 0 is left, 1 is right, 0.5 is x-centered
ScreenRelativeY = 0.0, -- 0 is top, 1 is bottom (I'm pretty sure)
x = 0, -- fine-tuning... e.g. ScreenRelativeX=0.5 and x=-10 means the object would be 10 pixels left of center
y = (screenHeight/9.9), -- same here
},

starUpdate = NewIFText { -- new text box
string = "", -- the string field can contain the actual text you want (see "ANONYMOUS", further up) or a localization path (e.g. "level.ABC.mytext")
font = "gamefont_medium", -- tiny, small, medium, large
ZPos = 9,
ScreenRelativeX = 0.5,
ScreenRelativeY = 0.175,
halign = "hcenter", -- horizontal alignment, options are left, hcenter, right... there is also a valign property with options top, vcenter, bottom
textw = 150, -- width of the text box
x = -75,
y = 0,
textcolorr = 255, -- self explanatory
textcolorg = 255,
textcolorb = 255,
alpha = 1.0,
nocreatebackground = 1, -- for the love of all things good and holy please leave this as 1
},

livesCounter = NewIFText {
string = "", -- I should mention the reason I've left the string property blank in both my text objects is because they're dynamic so I define them...
font = "gamefont_medium", -- ...on the fly!
ZPos = 8,
ScreenRelativeX = 0.5,
ScreenRelativeY = 0.2,
halign = "hcenter",
textw = 150,
x = -75,
y = 0,
textcolorr = 255,
textcolorg = 255,
textcolorb = 255,
alpha = 1.0,
nocreatebackground = 1,
},

}

-- okay this is the doSomething function that I mentioned in Part 3... this all could have been defined in NewIFShellScreen
-- remember my container's name was starC, and also remember that "this" refers to the interface screen we're working on
-- so all of these lines inside the doStars function could read as ifs_assnstars.starC....
-- texture property for images cannot be handled by a container, I believe the same applies to the string property for text boxes
-- in our example, the texture would = "blackness"
-- localpos_l, _t, _r, _b (left, top, right, bottom) define how far from origin the image should extend
-- my star images were made 32x32 pixels so these properties extend the image 16 pixels in each direction
-- in your case you will probably want to use -(screenWidth/2), -(screenHeight/2), screenWidth/2, and screenHeight/2
function doStars(this)
this.starC["frame1"] = NewIFImage { x = -68, texture = "assn_star_frame", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["frame2"] = NewIFImage { x = -34, texture = "assn_star_frame", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["frame3"] = NewIFImage { x = 0, texture = "assn_star_frame", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["frame4"] = NewIFImage { x = 34, texture = "assn_star_frame", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["frame5"] = NewIFImage { x = 68, texture = "assn_star_frame", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }

this.starC["star1"] = NewIFImage { ZPos = 9, x = -68, texture = "assn_star_blank", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["star2"] = NewIFImage { ZPos = 9, x = -34, texture = "assn_star_blank", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["star3"] = NewIFImage { ZPos = 9, x = 0, texture = "assn_star_blank", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["star4"] = NewIFImage { ZPos = 9, x = 34, texture = "assn_star_blank", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
this.starC["star5"] = NewIFImage { ZPos = 9, x = 68, texture = "assn_star_blank", localpos_l = -16, localpos_t = -16, localpos_r = 16, localpos_b = 16, }
end

doStars(ifs_assnstars) -- can't forget to actually execute the doStars function
doStars = nil -- once it's done we can clear it from memory, it only needs to run once

AddIFScreen(ifs_assnstars, "ifs_assnstars") -- I don't know exactly how this works but just put ifs_blindness (or whatever you've named yours) in here twice.
```

### Additional in-game menus
```lua
-- This script will allow the player to set the difficulty options for Assassination mode in-game. This is my first try at anything shell or interface related.

local screenWidth, screenHeight = ScriptCB_GetScreenInfo() -- it's always good practice to do this at the start of all your ifs files

local CurPreset = 2 -- here I'm defining some local variables
local presetStrTable = {"Easy", "Normal", "Hard", "Brutal"} -- strings for the button labels
local losStrTable = {"Short", "Medium", "Far", "Very Far", "Very Far"}
local starStrTable = {"Long", "Average", "Short",}
local assnlos = 16 -- multipliers for difficulty settings...
local radmult = 3
local plives = 3
local evmult = 2
local isHelpUp = false -- is the help textbox visible?

ifsassndiff_vbutton_layout = { -- you can call this whatever you want, it's just a framework for the vertical buttons but it doesn't get initialized until the end
ySpacing = 5, -- ...which is xxxxxxx_vbutton_layout, where xxxxxxx can be whatever you want
width = 260, -- ySpacing was the number of pixels between the buttons vertically, width is self-explanatory
font = gMenuButtonFont, -- gMenuButtonFont is a global variable defined in interface_util.lua which contains lots of globals
buttonlist = { -- alright, now we're getting somewhere. this is a table of buttons, and each button in this table is itself a table
{ tag = "presets", string = "PRESET: "..presetStrTable[CurPreset], }, -- important key-value pairs for buttons are: ...
{ tag = "addlives", string = "+ Player Lives ("..plives..")", }, -- tag, which is just the in-script name you're giving the button...
{ tag = "sublives", string = "- Player Lives ("..plives..")", }, -- and string, which is the in-game name for the button...
{ tag = "guardlos", string = "Guard LOS: "..losStrTable[(assnlos/8)], }, -- don't forget your commas, people,,,,,
{ tag = "guardradios", string = "Radio Distance: "..losStrTable[((radmult/2)+0.5)], },
{ tag = "evademult", string = "Star Delay: "..starStrTable[4-evmult], },
{ tag = "help", string = "Toggle Help", },
},
title = "Difficulty Settings", -- title is a string (which can be a localized string e.g. "level.ABC.blah", goes above the buttons
-- see the pause menu for a good example of what a similar vertical button layout looks like in-game
}

ifs_assndiff = NewIFShellScreen { -- we've seen this before

bNohelptextPC = nil, -- nothing new to see here, move along citizen
bNohelptext_back = nil,
bNohelptext_backPC = nil, -- oh wait this is new... we now have a default generated back button in the corner
bNohelptext_accept = nil,
bg_texture = nil,
movieBackground = nil,
movieIntro = nil,
bDimBackdrop = 1, -- we didn't do this last time, but now I want a dim backdrop so deal with it

Enter = function(this, bFwd)
gIFShellScreenTemplate_fnEnter(this, bFwd)

this.CurButton = ShowHideVerticalButtons(this.buttons, ifsassndiff_vbutton_layout) -- this makes it so the currently selected...
-- ...object is the vertical button list. this is more important than you may realize, so just do it okay?
IFObj_fnSetVis(this.helptext, nil)

end,

Update = function(this, fDt) -- remember the update function runs every .125 seconds, or 8 times per second
gIFShellScreenTemplate_fnUpdate(this, fDt)

plives, assnlos, radmult, evmult = assassination:DumpDiffScreenInfo(false) -- this is a method from AssassinMode.lua that gives...
-- ...me important info about the current difficulty multipliers and the amount of remaining lives the player has
RoundIFButtonLabel_fnSetString(this.buttons.addlives, "+ Player Lives ("..plives..")") -- this.buttons.<button tag name without quotes>
RoundIFButtonLabel_fnSetString(this.buttons.sublives, "- Player Lives ("..plives..")")
RoundIFButtonLabel_fnSetString(this.buttons.presets, "PRESET: "..presetStrTable[CurPreset])
RoundIFButtonLabel_fnSetString(this.buttons.guardlos, "Guard LOS: "..losStrTable[assnlos/8]) -- yep, we can do math in here too!
RoundIFButtonLabel_fnSetString(this.buttons.guardradios, "Radio Distance: "..losStrTable[((radmult/2)+0.5)])
RoundIFButtonLabel_fnSetString(this.buttons.evademult, "Star Delay: "..starStrTable[4-evmult]) -- the lesson here is the function...
-- RoundIFButtonLabel_fnSetString(button, string) is what you use to update a button's text on the fly

end,

Exit = function(this, bFwd) -- ignore this, I never ended up using it in the end, but you may want to
--assassination.loadHUD = true
end,

Input_Back = function(this) -- when the player presses escape...
ScriptCB_SndPlaySound("shell_menu_exit") -- play the fun BOOP BOOP noise
ScriptCB_PopScreen() -- and pop (i.e. kill) the top-most screen, which is this one
end,

Input_Accept = function(this) -- so this is where we make stuff happen whenever a button gets pressed
if(gShellScreen_fnDefaultInputAccept(this)) then
return -- wow, much cool, very excite, wow
end

if this.CurButton then -- check to see if a button was hovered/selected when the accept key was pressed
ifelm_shellscreen_fnPlaySound(this.acceptSound) -- if so, play the accept jingle sound
end -- this means that you can't get the lovely accept jingle sound by just clicking anywhere on the background

-- okay this is a really big if-elseif so get ready... I promise this is actually how they do it in the stock files too
if this.CurButton == "_back" then -- side note: _back is the default generated back button, remember bNohelptext_backPC = nil?
ScriptCB_PopScreen() -- pop it
elseif this.CurButton == "presets" then -- if the button that was pressed was presets then...

if CurPreset < 4 then -- you can skip down to the next comment, this is all boring and unimportant
CurPreset = CurPreset + 1
elseif CurPreset >= 4 then
CurPreset = 1
end

if CurPreset == 1 then
assassination.maxplayerLives = 5
assassination.playerLives = 5
assassination.guardLOS = 8
assassination.guardRadioMult = 1
assassination.starMult = 3
elseif CurPreset == 2 then
assassination.maxplayerLives = 3
assassination.playerLives = 3
assassination.guardLOS = 16
assassination.guardRadioMult = 3
assassination.starMult = 2
elseif CurPreset == 3 then
assassination.maxplayerLives = 1
assassination.playerLives = 1
assassination.guardLOS = 24
assassination.guardRadioMult = 5
assassination.starMult = 1
elseif CurPreset == 4 then
assassination.maxplayerLives = 1
assassination.playerLives = 1
assassination.guardLOS = 40
assassination.guardRadioMult = 9
assassination.starMult = 1
end

elseif this.CurButton == "addlives" then -- still boring, but just wanted to reinforce that this is a different button now

assassination.maxplayerLives = assassination.maxplayerLives + 1
assassination.playerLives = assassination.playerLives + 1

elseif this.CurButton == "sublives" then -- and yet another...

if plives > 1 then
assassination.maxplayerLives = assassination.maxplayerLives - 1
assassination.playerLives = assassination.playerLives - 1
end

elseif this.CurButton == "guardlos" then

if assnlos == 8 then
assassination.guardLOS = 16
elseif assnlos == 16 then
assassination.guardLOS = 24
elseif assnlos == 24 then
assassination.guardLOS = 40
elseif assnlos == 40 then
assassination.guardLOS = 8
end

elseif this.CurButton == "guardradios" then

if radmult == 1 then
assassination.guardRadioMult = 3
elseif radmult == 3 then
assassination.guardRadioMult = 5
elseif radmult == 5 then
assassination.guardRadioMult = 9
elseif radmult == 9 then
assassination.guardRadioMult = 1
end

elseif this.CurButton == "evademult" then

if evmult ==3 then
assassination.starMult = 2
elseif evmult == 2 then
assassination.starMult = 1
elseif evmult == 1 then
assassination.starMult = 3
end

elseif this.CurButton == "help" then -- okay let's jump in here

if isHelpUp == true then -- this button toggles the help text box
IFObj_fnSetVis(this.helptext, nil) -- if help is already displayed then hide it with IFObj_fnSetVis(object, nil)
isHelpUp = false -- and then change the local variable
elseif isHelpUp == false then -- otherwise...
IFObj_fnSetVis(this.helptext, 1) -- make it visible with IFObj_fnSetVis(object, 1)
isHelpUp = true -- cool
end

end

--ifelm_shellscreen_fnPlaySound(this.acceptSound) --we only want this on actual buttons though

end,

buttons = NewIFContainer { -- remember containers?
ScreenRelativeX = 0.5, -- I want my buttons centered on both axes
ScreenRelativeY = 0.5,
},

helptext = NewIFText { -- here's a text box
string = "+/- Player Lives -- The number of lives the player is allowed.\nGuard LOS -- The distance from which guards can detect the player.\nRadio Distance -- The range of the guards' radio calls for backup.\nStar Delay -- The time delay between gaining new stars.",
font = "gamefont_small",
ZPos = 1,
ScreenRelativeX = 0.5,
ScreenRelativeY = 0.78,
halign = "hcenter",
textw = 800,
texth = 300,
x = -400,
y = 0,
textcolorr = 255,
textcolorg = 255,
textcolorb = 255,
alpha = 1.0,
nocreatebackground = 1, -- seriously don't do it
},

}

function doDiffs(this) -- this ended up being redundant
--this.bg_texture = "BG_texture"
end

doDiffs(ifs_assndiff) -- soooooo redundant
doDiffs = nil

--okay pay attention here - this is where we actually go ahead and lay out the buttons that we defined at the beginning
ifs_assndiff.CurButton = AddVerticalButtons(ifs_assndiff.buttons,ifsassndiff_vbutton_layout)

AddIFScreen(ifs_assndiff, "ifs_assndiff") -- add this to the list of screens and we're done!
```

# Un-Official Patch Scripts
The unoffical patch made and maintained by the modding community adds scripting features lacking in the official release. These include user_scripts and custom galactic conquest (gc) scripts. These scripts and added functions are considered fundamental to modders, and are often required for for many mods to correctly function.

## Userscripts
User_scripts are loaded and processed at the start of game_interface.lua, during mission startup. They allow for arbitrary code to be injected in-game during a mission, primarily used to add fakeconsole commands for a map, but can do nearly anything `Script_PostLoad` in a mission script can do.

### Userscript Creation
Each userscript must have a unique slot assigned, starting at `0` e.g., `user_script_0.lvl`. To increase compatibility it is encouraged to make copies using different slots so players can drop in whichever slot they have free. The compiled `.lvl` file should at least contain a lua script named "user_script_int", where "int" is the chosen slot for this userscript. You may include additional scripts or assets, but the base user_script lua file is required as an entrypoint. Additional scripts or assets can be then imported with `ScriptCB_DoFile()` or `ReadDataFile()` respectively from the entrypoint. Upon in-game mission start, `GameData\Data\_LVL_PC` will be scanned and all found `.lvl` files starting with `user_script_` will be imported and run.

### Userscript Example
The shell folder of your data_... addon folder should at least contain a shell.req file to produce a `.lvl` file. It should also have a "scripts" folder containing at least your base user_script_int.lua file as well as any additional scripts. For this example we'll use slot 1.

#### shell.req:
```
ucft
{
    REQN
    {
        "script"
	    "user_script_1"
    }
}
```

#### user_script_1.lua
```
print("user_script_1: Entered")

--attempt to take control of (or listen to the calls of) the ScriptPostLoad function
if ScriptPostLoad then
	print("user_script_1: Taking control of ScriptPostLoad()...")
	
	--check for possible loading errors
	if us1_ScriptPostLoad then
		print("user_script_1: Warning: Someone else is using our us1_ScriptPostLoad variable!")
		print("user_script_1: Exited")
		return
	end
	
	--backup the current ScriptPostLoad function
	us1_ScriptPostLoad = ScriptPostLoad

	--this is our new ScriptPostLoad function
	ScriptPostLoad = function()
	    print("user_script_1: ScriptPostLoad(): Entered")
	    
	    --only do these changes when in SP
	    --if we wanted them done in MP too, we should check to make sure that we are the server's host: ScriptCB_GetAmHost()
	    if not ScriptCB_InMultiplayer() then
		    --build the FakeConsole list
		    ff_rebuildFakeConsoleList()
		    
		    --do the FakeConsole commands we want to happen each time a new map starts (when ScriptPostLoad() is normally called)
		    ff_DoCommand( "Add JetPacks" )	--lets everyone fly
		    ff_DoCommand( "Lock Vehicles" )	--prevents everyone from entering vehicles (not good on space maps...)
		    ff_DoCommand( "Extreme Points" ) --gain lots os points for little work
		    ff_DoCommand( "Remove Award Effects" )	--no more graphical hues or annoying sounds when you get awards
	
			--give humans a health regeneration
			ff_healthRegen( 500, "humans" )
			
			--clear the FakeConsole table to save memory
			gConsoleCmdList = {}
		end

	    --make sure to forward the method call to the real ScriptPostLoad, so the game can function normally
	    us1_ScriptPostLoad()
	    print("user_script_1: ScriptPostLoad(): Exited")
	end
	
	print("user_script_1: Have control of ScriptPostLoad()")
else
	print("user_script_1: Warning: No ScriptPostLoad() to take over")
	print("user_script_1: Exited")
	return
end

print("user_script_1: Exited")
```

## Galactic Conquest Scripts
Galactic Conquest scripts are loaded and processed near the start of shell_interface.lua, during game interface startup. They allow for arbitrary code to be injected into the game interface/shell, primarily used to add custom Galactic Conquests, but can also simply alter the game interface/shell.

### Galactic Conquest Script Creation
Each custom_gc script must have a unique slot assigned, starting at `0` e.g., `custom_gc_0.lvl`. To increase compatibility it is encouraged to make copies using different slots so players can drop in whichever slot they have free. The compiled `.lvl` file should at least contain a lua script named "custom_gc_int", where "int" is the chosen slot for this custom_gc. You may include additional scripts or assets (and must include a few additional scripts for galactic conquest functionality), but the base custom_gc lua file is required as an entrypoint. Additional scripts or assets can be then imported with `ScriptCB_DoFile()` or `ReadDataFile()` respectively from the entrypoint. Upon game interface start, `GameData\Data\_LVL_PC` will be scanned and all found `.lvl` files starting with `custom_gc_` will be imported and run.

### Galactic Conquest Example
The shell folder of your data_... addon folder should at least contain a shell.req file to produce a `.lvl` file. It should also have a "scripts" folder containing at least your base custom_gc_int.lua file as well as a ifs_freeform_init_... and ifs_freeform_start_... lua scripts. For this example we'll use slot 1 and "zer" as era-identifiers.

#### shell.req:
```
ucft
{
    REQN
    {
        "script"
	    "custom_gc_1"
        "ifs_freeform_init_zer"
        "ifs_freeform_start_zer"
    }
}
```

#### custom_gc_1.lua
```lua
--This is the main setup script for a custom Galactic Conquest
print("custom_gc_1: Entered")

-------------------------------------------------------------------------------
-- Those 7 steps are in this section
-------------------------------------------------------------------------------
--Modders, for basic custom Galactic Conquest support
--	you only need to change the variables in this section.
--  If you want to do advanced things, you will need to 
--		learn how the real game does it.
--	If you need to change something else in the game, it is
--		best to 'take control' of the function as done
--		a few times below this section.  This allows you to
--		change parts of the shell without replacing shell.lvl.

--To use this script in your own custom Galactic Conquest,
-- 1) you need to search/replace: cgc1/cgc#
-- 2) you need to search/replace: gc_1/cg_#
--	where '#' is the number of this custom Galactic Conquest

-- 3) this button tag must be unique for each button in the Galactic Conquest screen
local gcTag = "Hunting"

-- 4) this is the string your Galactic Conquest button will use
--	if the game cannot find the a localization version of the string, 
--	it will directly display the text on the button
local gcString = "The Hunting Tournament" --"mods.custom_gc.tht.name"

-- 5) load any other scripts from your custom_gc_1.lvl
ScriptCB_DoFile("ifs_freeform_init_zer")
ScriptCB_DoFile("ifs_freeform_start_zer")

-- 6) this is your script that starts your Galactic Conquest game
local start_gc = ifs_freeform_start_zer

-- 7) read in any strings you need
--ReadDataFile("..\\..\\addon\\XXX\\core.lvl")

-------------------------------------------------------------------------------
-- The end of the 7 step section
-------------------------------------------------------------------------------

--add a button to the shell for our custom Galactic Conquest
if custom_GetGCButtonList then
	print("custom_gc_1: Taking control of custom_GetGCButtonList()...")
	
	--check for possible loading errors
	if cgc1_custom_GetGCButtonList then
		print("custom_gc_1: Warning: Someone else is using our cgc1_custom_GetGCButtonList variable!")
		print("custom_gc_1: Exited")
		return
	end
	
	--backup the current custom_GetGCButtonList function
	cgc1_custom_GetGCButtonList = custom_GetGCButtonList

	--this is our new custom_GetGCButtonList function
	custom_GetGCButtonList = function()
	    print("custom_gc_1: custom_GetGCButtonList(): Entered")
	    
	    --get the button table from the real function
	    local list = cgc1_custom_GetGCButtonList()
	    
	    --add in the button for our Galactic Conqust
	    local ourButton = { tag = gcTag, string = gcString, }
		table.insert( list, 1, ourButton )	    
	    
	    print("custom_gc_1: custom_GetGCButtonList(): Exited")
	    return list
	end
else
	print("custom_gc_1: Warning: No custom_GetGCButtonList() to take over")
	print("custom_gc_1: Exited")
	return
end

--Note: if you want your Galactic Conquest to only be visible at certain times (like when some other GC is completed), you will need to take over the ifs_sp_campaign_fnUpdateButtonVis() and/or ifs_sp_gc_fnUpdateButtonVis() functions (like you did with custom_GetGCButtonList()).  Both of these functions can be found in Common\scripts\PC\ifs_sp_campaign.lua

--listen for when our Galactic Conquest button is clicked
if custom_PressedGCButton then
	print("custom_gc_1: Taking control of custom_PressedGCButton()...")
	
	--check for possible loading errors
	if cgc1_custom_PressedGCButton then
		print("custom_gc_1: Warning: Someone else is using our cgc1_custom_PressedGCButton variable!")
		print("custom_gc_1: Exited")
		return
	end
	
	--backup the current custom_GetGCButtonList function
	cgc1_custom_PressedGCButton = custom_PressedGCButton

	--this is our new custom_GetGCButtonList function
	custom_PressedGCButton = function( tag )
	    print("custom_gc_1: custom_PressedGCButton(): Entered")
	    
	    --not our conquest, so let the game process it normally
	    if tag ~= gcTag then
		    return cgc1_custom_PressedGCButton()
	    end
	    
	    --it is our Galactic Conquest button, so get our game going
	    start_gc(ifs_freeform_main)
	    
	    print("custom_gc_1: custom_PressedGCButton(): Exited")
	    return true
	end
else
	print("custom_gc_1: Warning: No custom_PressedGCButton() to take over")
	print("custom_gc_1: Exited")
	return
end

print("custom_gc_1: Exited")
```

#### ifs_freeform_init_zer.lua
```lua
-- initialize for Zer War
print("ifs_freeform_init_zer.lua")
ifs_freeform_init_zer = function(this, ALL, IMP)
	print("ifs_freeform_init_zer: ifs_freeform_init_zer()")

	-- common init
	ifs_freeform_init_common(this)

	--replacing this table from init_common, by [RDH]Zerted
	-- per-planet camera offsets
	this.cameraOffset = {
		["end"] = { 0, 1, 1 },
		["hot"] = { 0, 1, 1 },
		["tat"] = { 0, 1, 1 },
	}

	-- default victory condition (take all planets)
	this:SetVictoryPlanetLimit(nil)
	
	-- associate codes with teams
	this.teamCode = {
		[ALL] = "all",
		[IMP] = "imp"
	}
	
	-- use Zer setup
	this.Setup = function(this)
		print("ifs_freeform_init_zer: ifs_freeform_init_zer(): Setup()")
	

		-- remove unused planets
		print("ifs_freeform_init_zer: ifs_freeform_init_zer(): Setup(): Removing unused planets")
		DeleteEntity("kam")
		DeleteEntity("kam_system")
		DeleteEntity("geo_system")
		DeleteEntity("end_star")
		DeleteEntity("hot_star")
		DeleteEntity("tantive")
		
DeleteEntity("cor")
DeleteEntity("dag")
DeleteEntity("fel")
DeleteEntity("kam_star")
DeleteEntity("mus")
DeleteEntity("kas")
DeleteEntity("nab")
DeleteEntity("myg")
DeleteEntity("pol")
DeleteEntity("uta")
DeleteEntity("yav")
DeleteEntity("star04")
DeleteEntity("star05")
DeleteEntity("star06")
DeleteEntity("star07")
DeleteEntity("star08")
DeleteEntity("star09")
DeleteEntity("star10")
DeleteEntity("star11")
DeleteEntity("star12")
DeleteEntity("star13")
DeleteEntity("star14")
DeleteEntity("star15")
DeleteEntity("star16")
DeleteEntity("star17")
DeleteEntity("star18")
DeleteEntity("star19")
DeleteEntity("star20")
					
		-- create the connectivity graph
		this.planetDestination = {
			["end"] = { "star02", "star01" },
			["hot"] = { "star01" },
			["tat"] = { "star02", "star01" },
			["star01"] = { "end", "tat", "hot" },
			["star02"] = { "end", "tat" },
		}

		-- resource value for each planet
		this.planetValue = {
			["end"] = { victory = 40, defeat = 9, turn = 3 },
			["hot"] = { victory = 100, defeat = 30, turn = 5 },
			["tat"] = { victory = 40, defeat = 9, turn = 3 },
		}
		
		this.spaceValue = {
			victory = 50, defeat = 20,
		}
		
		-- mission to launch for each planet
		this.spaceMission = {
			["con"] = { "spa1g_ass", "spa8g_ass", "spa9g_ass" }
		}
		this.planetMission = {
			["end"] = {
				["con"] = "end1g_con",
				["hunt"] = "end1g_hunt",
			},
			["hot"] = {
				["con"] = "hot1g_con",
				["hunt"] = "hot1g_hunt",
			},
			["tat"] = {
				["con"] = "tat2g_con",
				["hunt"] = "tat2g_hunt",
			},
		}
		
		-- associate names with teams
		this.teamName = {
			[0] = "",
			[ALL] = "common.sides.all.name",
			[IMP] = "common.sides.imp.name"
		}
		
		-- associate names with team bases
		this.baseName = {
			[ALL] = "ifs.freeform.base.all",
			[IMP] = "ifs.freeform.base.imp"
		}
		
		-- associate names with team fleets
		this.fleetName = {
			[0] = "",
			[ALL] = "ifs.freeform.fleet.all",
			[IMP] = "ifs.freeform.fleet.imp"
		}
		
		-- associate entity class with team fleets
		this.fleetClass = {
			[ALL] = "gal_prp_moncalamaricruiser",
			[IMP] = "gal_prp_stardestroyer"
		}
		
		-- associate icon textures with team fleets
		this.fleetIcon = {
			[ALL] = "all_fleet_normal_icon",
			[IMP] = "imp_fleet_normal_icon"
		}
		this.fleetStroke = {
			[ALL] = "all_fleet_normal_stroke",
			[IMP] = "imp_fleet_normal_stroke"
		}
		
		-- set the explosion effect for each team
		this.fleetExplosion = {
			[ALL] = "gal_sfx_moncalamaricruiser_exp",
			[IMP] = "gal_sfx_stardestroyer_exp"
		}
		
		-- team base planets
		this.planetBase = {
			[ALL] = "tat",
			[IMP] = "end"
		}
		
		-- team potential starting locations
		this.planetStart = {
			[ALL] = { "tat" },
			[IMP] = { "end" },
		}

		print("ifs_freeform_init_zer: ifs_freeform_init_zer(): Setup(): Finished")
	end
end
```

#### ifs_freeform_start_zer.lua
```lua
-- start ALL campaign
print("ifs_freeform_start_zer.lua")
function ifs_freeform_start_zer(this)
	print("ifs_freeform_start_zer(): Entered")

	-- save scenario type
	this.scenario = "zer"
	
	-- assigned teams
	local ALL = 1
	local IMP = 2
	
	-- ZER init
	print("ifs_freeform_start_zer(): Init")
	ifs_freeform_init_zer(this, ALL, IMP)

	-- set to versus play
	ifs_freeform_controllers(this, { [0] = ALL, [1] = ALL, [2] = ALL, [3] = ALL })

	-- ALL start
	this.Start = function(this)
	print("ifs_freeform_start_zer(): Start(): Entered")

		-- perform common start
		ifs_freeform_start_common(this)

	   	-- set team for each planet
   		this.planetTeam = {
			["end"] = IMP,
			["hot"] = IMP,
			["tat"] = ALL,
		}
		
		-- create starting fleets for each team
		this.planetFleet = {}
		for team, start in pairs(this.planetStart) do
			local planet = start[math.random(table.getn(start))]
			this.planetFleet[planet] = team
		end
	end
	print("ifs_freeform_start_zer(): Finished")
end
```

# UnOfficial Patch Additions
The UnOfficial patch added many lua globals and functions for convenience.

## Globals
| Global | Description |
| :--- | :--- |
| `__utility_functions__` | Will = 1 if UnOfficial Patch is installed. |
| `__thisMapsCode__` | String of the loaded map's name e.g., "geo1". |
| `__thisMapsMode__` | String of the loaded map's gamemode/layer e.g., "geo1_conquest". |
| `__TempProcessPlayersFunction__` | Function to run on all players. |
| `uf_classes` | Table of all playable unit classes (Including loaded custom unit classes) |

## Functions
| Function | Description |
| :--- | :--- |
| `uf_processPlayers(function)` | Runs the given function on all players via a table. Table format: `table = {indexstr="num", namestr="playerName"}` |
| `uf_updateClassIndex(className)` | Adds given class to uf_classes table if not already present. |
| `uf_isKnownClass(className)` | Returns index of given class in the uf_classes table, or false if not present. |
| `uf_changeClassProperties(classes, properties)` | Set Class Properties for the given classes table to the given properties table(s). Classes table format: `{"all_inf_engineer", "imp_inf_engineer",}`, Properties table format: `{{name = "JumpHeight", value = "15"},{name = "EnergyRestore", value = "10"},}` |
| `uf_applyFunctionOnTeamUnits(function, property, value, teams, aiOrHuman)` | Runs a given function with property and value arguments on all units of given table of team number(s). `aiOrHuman` should be "ai" or "human" to only affect human or AI units respectively. |
| `uf_changeObjectProperty(property, value, aiOrHuman)` | Changes the given property to the given value for all units on teams 1 and 2. `aiOrHuman` should be `"ai"` or `"human"` to only affect human or AI units respectively. |
| `uf_GetOtherTeam(teamNum)` | Returns 1 if given 2, returns 2 if given 1. |
| `uf_moveToTeam(teamNums, teamNum)` | Changes spawned units from the given teams table to the given team. |
| `uf_killUnits(teamNums, ai)` | Kills the units on the given teams table, `ai` should be true to kill only AI units, false to kill only human units. |
| `uf_addToServerName(add)` | Adds the given string to the beginning of the server's name |
| `uf_removeFromServerName(remove)` | Removes all instances of the given string from the server's name |
| `uf_print(table, nested, depth)` | Attempts to display the contents of the given table. `nested` should be true to recursively print tables inside of the given table, `depth` current nested level. Note that tables that reference themselves will cause an infinite loop. |
