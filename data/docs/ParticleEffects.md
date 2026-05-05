# Particle Effects
This document explains how particle effects work in Star Wars Battlefront 2. Particle effects are created using the **Particle Effect Editor**, which exports them as `.fx` files. 
> **Note:** These are distinct from world effect `.fx` files.

Sections:
- Particle Editor Setup (lines 12-15)
- Particle Effect Compatibility (lines 17-18)
- Particle Effect Overview (lines 20-46)
- Getting Particle Effects in the game (lines 49-73)

 ---

# Setup
The particle effect editor requires specific munged resources in designated directories to correctly display particle effects, models, and textures. 
*   **Editor Download:** Updated Particle Editor
*   **Installation Path:** Place the executable and munged folder into: `Star Wars Battlefront II\GameData\DATA\_LVL_PC`.

# Compatibility
Some `.fx` files (e.g., `droidekashield.fx`) cannot be opened in the Particle Editor. These are ODF/fx hybrids or `.fx` files built with ODF-like properties and must be edited manually in a text editor.

# Overview
Effects are composed of groups of particles given off by **emitters**. 
*   An effect can have one or many emitters.
*   *Example:* The Death Star power converter effect is one of the most emitter-intensive stock effects.

Every emitter must have **Spawner**, **Transformer**, and **Geometry** properties.

## Geometry Properties
*   **Particle:** Flat 2D plane that always faces the camera.
*   **Billboard:** Flat 2D plane fixed in-place.

## Transformer Properties
*   **Color:** How the color of the particle changes over time.
*   **Rotation:** How the rotation of the particle changes over time.
*   **Size:** How the size of the particle changes over time.

## Spawner Properties
*   **Color:** Starting particle color.
*   **Stages:** Starting size and rotations of a particle.

## General Properties
Particles have a number of additional properties for fine-tuning behavior:
*   Min-max values
*   Variance values
*   Sound properties
*   Delay times
*   Burst counts

# Getting Particle Effects in the game
Particle effects can be attached to most entities with geometry through the following ODF properties:
`AttachEffect: "<fxName>"`
`AttachToHardpoint: "<nodeInMshName>"`
If the entity moves or is animated, a preceding `AttachDynamic = "1"` line is required.

For entity damage-effects that are triggered when an entity reaches specified health thresholds, the following ODF properties are required:
`DamageStartPercent = "<healthFloat>"`
`DamageStopPercent = "<healthFloat>"`
`DamageEffect = "<fxName>"`
`DamageAttachPoint = "<nodeInMshName>"`
With the following optional ODF properties:
`DamageEffectScale = "<scaleFloat>"`
`DamageInheritVelocity = "<inheritFloat>"`
`DamageAttachOffset = "<xFloat> <yFloat> <zFloat>"`

Particle effects can also be spawned and positioned through the following lua functions:
`CreateEffect(effectFilename)`
`RemoveEffect(effect)`
`AttachEffectToObject(fx, obj)`
`AttachEffectToMatrix(fx, matrix)`
`GetEffectMatrix(effect)`
`SetEffectMatrix(effect, matrix)`
`IsEffectActive(effect)`
`SetEffectActive(effect, active)`
