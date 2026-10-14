<div align="center">

# Spaceship Strategy Simulator

*A functional Oz implementation of a grid-based spaceship game*

![Language](https://img.shields.io/badge/Language-Mozart%2FOz-blue.svg)
![Paradigm](https://img.shields.io/badge/Paradigm-Functional-orange.svg)
![Project](https://img.shields.io/badge/Project-University%20Coursework-green.svg)

[About](#about) • [Game Scenario](#game-scenario) • [Implementation](#implementation) • [Usage](#usage) • [Repository Structure](#repository-structure)

</div>

---

## About

This project implements the game-logic layer for a graphical, grid-based spaceship game in **Mozart/Oz**. Two spaceships follow predefined strategies while moving around a 24 × 24 board and interacting with obstacles and special tiles.

The implementation focuses on translating high-level game instructions into state transitions. It updates each ship's position and direction, moves its trailing segments, and applies active effects as the game progresses.

The accompanying [project report](Rapport.pdf) provides additional academic context.

### Highlights

- Functional state transformations for spaceship movement and turning
- Strategy decoding for `forward`, `turn(left)`, and `turn(right)` instructions
- Support for repeated instructions in a strategy
- Handling of effects including wormholes, ship reversal, scrap, ghost, electromagnetic bombs, and seismic-charge drops
- A configurable scenario featuring two ships, walls, and colored bonus tiles
- Graphical playback through the course-provided `LethOzLib` library

---

## Game Scenario

The supplied `Scenario.oz` configures a two-player game on a **24 × 24 grid**:

| Setting | Value |
|---------|-------|
| Ships | Steve (green) and Patrick (red) |
| Walls | Enabled |
| Bomb latency | 3 |
| Initial seismic charges | None |
| Bonus effects | Wormholes, ghost, seismic-charge drops, electromagnetic bombs, reversal, and scrap |

Each ship has a list of instructions that defines its route. The game library uses the scenario and the transition functions in `Code.oz` to run and display the game.

---

## Implementation

### Movement and state transitions

`Next` applies one instruction to a spaceship. It calculates the new head position and orientation, updates the remaining segments, and processes any active effects.

### Strategy decoding

`DecodeStrategy` converts the scenario's instruction list into the sequence of transition functions expected by the game library. The supported basic instructions are:

```text
forward
turn(left)
turn(right)
```

Strategies can also express repeated instructions using the scenario's `repeat(... times:...)` form.

### Effects

The transition logic includes handling for the effects used in the project scenario:

| Effect | Behavior |
|--------|----------|
| **Wormhole** | Moves the ship to the paired grid position |
| **Revert** | Reverses the ship's segment order and directions |
| **Scrap** | Changes the ship's segment configuration |
| **Ghost** | Preserves the effect while the ship moves |
| **EMB** | Tracks the remaining electromagnetic-bomb duration |
| **Drop seismic charge** | Marks a seismic charge as available on the ship |

---

## Usage

### Prerequisites

- Mozart/Oz and an environment capable of running Oz programs
- The course-provided `LethOzLib.ozf` graphical game library

`LethOzLib.ozf` is not included in this repository. Obtain it from the course materials and place it in the project directory, or update the library path in `Code.oz`.

### Configure and run

1. Clone or download this repository.
2. Open `Code.oz` and set `Dossier` to the local directory containing `LethOzLib.ozf`.
3. Make the scenario path in `Options.scenario` match the repository layout. The checked-in file is at the project root (`Scenario.oz`), while the current option refers to `scenario/Scenario.oz`. Either update the option to `Scenario.oz` or place the scenario at the configured path.
4. Run `Code.oz` with your Mozart/Oz environment.

The game is configured for graphical playback at **5 steps per second**. Press **Escape** to close the graphical window. Set `frameRate` to `0` in `Code.oz` for step-by-step playback, as supported by the game library.

---

## Repository Structure

```text
.
├── Code.oz       # Movement, effect handling, and strategy decoding
├── Scenario.oz   # Board settings, ships, routes, and bonus tiles
├── Rapport.pdf   # Project report
└── README.md
```

---

## What This Project Demonstrates

- Modeling a game entity as structured state in Oz
- Recursive list processing and state updates
- Separating scenario data from game-transition logic
- Translating declarative instructions into executable behavior
- Integrating a program with an external graphical library

---

## License

This repository does not currently include an open-source license. The project was developed as university coursework; check with the author before reusing or redistributing its contents.
