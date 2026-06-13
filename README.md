# LAMA Sounds in Space

A research game built with **Godot 4.4** for the [UTM LAMA Lab](https://www.utmlamalab.com/) (Language, Attention, Music & Audition) at the University of Toronto Mississauga.

---

## Research Context

The **LAMA Lab**, led by Dr. Christina Vanden Bosch der Nederlanden, studies how children and adults perceive and process language and music, with a focus on how people listen to speech and song in everyday settings. The lab is particularly interested in how children&#39;s knowledge of speech and song develops across childhood, and infinding ways to study these questions that are accessible and engaging for young children. **Sounds in Space** is part of an ongoing effort to reimagine standard auditory assessments as game-like experiences that lower the barrier of participation for young children while still capturing meaningful data.

## About

Rather than a traditional lab task, Sounds in Space places a child inside a space port environment where their voice helps shape what happens on screen. Spoken and sung phrases are played back through the game; the child responds by imitating them, and their microphone input drives an animated audio visualizer. Characters including an alien, a UFO, and Lucky the lama guide the child through sessions via a branching dialogue system, while a research-facing control panel and event logger capturesession data for the LAMA Lab team.

## Features

- **Dialogue system** — Branching conversations powered by [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager), with localization support via `.dialogue` script files
- **Character sequencers** — Each character (Player, Alien, UFO, Lama) has its own sequencer for coordinating behavior and narrative state
- **Audio system** — Custom audio bus layout with a built-in recorder, real-time visualizer, and stimuli player
- **Custom shaders** — Stylized rendering with diffuse/rim curve shaders and global shader parameters for fuel level and color
- **Session & event logging** — A global session manager tracks user interactions and emits events; an event logger records them
- **Screenshot capture** — Press `F12` (or the bound screenshot key) to save a timestamped PNG to the `screenshots/` folder
- **Custom UI theme** — Consistent visual style via a project-wide UI theme

## Tech Stack

| | |
|---|---|
| Engine | Godot 4.4 |
| Primary language | GDScript |
| Dialogue | Dialogue Manager addon |
| Art | Aseprite (custom pixel art palette) |

## Project Structure

```
SpacePortAdventure/
├── characters/         # Character scenes and sequencers (player, alien, ufo, lama)
├── components/         # Core autoloads: Sequencer, Session, EventLogger
├── dialogue/           # Dialogue scripts (.dialogue files) for all interactions
├── audio/              # Audio bus layout, recorder, visualizer, player
├── animations/         # Animation resources
├── level/              # Level scenes and environment
├── ui/                 # UI scenes, theme, and game window
├── shaders/            # Custom GDShader files and texture inputs
├── addons/             # Third-party plugins (Dialogue Manager, Todo Manager)
├── export/builds/      # Compiled export targets
├── screenshots/        # In-game screenshot output directory
├── game.tscn           # Main scene
├── game.gd             # Root game script
└── project.godot       # Godot project configuration
```

## Getting Started

### Prerequisites

- [Godot Engine 4.4](https://godotengine.org/download/) (standard)

### Running the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/coheredigital/SpacePortAdventure.git
   ```
2. Open Godot 4.4 and import the project by selecting the `project.godot` file.
3. Press **F5** or click **Run** to launch the game.

### Exporting

Export presets are configured in `export_presets.cfg`. Open **Project → Export** in the Godot editor to build for your target platform.

## Controls

| Action | Input |
|---|---|
| Confirm / Click | Left Mouse Button |
| Screenshot | F12 |

## Autoloads (Global Singletons)

| Name | Purpose |
|---|---|
| `Sequencer` | Central narrative/mission sequencer |
| `Session` | Tracks session state and user interaction events |
| `Character` | Base character sequencer |
| `Player` | Player-specific sequencer |
| `Alien` | Alien character sequencer |
| `Ufo` | UFO character sequencer |
| `Lama` | Lama character sequencer |
| `Recorder` | Audio recording |
| `Visualizer` | Real-time audio visualization |
| `Stimuli` | Audio stimuli playback |
| `EventLogger` | Logs in-game events |
| `DialogueManager` | Manages dialogue flow |

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. See [LICENSE](LICENSE) for details.
