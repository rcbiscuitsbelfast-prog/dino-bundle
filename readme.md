# 🦖 Dino Game Bundle

A complete Godot 4.4 game bundle featuring three playable dino-themed games with shared utilities and ad integration support.

## 📅 Last Updated
**Date:** January 14, 2025  
**Time:** 00:47 UTC  
**Version:** 1.0.0

## 🎮 Games Included

### 1. Flappy Dino
- Flappy Bird-style gameplay
- Parallax scrolling backgrounds
- Pipe obstacles with random gaps
- Lives system with ad rewards

### 2. Dino Runner
- Endless runner gameplay
- Multiple obstacle types (Cactus, Rock, Pterodactyl)
- Power-ups (Shield, Extra Life)
- Random obstacle spawning

### 3. Dino Explorer
- Top-down exploration game
- Enemy AI with chase/patrol behavior
- Pet/friendly dino collection mechanic
- Collision-based combat system

## 🚀 Features

- **Shared Systems:**
  - Ad Manager (placeholder for ad integration)
  - Color customization system
  - Utility functions
  - Launcher menu system

- **Game Features:**
  - Lives and scoring systems
  - Game over panels with ad rewards
  - Restart and menu navigation
  - Camera2D integration for proper rendering

## 📁 Project Structure

```
dino-bundle/
├── project.godot          # Main project configuration
├── launcher/              # Main menu launcher
│   ├── Launcher.gd
│   └── Launcher.tscn
├── shared/                # Shared utilities
│   ├── AdManager.gd      # Ad integration (placeholder)
│   ├── colors.gd         # Color constants
│   └── utils.gd          # Utility functions
├── flappy_dino/          # Flappy Dino game
│   ├── Bird.gd & Bird.tscn
│   ├── PipePair.gd & PipePair.tscn
│   └── FlappyGame.tscn
├── dino_runner/          # Dino Runner game
│   ├── Dino.gd & Dino.tscn
│   ├── Obstacle.gd & Obstacle.tscn
│   ├── PowerUp.gd & PowerUp.tscn
│   └── RunnerGame.tscn
├── dino_explorer/        # Dino Explorer game
│   ├── Player.gd & Player.tscn
│   ├── Enemy.gd & Enemy.tscn
│   ├── PetDino.gd & PetDino.tscn
│   └── ExplorerGame.tscn
└── Assets/               # Game assets
    ├── download/         # Dino sprite collection
    ├── free_blue_dino_side_frakassets/
    └── FreeDinoSprite/
```

## 🛠️ Setup Instructions

1. **Open in Godot:**
   - Requires Godot 4.4 or later
   - Open the project folder in Godot
   - The project will automatically load with `launcher/Launcher.tscn` as the main scene

2. **Autoload Configuration:**
   - `AdManager` is configured as an autoload singleton in `project.godot`
   - This allows global access to ad functions throughout the project

3. **Run the Project:**
   - Press F5 or click the Play button
   - The launcher menu will appear with three game options

## 🎯 Controls

- **Flappy Dino:** Space/Enter to flap
- **Dino Runner:** Space/Enter to jump
- **Dino Explorer:** WASD or Arrow Keys to move, Space to pet friendly dinos

## 📝 Notes

- Ad integration is currently placeholder - replace `AdManager.gd` functions with your actual ad plugin
- All games use simple geometric shapes for visuals - replace with sprites from the Assets folder
- Camera2D nodes are included in all game scenes for proper rendering
- Games are fully playable but can be customized and enhanced

## 📄 License

GNU General Public License v3.0 - See LICENSE file for details.

## 🔄 Changelog

### Version 1.0.0 (January 14, 2025)
- Initial project extraction from bundle file
- Added Camera2D nodes to all game scenes
- Configured AdManager as autoload singleton
- Extracted and organized all game files
- Extracted asset ZIP files to assets folder
- Project structure fully organized and ready to use
