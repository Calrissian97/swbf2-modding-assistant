# Sound System Overview
This document explains how Star Wars Battlefront 2 plays and manages sounds.

Sections:
 - Sound Memory Management (lines 16-22)
 - Sound Effects (lines 25-29)
 - Sound Streams (lines 31-34)
 - Sound File Types (lines 36-47)
 - Technical Constraints (lines 49-66)
 - Sound Library Overview (lines 68-381)
 - Comprehensive Sound Triggering Overview (lines 383-1174)
 - AI VO Hooks (lines 1176-1245)

 ---

# Sound Memory Management
The Battlefront 2 sound engine operates under a notoriously strict **Sound Memory Pool**. Exceeding this limit causes "sound dropping," where random sound effects fail to play.

## Optimization Strategies
*   **Resampling:** Reduce frequency rates to the lowest acceptable quality. Low-frequency rumbles (explosions, engine hums) can be resampled heavily, while sharp transients (blaster bolts) should remain higher.
*   **Aliasing:** Map multiple sound properties to a single sound effect to reduce unique asset counts.
*   **Streaming:** Move long or infrequent audio (music, voice-overs, ambient loops) to "Streams" to bypass the memory pool entirely.

# Sound Categories
## Sound Effects (Memory-Resident)
These are held in system memory for instant, frequent playback.
*   **Format:** `.asfx`
*   **Usage:** Weapons, vehicle engines, unit VO, impacts.
*   **Constraint:** Directly impacts the Sound Memory Pool.

## Sound Streams (Disk-Streamed)
These are streamed from the disk during playback and do not count against the sound memory limit.
*   **Format:** `.stm` (Mono/Stereo) or `.st4` (Surround).
*   **Usage:** Background music, announcer VO, world ambience.

# File Type Definitions

| Extension | Type | Description |
| :--- | :--- | :--- |
| **.snd** | Configuration | The primary text file for naming and configuring sound properties (gain, pitch, roll-off, priority, and reverb spaces). |
| **.asfx** | Effect List | List of relative paths to `.wav` files to be munged into memory-resident sound banks. |
| **.stm** | Stream List | List of relative paths to `.wav` files to be munged into disk-streamed audio banks. |
| **.st4** | Surround List | Specifically for Dolby Pro Logic II surround sound streams (primarily console-focused). |
| **.ffx** | Foley | Defines groupings for footstep and movement sounds based on surface types (dirt, metal, water, etc.). |
| **.mus** | Music | Defines music-specific properties such as fade-in/out times and playback priority. |
| **.wav** | Source Audio | Binary PCM audio. Supports 11,025 Hz to 48,000 Hz at 16-bit. |
| **.sfx** | Stock List | Internal shared sound effect lists for `common.bnk`. **Not used for modding.** |

# Technical Constraints & Requirements
## Formatting Rules
*   **Whitespace:** Tab characters (`\t`) are **invalid** in `.asfx`, `.stm`, and `.st4` files as well as sound hooks in ODF files. Using them will result in sound munge errors or sound hook failure. Use spaces for alignment.
*   **PCM Audio:** Source `.wav` files must be 16-bit PCM.

## Sampling Rates
| Data Type | Min Frequency | Max Frequency |
| :--- | :--- | :--- |
| **Effects (.asfx)** | 22,050 Hz | 44,100 Hz |
| **Streams (.stm / .st4)** | 44,100 Hz | 48,000 Hz |
| **Source (.wav)** | 11,025 Hz | 48,000 Hz |

## Platform Differences
*   **PC:** Utilizes a shared `common.bnk` for global sound effects.
*   **Consoles:** Even more restricted memory pools. Generally require lower sampling rates and more aggressive aliasing than the PC version.

## Munging Process
Sound assets are compiled into `.lvl` files. If errors occur during the process, they are recorded in the sound munge logs within the addon's `_BUILD` directory. Use the updated munge scripts to ensure compatibility with modern Windows operating systems, which can be found here: https://app.box.com/s/4nuc1a9qc590lrp40cuaax9ny5aw78ed.

# Sound Library Overview
SoundFL - Frontline sound library (FrontLine was the prototype name for Battlefront)
The Frontline sound library is dependent upon the Pebble sound library for 
vector operations, random math, list templates and name hashing.

## Configurations
Configurations for SoundFL should be created using the ConfigMunge application.
Configurations are specified in the following schema:
> Note: optional parameters are enclosed in [] and compulsory parameters are enclosed in <>
```
<objectID>()
{
    <propertyID0>(propertyvalue);
    <propertyID1>(propertyvalue);
                 ...
    <propertyIDN>(propertyvalue);
    
    <subObjectID>()
    {
    }
}
```

### ObjectID : Sound
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the sound object. |
| **Group** | Identifier used for grouping sounds. |
| **Inherit** | Name of a sound object to inherit parameters from. |
| **Pitch** | Base pitch value (0.0 to 1.0). |
| **PitchDev** | Range for pitch randomization (e.g., 0.5 with pitch at 0.5 varies between 0.0 and 1.0). |
| **Gain** | Base volume/gain value (0.0 to 1.0). |
| **GainDev** | Range for gain randomization. |
| **ReverbGain** | Volume of the reverb effect send. |
| **Bus** | Audio bus to which this sound is routed. |
| **Looping** | Enables looping (1 = on, 0 = off). |
| **Pan** | Stereo panning (-1.0 to 1.0). |
| **RollIn** | Slope controlling volume ramp-up based on distance (default 0.0). -1.0 reaches max gain immediately; higher values make it linear or slower. |
| **RollInDistance** | Distance where gain becomes maximum. Gain is 0 at distance 0 if > 0. Must be <= MinDistance. |
| **MinDistance** | Distance at which sound remains at maximum volume. |
| **MuteDistance** | Distance where the sound is muted (must be <= MaxDistance). |
| **MaxDistance** | Distance where sound gain becomes 0.0. |
| **RollOff** | Slope controlling volume attenuation between MinDistance and MaxDistance. |
| **Mode3D** | Enables 3D positional audio (1 = 3D, 0 = 2D). |
| **ModeDoppler** | Enables Doppler shift effects (1 = enabled, 0 = disabled). |
| **Bias** | Balance between distance-based priority (0.0) and property-based priority (1.0). |
| **Priority** | Playback priority (0.0 to 1.0) when hardware limits are reached. |
| **PlayProbability** | Chance for the sound to play when triggered (0.0 to 1.0). |
| **PlayInterval** | Seconds to wait before allowing the sound to trigger again. |
| **PlayIntervalDev** | Seconds to vary the `PlayInterval` by. |
| **RandomPlayPos** | Starts playback at a random time in the sample (1 = on). |
| **CyclePlayback** | Controls sample selection: <br/>0: Random selection. <br/>1: Cycle starting randomly. <br/>2: Cycle starting at the first sample. <br/>3: Random selection without immediate repeats. |
| **SpaceDistance** | Distance a source center can leave a defined space while remaining classified as within it. |

### Sound.SubObjectID : SampleList
| Property | Description |
| :--- | :--- |
| **Sample** | `Sample("sampleName", weight[, playInterval, playIntervalDev])`. Specifies a sample from a loaded bank and its selection weight. Optional intervals enforce retrigger delays. |

Example:
```
Sound()
{
    Name("explosion")   
    Pitch(0.9);
    PitchDev(0.1);
    Gain(0.6);
    GainDev(0.2);
    ReverbGain(1.0);
    Bus("soundfxbus");
    Looping(0);
    Pan(0.0);
    RollIn(10.0);
    RollInDistance(0.0);
    MinDistance(1.0);
    MuteDistance(140.0);
    MaxDistance(140.0);
    RollOff(1.0);
    Mode3D(1);
    Bias(0.5);
    Priority(0.5);
    SampleList()
    {
        Sample("explosion_variation0", 0.5);
        Sample("explosion_variation1", 0.5);
    }
}
```

### ObjectID : Bus
Sounds or SoundStreams can be routed to buses. A bus is used to control the gain of a group of Sounds and SoundStreams. Buses can be arranged heirachically with each bus potentially having many sub-buses.

| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the audio bus. |
| **Gain** | Overall gain/volume of the bus. |
| **Parent** | Name of the parent bus (default is "Root"). |
| **AttenuateBus** | Name of a bus to lower the volume of when this bus is active. |
| **AttenuationLeadIn** | Duration of the volume fade when attenuation begins. |
| **AttenuationLeadOut** | Duration of the volume fade when attenuation ends. |
| **Attenuation** | Amount of attenuation to apply (0.0 to 1.0). |
| **Mute** | Mutes all sounds on this bus. |
| **Solo** | Solos this bus, muting all others. |


### ObjectID : SoundStream
The SoundStream object is similar to the Sound object except that it controls parameters of an audio stream instead of a samples played from sample memory. The number of streams is limited by the media bandwidth available.

| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the sound stream. |
| **Group** | Identifier used for grouping streams. |
| **Inherit** | Name of a stream object to inherit parameters from. |
| **Pitch** | Base pitch value (0.0 to 1.0). |
| **PitchDev** | Range for pitch randomization. |
| **Gain** | Base volume/gain value (0.0 to 1.0). |
| **GainDev** | Range for gain randomization. |
| **ReverbGain** | Volume of the reverb effect send. |
| **Bus** | Audio bus for this stream. |
| **Looping** | Enables looping (1 = on, 0 = off). |
| **Pan** | Stereo panning (-1.0 to 1.0). |
| **RollIn** | Slope controlling volume ramp-up based on distance. |
| **RollInDistance** | Distance where gain becomes maximum. |
| **MinDistance** | Distance at which stream remains at maximum volume. |
| **MuteDistance** | Distance where the stream is muted. |
| **MaxDistance** | Distance where stream gain becomes 0.0. |
| **RollOff** | Slope controlling volume attenuation. |
| **Mode3D** | Enables 3D positional audio. |
| **ModeDoppler** | Enables Doppler shift effects. |
| **PlayProbability** | Chance for the stream to play when triggered. |
| **Stream** | Internal ID of the stream file containing the segments. |
| **PlayInterval** | Seconds to wait before allowing the stream to trigger again. |
| **PlayIntervalDev** | Seconds to vary the `PlayInterval` by. |
| **RandomPlayPos** | Starts playback at a random time in the segment. |
| **CyclePlayback** | Controls segment selection: <br/>0: Random selection. <br/>1: Cycle starting randomly. <br/>2: Cycle starting at the first segment. <br/>3: Random selection without immediate repeats. |
| **SpaceDistance** | Distance a source center can leave a space while remaining classified as within it. |

### SoundStream.SubObjectID : SegmentList
| Property | Description |
| :--- | :--- |
| **Segment** | `Segment("segmentName", weight[, playInterval, playIntervalDev])`. Specifies a segment from the stream and its selection weight. Optional intervals enforce retrigger delays. |

Example:
```
SoundStream()
{
    Name("music");
    Pitch(1.0);
    PitchDev(0.0);
    Gain(0.3);
    GainDev(0.0);
    ReverbGain(1.0);
    Bus("music");
    Looping(1);
    Pan(0.0);
    RollIn(10.0);
    RollInDistance(0.0);
    MinDistance(1.0);
    MuteDistance(140.0);
    MaxDistance(140.0);
    RollOff(1.0);
    Mode3D(0);
    Stream("mymusicstream");
    Bus("musicbus");
    SegmentList()
    {
        Segment("music_variation0", 0.25);
        Segment("music_variation1", 0.25);
        Segment("music_variation2", 0.1);
        Segment("music_variation3", 0.4);
    }
}
```

### ObjectID : SoundLayered
A layered sound (SoundLayered) allows multiple Sounds to be played back at the same time or with some delay between each sound.

 Property | Description |
| :--- | :--- |
| **Name** | Name of the layered sound object. |
| **Layer** | `Layer("layerName", "soundName", delay, delayDev, time, timeDev)`. Defines a constituent sound layer. Includes parameters for start delay, duration, and randomization for both. |

Example:
```
SoundLayered
{
    Name("grenade_explode");
    Layer("explosion", "grenade_explode", 0.0);
    Layer("gasleak",   "grenade_gas",     0.5, 0.1);
}
```
The sound "grenade_explode" will be played when the layered sound 
"grenade_explode" is triggered (played). Then 0.4 to 0.6 seconds after the 
layered sound "grenade_explode" was triggered, "grenade_gas" will play.


### ObjectID : ParameterGraph
Parameter graphs are used in conjunction with parameterized sounds (SoundParameterized) to map application (game) values to sound parameters. For example the acceleration of a object could be mapped to the gain of a sound.

| Property | Description |
| :--- | :--- |
| **Name** | Name of the parameter graph. |
| **ControlPoint** | `ControlPoint(inputValue, outputValue)`. Defines a mapping point between a game value (X) and a sound parameter (Y). Intervening values are linearly interpolated. |

### ObjectID : SoundParameterized
A parameterized sound maps game parameters using parameter graphs to control a layered sound.

| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the parameterized sound. |
| **SoundLayered** | The name of the `SoundLayered` object this object controls. |

### SoundParameterized.SubObjectID : Layer
| Property | Description |
| :--- | :--- |
| **Name** | Name of the layer being controlled within the `SoundLayered` object. |
| **ParameterGraph** | `ParameterGraph(input, graphName, output)`. Maps a game variable (`input`) through a `ParameterGraph` to a specific sound property (`output`). Valid outputs: Gain, Pitch, Pan, MinDistance, MuteDistance, MaxDistance, RollOff. |

### ObjectID : I3DL2ReverbPreset
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the reverb preset. |
| **RoomGain** | Overall reverb output volume (0.0 to 1.0). |
| **RoomHFGain** | Volume of the high-frequency path (0.0 to 1.0). |
| **RoomRollOff** | Controls the low-pass filter cutoff on reverb output (0.0 to 10.0). |
| **DecayTime** | Reverb duration in seconds (0.01 to 20.0). |
| **DecayHFRatio** | High-frequency decay ratio (0.01 to 2.0). |
| **ERGain** | Early reflections volume (0.0 to 1.0). |
| **ERDelay** | Delay of early reflections (0.0 to 0.3). |
| **ReverbGain** | Volume of the late reverberation (0.0 to 10.0). |
| **ReverbDelay** | Delay of the late reverberation (0.0 to 0.1). |
| **Diffusion** | Controls the echo density and stereo width (0.0 to 100.0). |
| **Density** | Modal density of the late reverberation (0.0 to 100.0). |
| **HFReference** | Reference high frequency for filters in Hz (20 to 20,000). |

#### PS2 Mapping Algorithm
On PS2, `I3DL2ReverbPresets` are mapped to hardware-specific presets:
| I3DL2 Parameter Condition | PS2 Native Preset |
| :--- | :--- |
| `RoomGain == 0.0` | OFF |
| `Diffusion < 100.0`, `ERGain < 1.0`, `ReverbDelay < 0.05` | DELAY |
| `Diffusion < 100.0`, `ERGain < 1.0`, `ReverbDelay >= 0.05` | ECHO |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime > 4.0`, `HFRatio > 0.5` | SPACE |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime > 4.0`, `HFRatio <= 0.5` | HALL |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime > 3.0`, `DecayHFRatio > 1.0` | HALL |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime > 3.0`, `DecayHFRatio <= 1.0` | STUDIO_C |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime > 2.0`, `ERGain > 1.0` | PIPE |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime > 2.0`, `ERGain <= 1.0` | STUDIO_B |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime <= 2.0`, `DelayHFRatio > 0.5` | ROOM |
| `(Diff >= 100.0 OR ERGain >= 1.0)`, `DecayTime <= 2.0`, `DelayHFRatio <= 0.5` | STUDIO_A |

### ObjectID : Space
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the audio space. |
| **I3DL2ReverbPreset** | Name of the reverb preset to apply. |
| **DirectGain** | Volume of the direct path from source to listener. |
| **DirectHFGain** | High-frequency volume of the direct path. |
| **RoomGain** | Volume of the reverb path. |
| **RoomHFGain** | High-frequency volume of the reverb path. |
| **RoomRollOffFactor** | Frequency roll-off for reverb (0.0 to 10.0). |
| **ObstructionHFGain** | High-frequency gain for obstructed paths (same space). |
| **ObstructionLFRatio** | Cut-off ratio for obstructed paths. |
| **OcclusionHFGain** | High-frequency gain for occluded paths (different spaces). |
| **OcclusionLFRatio** | Cut-off ratio for occluded paths. |
| **Priority** | Higher priority spaces are chosen when overlapping. |

### Space.SubObjectID : ConnectedList
| Property | Description |
| :--- | :--- |
| **Space** | `Space(spaceName, gainFactor)`. Defines a connected space from which sound can leak. `gainFactor` (0.0 to 1.0) controls the degree of occlusion and obstruction applied to the leaked sound. |

Example:
```
Space()
{
    Name("corridor")
    I3DL2ReverbPreset("corridor")
    DirectGain(1.0)
    DirectHFGain(1.0)
    RoomGain(0.2)
    RoomHFGain(0.2)
    RoomRollOffFactor(5.0)
    ObstructionHFGain(0.2)
    ObstructionLFRatio(1.0)
    OcclusionHFGain(0.2)
    OcclusionLFRatio(1.0)
}
Space()
{
    Name("hall")
    I3DL2ReverbPreset("hall")
    DirectGain(1.0)
    DirectHFGain(1.0)
    RoomGain(0.3)
    RoomHFGain(0.3)
    RoomRollOffFactor(3.0)
    ObstructionHFGain(0.3)
    ObstructionLFRatio(1.0)
    OcclusionHFGain(0.3)
    OcclusionLFRatio(1.0)
    ConnectedList()
    {
        Space("corridor", 0.7)
    }
}
```
This sets up a space "hall" which is connected to the space "corridor". If the listener is in "hall" and the source in "corridor" the source will be attenuated appropriately. The following psuedo code is an example of what operation would be applied to the source in "corridor"
```
source.occlusionHFGain   = 1.0 - ((1.0 - hall.occlusionHFGain)   * gainFactor)
source.obstructionHFGain = 1.0 - ((1.0 - hall.obstructionHFGain) * gainFactor)
source OcclusionHFGain    = 1.0 - ((1.0 - 0.3) * 0.7) = 0.51
source ObstructionHFGain  = 1.0 - ((1.0 - 0.3) * 0.7) = 0.51
```

# Comprehensive Sound Triggering Overview

## Music Configuration (.mus)
*.mus files configure the dynamic music. Music events are in the following schema:
```
Music()
{
    Name("all_snowspeeder_music");
    Priority(1.0);
    FadeInTime(1.0);
    FadeOutTime(1.0);
    MinPlaybackTime(20.0);
    MaxPlaybackTime(180.0);
    MinInactiveTime(120.0);
    SoundStream("all_snowspeeder_music");
}
```

| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the music configuration (referenced in mission scripts and ODFs). |
| **Priority** | Playback priority. If multiple music tracks are scheduled simultaneously, only the one with the highest priority is heard. |
| **FadeInTime** | Duration (in seconds) of the volume fade-in when the music starts. |
| **FadeOutTime** | Duration (in seconds) of the volume fade-out when the music stops or pauses. |
| **MinPlaybackTime** | Minimum duration (in seconds) the music must play once it has started. |
| **MaxPlaybackTime** | Maximum duration (in seconds) the music will play before automatically stopping. |
| **MinInactiveTime** | Minimum interval (in seconds) that must pass before this music track can be triggered again. |
| **SoundStream** | The sound stream property associated with this music definition. |

## Mission scripts (lua)
### SetSoundEffect(soundEventType, soundPropertyName[, teamIndex])
| soundEventType | Description |
| :--- | :--- |
| **BirdScatter** | Triggered when birds are spawned. |
| **Bird** | Audio property attached to each individual bird entity. |
| **LeafFall** | Triggered when a falling leaf is spawned. |
| **ScopeDisplayAmbient** | Looped audio played while the scope display is active. |
| **ScopeDisplayZoomIn** | Triggered when the scope display zooms in. |
| **ScopeDisplayZoomOut** | Triggered when the scope display zooms out. |
| **WeaponUnableSelect** | Played when a weapon switch is attempted but no other weapon is available. |
| **WeaponModeUnableSelect** | Played when a fire-mode switch is attempted but no other mode is available. |
| **SpawnDisplayUnitChange** | Triggered when cycling through unit classes in the spawn screen. |
| **SpawnDisplayUnitAccept** | Triggered when a unit class is confirmed/selected. |
| **SpawnDisplaySpawnPointChange** | Triggered when cycling through available spawn locations. |
| **SpawnDisplaySpawnPointAccept** | Triggered when a spawn location is confirmed/selected. |
| **SpawnDisplayBack** | Triggered when returning from the map view to the unit selection screen. |
| **LockOn** | Played when the player successfully locks onto a target. |
| **HeroesUnlocked** | Triggered in multiplayer when heroes become available for selection. |
| **HeroSpawned** | Played when a hero unit spawns. Requires a `teamIndex` <int>. |
| **HeroDefeated** | Played when a hero unit is killed. Requires a `teamIndex` <int>. |

`soundPropertyName` refers to the unique identifier of a sound property defined in a `.snd` file.


### SetBleedingVoiceOver(playerTeam, bleedTeam, streamSoundName, bleeding)
Team numbers are defined by SetTeamName in mission script for 
example if SetTeamName(1, "Alliance"); and SetTeamName(2, "Empire"); 
are preset, team 1 is the alliance, team 2 is the empire.

| Function Parameter | Description |
| :--- | :--- |
| `playerTeam` | player's team index <int> |
| `bleedTeam` | the team that's started / stopped bleeding <int> |
| `streamSoundName` | stream sound to play when the local player is playerTeam and bleedTeam has started / stopped bleeding <string> |
| `bleeding` | set to 1 to assign a started bleeding sound, 0 to assign stopped bleeding sound <int> |

### SetBleedingRepeatTime(repeatTime)
`repeatTime`: time between each repetition of the started bleeding voice over. If this function is not called the repeatTime defaults to 30 seconds.

### SetPlanetaryBonusVoiceOver(playerTeam, bonusNum, streamSoundName)
Sets the voice-over for a specific planetary bonus.
| Parameter | Description |
| :--- | :--- |
| **playerTeam** | The player's team index. |
| **bonusNum** | The ID of the bonus to set: <br/>0: Medical regeneration. <br/>1: Surplus supplies. <br/>2: Sensor boost. <br/>3: Hero arrival. <br/>4: Team reserves bonus. <br/>5: Enemy reserves bonus. |
| **streamSoundName** | The name of the sound stream to play. |

### SetLowReinforcementsVoiceOver(playerTeam, lowReinforcementTeam, streamSoundName, numReinforcements[, isPercentage])
Triggered when reinforcement counts drop below a threshold.
| Parameter | Description |
| :--- | :--- |
| **playerTeam** | The player's team index. |
| **lowReinforcementTeam** | The team reaching the low reinforcement threshold. |
| **streamSoundName** | The sound stream to play. |
| **numReinforcements** | The threshold value triggering the VO. |
| **isPercentage** | Optional. If 1, `numReinforcements` is treated as a percentage (0.0 to 1.0). |

### SetOutOfBoundsVoiceOver(playerTeam, streamSoundName)
| Parameter | Description |
| :--- | :--- |
| **playerTeam** | The player's team index. |
| **streamSoundName** | The sound stream to play when the player enters the death boundary. |

### SetAmbientMusic(playerTeam, reinforcementCount, musicName, gameStage[, isPercentage])
Dynamically changes ambient music based on battle progress.
| Parameter | Description |
| :--- | :--- |
| **playerTeam** | The player's team index. |
| **reinforcementCount** | The reinforcement count threshold. |
| **musicName** | Name of the music configuration defined in a `.mus` file. |
| **gameStage** | 0: Beginning, 1: Middle, 2: End. |
| **isPercentage** | Optional. If 1, `reinforcementCount` is a percentage. |

### SetAttackingTeam(teamIndex)
Resolves audio priority for splitscreen players.
| Parameter | Description |
| :--- | :--- |
| **teamIndex** | The index of the primary attacking team. |

### SetVictoryMusic(teamIndex, soundStreamID)
| Parameter | Description |
| :--- | :--- |
| **teamIndex** | The player's team index. |
| **soundStreamID** | ID of the sound stream property to play upon victory. |

### SetDefeatMusic(teamIndex, soundStreamID)
| Parameter | Description |
| :--- | :--- |
| **teamIndex** | The player's team index. |
| **soundStreamID** | ID of the sound stream property to play upon defeat. |

### PlayAudioStream(streamFilename, streamID, segmentID, gain, busname[, streamIndex])
| Parameter | Description |
| :--- | :--- |
| **streamFilename** | The `.lvl` or `.stm` file path. |
| **streamID** | The unique ID of the stream in the file. |
| **segmentID** | The segment ID within that stream. |
| **gain** | Playback volume. |
| **busname** | Audio bus routing (defaults to "Root"). |
| **streamIndex** | Optional. Index of a currently open stream to use. |

### PlayAudioStreamUsingProperties(streamFilename, soundStreamID[, noOpen])
| Parameter | Description |
| :--- | :--- |
| **streamFilename** | The stream source file. |
| **soundStreamID** | The ID of the sound stream property. |
| **noOpen** | Optional. If 1, uses an already opened stream. |

### StopAudioStream(streamIndex[, close])
| Parameter | Description |
| :--- | :--- |
| **streamIndex** | The handle of the stream to stop. |
| **close** | Optional. If 1, closes the stream handle. |

### OpenAudioStream(streamFilename, streamID)
| Parameter | Description |
| :--- | :--- |
| **streamFilename** | The stream source file. |
| **streamID** | The unique ID of the stream. |

### AudioStreamAppendSegments(streamFilename, streamID, streamIndex)
Appends segments from one stream to another open stream handle.

### AudioStreamComplete(streamID)
Returns 1 if the stream has finished, 0 otherwise.

### ScriptCB_SndPlaySound(soundID)
| Parameter | Description |
| :--- | :--- |
| **soundID** | ID of a sound property to play globally. |

### ScriptCB_SndBusFade(busName, endGain, fadeTime[, startGain])
| Parameter | Description |
| :--- | :--- |
| **busName** | The name of the audio bus. |
| **endGain** | Target volume (0.0 to 1.0). |
| **fadeTime** | Duration of the fade in seconds. |
| **startGain** | Optional. Starting volume for the fade. |

### ScaleSoundParameter(groupID, parameter, scale)
Scales a specific parameter for a group of sounds simultaneously.
| Parameter | Description |
| :--- | :--- |
| **groupID** | Identifier for the targeted sound group. |
| **parameter** | Property to scale: `Gain`, `GainDev`, `Pitch`, `PitchDev`, `PlayProbability`, `PlayInterval`, `PlayIntervalDev`, `ReverbGain`, `Pan`, `MinDistance`, `MuteDistance`, `MaxDistance`, `RollOff`, `RollIn`, `RollInDistance`. |
| **scale** | The multiplier to apply. |

### ScriptCB_SetMovieAudioBus(busID)
| Parameter | Description |
| :--- | :--- |
| **busID** | ID of the bus controlling movie volume. |

### ScriptCB_SetDopplerFactor(dopplerFactor)
| Parameter | Description |
| :--- | :--- |
| **dopplerFactor** | Default is 1.0. Lower reduces the effect; higher exaggerates it. |

### ScriptCB_PlayInGameMusic(musicID)
Plays a specific music configuration immediately.

### ScriptCB_StopInGameMusic()
Stops music triggered by `ScriptCB_PlayInGameMusic`.

### ScriptCB_EnableCommandPostVO(enable)
Enables (1) or disables (0) Command Post status voice-overs.

### ScriptCB_EnableHeroMusic(enable)
Enables (1) or disables (0) unique music for hero units.

### ScriptCB_EnableHeroVO(enable)
Enables (1) or disables (0) voice-overs for hero units.

### ScriptCB_SetSpawnDisplayGain(gain, fadeTime)
| Parameter | Description |
| :--- | :--- |
| **gain** | Audio bus volume while in the spawn screen (0.0 to 1.0). |
| **fadeTime** | Transition duration in seconds. |

### ScriptCB_TriggerSoundRegionEnable(groupName, enable)
Enables (1) or disables (0) a group of sound trigger regions.

## Shell
### Galactic Conquest VO
The following sound hooks are triggered during the Galactic Conquest metagame interface.

| Event Hook | Description |
| :--- | :--- |
| **{team}_planet_select** | Triggered when the planet selection screen is displayed. |
| **{team}_bonus_select** | Triggered when the bonus selection screen is displayed. |
| **{team}_{mission}_select** | Triggered when a specific planet or mission is highlighted in the planet selection screen. |
| **{team}_{planet}_bonus** | Triggered when a planet is selected within the bonus screen. |
| **{team}_won_{mission}** | Played when the player's team wins a battle at the specified mission. |
| **{team}_lost_{mission}** | Played when the player's team loses a battle at the specified mission. |

**Example:** `all_planet_select` plays when the human player is the Alliance and enters the planet selection screen.

## ODFs
The string assigned to the sound event hook ("") must be in the following schema:
`"soundpropertyname"` or `"soundpropertyname defer"`

In the first form soundpropertyname is the name of a SoundProperties, SoundLayered or SoundStream defined in a sound configuration file `*.snd`. The second form allows the sound lookup to be deferred until the sound is played. This means the sound can be loaded after the event is processed. For example, if SoundProperties "grenadeeffect" is in a file effects.snd and the event is located in a file grenade.odf. If grenade.odf is loaded first the reference to the event will cause an error and the SoundProperties will not be found. However, if the event is specified in the form "grenadeeffect defer" the "grenadeeffect" will not be searched for until the sound event is triggered, preventing a missing sound error.  

The following describes the sound events which are exposed for each class of
object.

### Entities
All entities can have damage effects played depending on set health percentage thresholds:
`DamageEffectSound = "soundPropertyName"`

All entities can also have sounds played when damaged by a DamageRegion:
`DamageRegionSound = "soundPropertyName regionName"`

### EngineSound
The `EngineSound` parameter is used by some entities to control a `SoundParameterized` object, providing a simple simulation of an engine. This sound is provided the following parameters from the game engine:

| Parameter | Description |
| :--- | :--- |
| **speed** | Speed of the entity (0.0 to 1.0). |
| **acceleration** | Acceleration of the entity (-1.0 to 1.0). |
| **height** | Height of the entity from the ground (0.0 to 1.0). *Implemented for hover only.* |
| **turnontime** | Seconds since the entity was turned on. Defaults to `3e+38` when not turning on. |
| **turnofftime** | Seconds since the entity started to turn off. Defaults to `3e+38` when not turning off. |
| **winduptime** | Seconds since takeoff/wind up began. *Implemented for flyers/carriers.* |
| **winddowntime** | Seconds since landing/wind down began. *Implemented for flyers/carriers.* |
| **strain** | Strain amount (0.0 to 1.0). Straining for hover, turning intensity for flyer. |
| **proximity** | `0` when distance > `ProximityMaxDist`, `1` when distance < `ProximityMinDist`. |

### dusteffect ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **SpawnSound** | Sound played when the dust effect is spawned. |

### walker ClassLabel Entities
*Note: Footsteps are now handled via Foley effects.*
| Property | Description |
| :--- | :--- |
| **HydraulicSound** | Played when the foot is raised above `HydraulicSoundHeight`. |
| **HydraulicSoundHeight** | Distance threshold for the hydraulic lift sound. |
| **HydraulicLowerSound** | Played when the foot is lowered below `HydraulicLowerHeight`. |
| **HydraulicLowerHeight** | Distance threshold for the hydraulic lower sound. |
| **HurtSound** | Played when the walker is hit. |
| **DeathSound** | Played when the walker is destroyed. |
| **DamageRegionSound** | Played when damaged by a damage region. |
| **Music** | Global ambient music configuration. |
| **AllMusic** | Music override for Rebel Alliance. |
| **ImpMusic** | Music override for Galactic Empire. |
| **RepMusic** | Music override for Galactic Republic. |
| **CISMusic** | Music override for CIS. |
| **MusicSpeed** | Speed threshold required to trigger music. |
| **MusicDelay** | Time required at `MusicSpeed` before music plays. |
| **EngineSound** | `SoundParameterized` engine loop. Maps `acceleration`, `speed`, `health`, `turnontime`, `turnofftime`. |
| **TurnOnSound** | Played when a unit enters the vehicle. |
| **TurningOffSound** | Played when a unit leaves the vehicle. |
| **TurnOffSound** | Played when the engine shuts down. |
| **TurnOffTime** | Seconds until the engine shuts down after exit. |
| **Cockpit1stPersonSound** | Looped audio while in 1st person. |
| **Cockpit3rdPersonSound** | Looped audio while in 3rd person. |
| **FootstepSound[0-5]** | Sound hooks for feet 0 through 5. |
| **VehicleCollisionSound** | Played on collision. |

### Turret Properties (Walker/Flyer/Hover/Building)
Defined after `TURRETSECTION` or `BUILDINGSECTION` headers.
| Property | Description |
| :--- | :--- |
| **TurretYawSound** | Played during horizontal rotation. |
| **TurretYawSoundPitch** | Pitch scale factor for yaw speed. |
| **TurretPitchSound** | Played during vertical rotation. |
| **TurretPitchSoundPitch** | Pitch scale factor for pitch speed. |
| **TurretAmbientSound** | Looped while the turret is manned. |
| **TurretActivateSound** | Played when manning the turret. |
| **TurretDeactivateSound** | Played when exiting the turret. |
| **TurretStartSound** | Played when rotation begins. |
| **TurretStopSound** | Played when rotation ends. |

### droideka ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **FootstepSound[0-2]** | Sound hooks for feet 0 through 2. |
| **HydraulicSound** | Played on foot raise. |
| **HydraulicSoundHeight** | Height threshold. |
| **HurtSound** | Played when hit. |
| **DeathSound** | Played on destruction. |
| **DamageRegionSound** | Played in damage regions. |
| **EngineSound** | Rolling sound. Maps `acceleration`, `speed`, `health`, `turnontime`, `turnofftime`. |
| **TurnOnSound** | Played when rolling up. |
| **TurningOffSound** | Played when starting to unroll. |
| **TurnOffSound** | Played when finished unrolling. |
| **TurnOffTime** | Seconds to unroll. |
| **ShieldSound** | Played when shield is enabled. |
| **ShieldOffSound** | Played when shield turns off. |
| **ShieldWearOffSound** | Played during shield flicker/depletion. |
| **JumpSound** | Played on jump. |
| **LandSound** | Played on landing. |

### flyer ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **EngineSound** | Parameterized engine sound. |
| **TakeoffSound** | Played on takeoff. |
| **LandSound** | Played on landing. |
| **HurtSound** | Played when hit. |
| **DeathSound** | Played on destruction. |
| **DamageRegionSound** | Played in damage regions. |
| **TurnOnSound** | Played during takeoff. |
| **TurningOffSound** | Played on exit. |
| **TurnOffSound** | Played on shutdown. |
| **TurnOffTime** | Shutdown duration. |
| **TrickSound** | Played during rolls. |
| **FlipSound** | Played during flips. |
| **Music** | Global driving music. |
| **[Team]Music** | Faction specific music overrides. |
| **MusicSpeed/Delay** | Thresholds for music triggering. |
| **VehicleCollisionSound** | Played on collision. |
| **Cockpit[1/3]Sound** | First/Third person cockpit loops. |
| **Proximity[Min/Max]Dist** | Distances for engine proximity parameter. |
| **BoostSound** | `BoostSound = "soundID threshold accelerating"`. Triggers when speed crosses threshold. |
*Supports standard Turret properties.*

### carrier ClassLabel Entities
*Supports all properties from the `flyer` class, with the addition of:*
| Property | Description |
| :--- | :--- |
| **PickupSound** | Played when cargo is attached. |
| **DropoffSound** | Played when cargo is detached. |

### hover ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **GroundedSound** | Played when altitude dips below `GroundedHeight`. |
| **GroundedHeight** | Altitude threshold for grounding sound. |
*Inherits properties from `flyer` (Engine, Music, Boost, Cockpit, Collision, Damage).*
*Supports standard Turret properties.*

### building/armedbuilding/animatedbuilding ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **BuiltSound** | Played when construction is completed. |
| **BuildingSound** | Constant ambient loop. |
*Supports standard Turret properties.*

### soldier ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **HurtSound** | Played when hit. |
| **DeathSound** | Played on death. |
| **DamageRegionSound** | Played in damage regions. |
| **FootstepStride** | Stride length for first-person/no-animator movement. |
| **RunSpeed** | Threshold between walk and run in 1st person. |
| **AcquiredTargetSound** | AI: Target acquired. |
| **HidingSound** | AI: Deciding to hide. |
| **ApproachingTargetSound** | AI: Closing distance to target. |
| **FleeSound** | AI: Fleeing. |
| **PreparingForDamageSound** | AI: Anticipating damage (e.g., grenade nearby). |
| **HeardEnemySound** | AI: Heard an enemy. |
| **ShockFadeOutTime** | Main bus fade-out duration when thrown by explosions. |
| **ShockFadeOutGain** | Target gain for shock fade (0.0 to 1.0). |
| **ShockFadeInTime** | Main bus fade-in duration upon landing from shock. |
| **ShockSound** | Played when hitting the ground from shock. |
| **ClothingRustleSound** | Played when a foot reaches max height. |
| **LowHealthSound** | Loop attached when health is below threshold. |
| **LowHealthThreshold** | Percent threshold (0.0 to 1.0) for low health. |
| **EngineSound** | Jetpack loop. Maps `acceleration`, `speed`, `health`, `turnontime`, `turnofftime`. |
| **TurnOnSound** | Played when activating jetpack. |
| **TurningOffSound** | Played when starting jetpack shutdown. |
| **TurnOffSound** | Played when jetpack is fully off. |
| **TurnOffTime** | Seconds to shut down jetpack. |
| **Cockpit[1/3]Sound** | Cockpit audio loops. |
| **SoldierMusic** | Played on player spawn as this class. |
| **AISoldierMusic** | Played on AI spawn as this class. |
| **SoldierAnnouncement** | VO hook for class spawning. |
| **BoostSound** | Crossing speed thresholds. |

#### Tactical Voice-Over Hooks (soldier)
| Trigger Type | Player (SC...) | AI (AISC...) |
| :--- | :--- | :--- |
| **Field Move Out** | `SCFieldMoveOutSound` | `AISCFieldMoveOutSound` |
| **Field Hold** | `SCFieldHoldSound` | `AISCFieldHoldSound` |
| **Field Follow** | `SCFieldFollowSound` | `AISCFieldFollowSound` |
| **Driver In/Out** | `SCDriverGetIn/OutSound` | `AISCDriverGetIn/OutSound` |
| **Passenger In/Out** | `SCPassengerGetIn/OutSound` | `AISCPassengerGetIn/OutSound` |
| **Gunner In/Out** | `SCGunnerGetIn/OutSound` | `AISCGunnerGetIn/OutSound` |
| **Gunner Clear/Steady** | `SCGunnerAllClear/SteadySound` | `AISCGunnerAllClear/SteadySound` |
| **AI Response** | N/A | `AISCResponseYessir/NosirSound` |

### droid ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **AmbientSound** | Primary looped/one-shot spawn audio. |
| **Ambient2Sound** | Secondary looped/one-shot spawn audio. |
| **HurtSound** | Played when hit. |
| **DeathSound** | Played on destruction. |
| **DamageRegionSound** | Played in damage regions. |

### powerupitem ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **PowerupSound** | Played on pickup. |
| **AmbientSound** | Attached loop while active in world. |

### powerupstation ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **PowerupSound** | Played when charging/granting powerups. |
| **AmbientSound** | Attached ambient loop. |
| **BuiltSound** | Played when construction is finished. |

### explosion ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **SoundProperty** | Played when spawned. |
| **ChunkInitialCollisionSound** | Played when debris chunks hit objects. |
| **ChunkScrapeCollisionSound** | Played while chunks are sliding. |

### door ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **OpenSound** | Played on opening. |
| **CloseSound** | Played on closing. |
| **LockedSound** | Played when approached while locked. |

### prop ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **SoundProperty** | Primary ambient audio. |
| **StartMovementSound** | Played when movement begins. |
| **StopMovementSound** | Played when movement stops. |
| **SoundOffset** | `x y z` offset for audio origin. |
| **SoundWhenMoving** | Set to `1` to only play `SoundProperty` while in motion. |

### animatedprop ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **KillSoldierSound** | Played when a unit is killed specifically by the prop's logic (e.g., the Sarlacc). |
| **AnimationTriggerSound** | `AnimationTriggerSound = "animID soundID"`. Triggers a specific sound when the named animation begins. |

### trap ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **TriggerSound** | Played at the moment the trap is activated. |

#### Chunk Sound Hooks (Traps / Buildings / Chunks)
The following hooks can be attached to individual chunk segments within a `CHUNKS` or `CHUNKSECTION` block.

| Property | Description |
| :--- | :--- |
| **ChunkInitialCollisionSound** | Played upon the first impact of a debris chunk with the world. |
| **ChunkScrapeCollisionSound** | Played while a debris chunk is sliding against another object. |
| **BuiltSound** | For buildable structures, played when the construction process is finalized. |

### weaponclass Entities
| Property | Description |
| :--- | :--- |
| **FireSound** | Played when the weapon is fired. |
| **FireEmptySound** | Played when the weapon is fired with no ammunition. |
| **FireLoopSound** | Looped audio played while firing; stops when firing ceases. |
| **ReloadSound** | Played during the reload animation. |
| **ChargeSound** | Played while the weapon is charging before a shot. |
| **ChargeSoundPitch** | Starting pitch scalar for `ChargeSound`, transitioning to 1.0 as charge increases. |
| **ChargeSoundStop** | If 1 (default), stops the charge sound when fully charged. |
| **ChargedSound** | Played when the weapon reaches maximum charge. |
| **ChangeModeSound** | Played when cycling weapon fire modes. |
| **WeaponChangeSound** | Played when switching to this weapon. |
| **OverheatSound** | Looped audio played while the weapon is overheated. |
| **OverheatSoundPitch** | Starting pitch scalar for `OverheatSound`, transitioning to 1.0 as it cools. |
| **OverheatStopSound** | Played when the weapon has finished cooling. |

#### Soldier Foley Hooks (on Weapon)
| Property | Description |
| :--- | :--- |
| **Clank[Left/Right][Walk/Run]Sound** | Footstep sounds for the owner while moving. |
| **JumpSound** | Played when the owner jumps. |
| **LandSound** | Played when the owner lands. |
| **RollSound** | Played during a dodge roll. |
| **ProneSound** | Played when entering prone (deprecated). |
| **SquatSound** | Played when crouching. |
| **StandSound** | Played when standing up. |

### cannon / grenade / disguise / laser / binoculars / repair ClassLabel Entities
*These classes inherit all standard weapon hooks listed above.*

### launcher ClassLabel Entities
*Inherits standard weapon hooks.*

**Note:** For launchers, the `ChargeSound` hook is repurposed as the **Tracking Sound** during target acquisition.

### remote ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **ChargeSound** | Looping sound starting when self-destruct is initiated, increasing in pitch until detonation. |
| **SelfDestructSoundPitch** | Scalar (0.0 to 1.0) for the starting pitch of the self-destruct loop. |
*Inherits standard weapon hooks.*

### towcableweapon ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **WindSound** | Looping sound played while the cable is reeling out. |
| **DetatchSound** | Played when the cable is detached or broken. |
*Inherits standard weapon hooks.*

### melee ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **HitSound** | Played when the melee strike hits an object or unit. |
| **DeflectSound** | Played when ordnance is successfully blocked/deflected. |
| **Swing** | `Swing = "{animTime} {damageTime} {soundID}"`. Plays a specific swing sound randomly selected during firing. |

**Example:**
```
Swing = "0.7 0.4 swing_small"
Swing = "0.9 0.7 swing_medium"
Swing = "1.5 1.0 swing_large"
```
*Inherits standard weapon hooks.*

### beam / bullet / shell / laser / bolt ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **OrdnanceSound** | Looped audio attached to the projectile. Starts on creation and stops on destruction. |
| **CollisionSound** | Played when the ordnance impacts a solid object or terrain. |
| **CollisionWaterSound** | Played when the ordnance impacts water. |
| **CollisionShieldSound** | Played when the ordnance impacts an energy shield. |

### grenade ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **CollisionFoliageSound** | Played when the grenade impacts foliage meshes. |
| **CollisionOtherSound** | Played when impacting anything other than water or foliage. |
*Note: Also supports water collision hooks from the beam class.*

### mine ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **TickSound** | Repeating audio triggered every second the mine is active. |
| **TickSoundPitch** | Scalar for the starting pitch of the `TickSound`. The final pitch is determined by the sound property definition. |

### missile ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **LockedOnSound** | Played in addition to `OrdnanceSound` when the missile has acquired a target lock. |
*Inherits all hooks from the beam class.*

### powerupitem ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **PowerupSound** | Played when the item is successfully collected by a unit. |

### meleethrowordnance ClassLabel Entities
| Property | Description |
| :--- | :--- |
| **OnSound** | Looped audio attached to the thrown melee weapon (e.g., lightsaber) while in flight. |

## Particle Effects (fx files)
It is possible to attach an ambient sound to a particle effect. This is performed by modifying the `SoundName("soundPropertyID")` property of the ParticleEmitter() section in an .fx file.

Example:
```
ParticleEmitter("BlackSmoke")
{
    MaxParticles(20000.0000,20000.0000);
    StartDelay(0.0000,0.0000);
    BurstDelay(0.5000, 0.5000);
    BurstCount(1.0000,1.0000);
    MaxLodDist(1000.0000);
    MinLodDist(800.0000);
    SoundName("com_amb_heavyfire");
    Size(1.0000, 1.0000);
    Hue(255.0000, 255.0000);
    Saturation(255.0000, 255.0000);
    Value(255.0000, 255.0000);
    Alpha(255.0000, 255.0000);
    ...
```

## World Foliage (prp files)
Sounds can be attached to foliage. Foliage is made up of a number of layers which are blended together to create a rich environment. Layers consist of meshes and each mesh in a can have an assoicated sound.

Example:
```
Layer(0)
{
        SpreadFactor(0.3);
        Mesh()
        {
                GrassPatch("yav_prop_grass.odf", 50);
                File("editor_grasspatch.msh", 50);
                Frequency(100); 
                Scale(1);
                Stiffness(0.0); 
                Sound("cricketloop");
                CollisionSound("grasscrunch");
        }
        Mesh()
        {
                GrassPatch("yav_prop_grass.odf", 40);
                File("editor_grasspatch.msh", 40);
                Frequency(100); 
                Scale(1);
                Stiffness(0.0); 
                Sound("cricketoneshot", 5.0, 1.0);
                CollisionSound("grasscrunch2");
        }
}
```
Layer 0 consists of two grass types with different weights (50 and 40). One mesh has been assigned a looping sound "cricketloop" which is triggered when the mesh becomes visible. The other mesh is assigned a sound cricketoneshot which is triggered between 4..6 seconds after the mesh becomes visible. Furthermore, "cricketoneshot" is retriggered every 4...6 seconds.  
Remember, it's possible to control the probability of a sound playing back when it is triggered by changing the playback probability of the sound. For example it's probably not a good idea for "cricketloop" to have a playback probability of 1.0 since every grasspatch mesh will contain a cricket.
The schema for the sound property is `Sound(SoundPropertyName);` or `Sound(SoundPropertyName, RetriggerInterval, RetriggerIntervalDeviation);`
CollisionSound is the sound played when a soldier collides with the foliage.
The schema of the CollisionSound property of a Mesh is `CollisionSound(SoundPropertyName);`

## World
### Ambience
Ambient sounds can be placed in the editor by creating spherical regions with specific labels, or by placing `snd_amb_static.odf` / `snd_amb_streaming.odf` objects.

| Region Label Format | Description |
| :--- | :--- |
| **soundstatic {prop} {divisor}** | Plays a non-streaming sound property. The `divisor` sets the min distance (radius / divisor). |
| **soundstream {prop} {divisor}** | Plays a streaming sound property. The `divisor` sets the min distance (radius / divisor). |

**Example:** `soundstatic forest_ambience 2.0` creates a static ambient sound where the volume reaches maximum at half the region's radius.

### Spaces
Sound spaces are acoustically isolated volumes. Reverb defined in the space applies to internal sounds, while occlusion settings apply to sounds originating outside the volume.

| Region Label Format | Description |
| :--- | :--- |
| **soundspace {name}** | Associates a Box, Cylinder, or Sphere region with a `Space` definition in a `.snd` file. |

### TriggerRegions (.tsr)
Trigger regions play faction-specific audio when a player enters a volume. Logic is defined in a `.tsr` file.

#### Group Properties
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the group (referenced by `Region()`). |
| **Reinforcements** | Fraction (0.0 to 1.0) of reinforcements the player's team must exceed for this group to be valid. |
| **Alliance / Empire / Republic / CIS** | The sound or stream property to play for the respective team. |

#### Region Properties
| Property | Description |
| :--- | :--- |
| **Name** | Must match the region label in the world file (prefixed with `soundtrigger`). |
| **Group** | List of groups associated with this region. The engine triggers the first valid group based on current reinforcement counts. |

**Example .tsr Configuration:**
```
Group()
{
    Name("hot_carrier_away1");
    Reinforcements(0.7);
    Alliance("all_vo_shipaway1");
    Empire("imp_vo_shipaway1");
}

Region()
{
     Name("hot_hanger");
     Group("hot_carrier_away1");
}
```
To activate this, create a region in ZeroEditor labeled `soundtrigger hot_hanger`.

### Control Zones / Command Posts
Command Post (CP) audio logic is divided between specific instance voice-overs and global class properties.

#### Command Post Voice-Overs
Voice-over triggers follow the naming format: `VO_{PlayerSide}_{ActionSide}{Event}`.
*   **PlayerSide**: The faction the player is on (`All`, `Imp`, `Rep`, `Cis`).
*   **ActionSide**: The faction involved in the event.

| Event Type | Description |
| :--- | :--- |
| **Capture** | Triggered when a CP is captured. |
| **Lost** | Triggered when a CP is lost. |
| **InDispute** | Triggered when a CP becomes contested. |
| **Saved** | Triggered when a contested CP is secured. |
| **Info** | Periodic status updates (e.g., "Defend the bunker"). |

**Example:** `VO_All_ImpLost` plays when the player is Alliance and the Empire loses a CP.

#### Command Post Class Properties
These properties are defined in the CP's ODF file and apply to all instances.
| Property | Description |
| :--- | :--- |
| **ChargeSound** | Looped audio played during the transition from neutral to captured. |
| **CapturedSound** | Triggered upon successful capture (Neutral -> Captured). |
| **DischargeSound** | Looped audio played during the transition from captured to neutral. |
| **LostSound** | Triggered when a CP returns to neutral (Captured -> Neutral). |
| **DisputeSound** | Played when an enemy enters the capture zone during a capture attempt. |
| **AmbientSound** | `AmbientSound = "Side soundID"`. Constant ambient loop attached to the CP. |
| **SoundPitchDev** | Scalar (0.0 to 1.0) for pitch randomization during charge/discharge. |
| **CaptureMusic** | `CaptureMusic = "Side musicID"`. Music triggered for the capturing player. |
| **LostMusic** | `LostMusic = "Side musicID"`. Music triggered when an allied CP is lost. |

### Lightning Effect
Lightning sounds are defined in the world’s `.fx` file. These sounds must be **2D**, **memory-resident** (non-streaming), and **one-shot**.

| Property | Description |
| :--- | :--- |
| **SoundCrack** | Played during the initial incident lightning flash. |
| **SoundSubCrack** | Played during each subsequent rapid sub-flash. |

## Foley Effects (ffx files)
Foley effects define the sounds generated when objects collide (e.g., footsteps on a bridge). When a collision occurs, the engine checks the **collidee** (the object hit) for its `FoleyFXGroup`. It then looks for an entry within that group matching the `FoleyFXClass` of the **collider** (the object moving).

*Note: The `.ffx` configuration file must be loaded via script before any objects that reference its groups.*

### ODF Integration
| Property | Description |
| :--- | :--- |
| **FoleyFXClass** | Assigned to the moving object (e.g., a soldier). Categorizes the object for foley lookups. |
| **FoleyFXGroup** | Assigned to the surface/object being hit (e.g., a floor). References a group in an `.ffx` file. |

### FoleyFXGroup
A collection of foley definitions for different unit classes on a specific surface type.
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for the group (referenced by ODFs). |
| **FoleyFX** | References the name of a specific `FoleyFXSoldier`, `FoleyFXWalker`, or `FoleyFXImpact` definition. |

**Environmental Overrides:**
Since terrain and water are not standard game objects, they use hardcoded group names:
*   **terrain_foley**: Applied to the world terrain.
*   **water_foley**: Applied to the world water layer.

### FoleyFXImpact
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for this impact effect. |
| **Class** | The `FoleyFXClass` of the object triggering the impact. |
| **Impact** | Sound property played upon collision. |

### FoleyFXSoldier
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for this soldier foley set. |
| **Class** | The `FoleyFXClass` of the soldier (e.g., `rep_inf`). |
| **FootstepLeftWalk / RightWalk** | Sounds played during the walking cycle. |
| **FootstepLeftRun / RightRun** | Sounds played during the running cycle. |
| **FootstepLeftStop / RightStop** | Sounds played when the unit comes to a halt. |
| **Jump** | Sound played when the unit leaps. |
| **Land** | Sound played when the unit hits the surface after falling. |
| **Roll** | Sound played during a dodge roll. |
| **Prone** | Sound played when entering the prone state (deprecated). |
| **Squat** | Sound played when crouching. |
| **Stand** | Sound played when standing up from a crouch or prone. |
| **Impact** | Sound played when the soldier's collision volume hits the surface. |
| **BodyFall** | Sound played when the soldier hits the surface during a tumble/knockdown. |

### FoleyFXWalker
| Property | Description |
| :--- | :--- |
| **Name** | Unique identifier for this walker foley set. |
| **Class** | The `FoleyFXClass` of the walker. |
| **Walker[0-5]** | Sound hooks for feet 0 through 5 respectively. |
| **Impact** | Sound played when the walker's hull hits the surface. |

### Collider / Collidee ODF Properties
All game objects that support collision can function as foley effect colliders (the moving entity) or collidees (the surface being hit).

| Property | Description |
| :--- | :--- |
| **FoleyFXClass** | Applied to the **collider**. Defines the foley classification associated with the moving object. |
| **FoleyFXGroup** | Applied to the **collidee**. References a specific `FoleyFXGroup` from an `.ffx` file to determine the sounds played when objects collide with it. |

# AI Voice Over Hooks
AI Voice-over (VO) hooks are defined in ODF files using the `VOSound` property. These hooks use an **Event Type** and optional **Modifiers** to trigger contextual battle chatter.

### VOSound Schema
`VOSound = "SoundProperty EventName [+Modifier1 +Modifier2 ...]" `
> NOTE: Tabs are invalid whitespace characters, use only spaces in separating modifiers!

The engine selects the **most specific** match available. For example:
*   `VOSound = "snd1 AcquiredTarget"` (Generic battle chatter)
*   `VOSound = "snd2 AcquiredTarget +Above"` (Chatter for elevated targets)
*   `VOSound = "snd3 AcquiredTarget +Above +IsSniper"` (Specific alert for snipers on high ground)

### Modifier Sets
Modifiers come in distinct sets. You can only apply one modifier (or none) from each set at a time to a single `VOSound` entry.

| Set | Modifier | Description |
| :--- | :--- | :--- |
| **1: Orientation** | `Above`, `Below`, `Cover` | Target's vertical position relative to the speaker, or concealment status. |
| **2: Direction** | `Right`, `Left`, `Behind` | Target's horizontal direction relative to the speaker. |
| **3: Distance** | `ReallyNear`, `Near`, `ReallyFar` | Proximity ranges: `<10m`, `<30m`, or `>100m`. |
| **4: Target Health** | `TargetHealthBelow25` | Checks if the Target unit is critically wounded. |
| **5: Player Health** | `PlayerHealthBelow25` | Checks if the Local Player (the listener) is critically wounded. |
| **6: Target Type** | `IsFlyer`, `IsHover`, `IsWalker`, `IsTurret`, `IsSniper`, `IsRocket`, `IsHero` | The unit/object classification of the Target. |
| **7: Player Status** | `InFlyer`, `InHover`, `InWalker`, `InTurret`, `IsZoomed`, `IsProne` | Current vehicle or state of the Local Player. |
| **8: Adrenaline** | `AdrenalineLow`, `AdrenalineMedium`, `AdrenalineHigh` | combat intensity level. View via `ai.showadrenaline` in the dev console. |
| **9: Unit ID** | `VOUnitNum[ID]` | Matches a target's `VOUnitType` (1-255) specified in their ODF. |

### VO Event Hooks
The **Speaker** is the ODF where the sound is defined. The **Target** is the object used for location and type modifiers.

| Event Hook | Speaker | Target | Description |
| :--- | :--- | :--- | :--- |
| **AcquiredTarget** | Unit picking target | New Target | Battle chatter when AI picks a target. |
| **FriendlyFire** | Unit being shot | Shooter (Player) | Played when you shoot an allied AI unit. |
| **MissileLocking** | Local Player | Missile Source | Alert stages for incoming missile locks. |
| **MissileLocked** | Local Player | Missile Source | Alert stages for incoming missile locks. |
| **MissileIncoming** | Local Player | Missile Source | Alert stages for incoming missile locks. |
| **PathFollowWait** | Unit stopping | Local Player | Played when AI pauses on a path (e.g., to take cover). |
| **Kill** | Nearby Allied AI | Slain Target | Allies reacting to a player's kill. |
| **HeadshotKill** | Nearby Allied AI | Slain Target | reaction to player headshot kills. |
| **KillingSpree[N]** | Nearby Units | N/A | Triggered by 4, 8, 12, or 16 kills in a row (resets after 4s). |
| **Grenade** | dodging Unit | Grenade | alert for detected nearby grenades. |
| **RepairStart** | Repair Unit | Repair Target | AI starting a repair or building construction. |
| **RepairEnd** | Repair Unit | Repair Target | AI completing a repair or building construction. |
| **GivePowerup** | Support Unit | Recipient | AI unit dispensing a health/ammo pickup. |
| **DefendIdle[Anim]**| Defending AI | N/A | Idle behaviors: `LookWeapon`, `LookAround`, `LookPlayer`. |
| **RebelsShootDeadBody**| rebel Killer | Slain Target | Rebels trash-talking over a slain enemy's corpse. |
| **SC_[Command]** | Local Player | Command Target | Player issuing Squad Commands (see detail below). |
| **SC_[Cmd]Response** | Target Unit | Local Player | AI response to player Squad Commands. |
| **SC_GetInResponseRepeat**| Boarding Unit | Player Vehicle | Sarcastic reply to repeated "Get In" orders. |
| **NotShootingCriticalHit**| Nearby AI | Target Vehicle | AI advice to target vehicle weak points (every 5s). |
| **JustBoardedVehicle** | Boarding AI | Joined Vehicle | trigger when AI joins the player's vehicle. |
| **VehicleWaitingImpatiently**| Vehicle Driver | Local Player | taunt when player orders a vehicle to wait but doesn't board. |
| **NearbyEnemySlaughter** | Nearby AI | N/A | 4+ enemies die in 8s within 25m of player. |
| **NearbyFriendlySlaughter**| Nearby AI | N/A | 4+ allies die in 8s within 25m of player. |
| **NearbyTeamKillSlaughter**| Nearby AI | N/A | 4+ team-kills die in 8s within 25m of player. |

### Detail: Repair & Support VO
Use modifiers to create specific dialog for vehicles vs. structures:
```
VOSound = "snd_fix_tank RepairStart +IsHover"     -- "That hover needs some fixing"
VOSound = "snd_build_turret RepairStart +IsTurret" -- "I'll build a turret here"
VOSound = "snd_medkit GivePowerup"                 -- "Take this" (Soldier powerup)
```

### Detail: Squad Commands (SC)
Squad commands involve a command from the player (`SC_...`) and a response from the target unit (`SC_...Response`):
*   **Follow / StopFollow**: Order a soldier to accompany or leave you.
*   **VehicleWaitUp**: Order a vehicle to stop and wait for you.
*   **GetIn / GetOut**: Orders to board or vacate a vehicle. Boarding commands target the player's vehicle; exit commands target specific units within.
