extends Node

# 🎮 SETTINGS MANAGER - GLOBAL SETTINGS PERSISTENCE
# Handles all game settings with ConfigFile persistence
# Emits signals when settings change for real-time updates

signal settings_changed(setting_name: String, value)
signal volume_changed(volume: float)
signal music_enabled_changed(enabled: bool)
signal sfx_enabled_changed(enabled: bool)
signal difficulty_changed(difficulty: String)
signal tutorial_enabled_changed(enabled: bool)

# Settings values with defaults
var master_volume: float = 1.0
var music_enabled: bool = true
var sfx_enabled: bool = true
var difficulty: String = "Normal"  # Easy, Normal, Hard
var tutorial_enabled: bool = true
var haptics_enabled: bool = true
var unlimited_lives: bool = false

# Tutorial completion flags
var flappy_tutorial_seen: bool = false
var runner_tutorial_seen: bool = false
var explorer_tutorial_seen: bool = false

const CONFIG_FILE_PATH = "user://dino_bundle_settings.cfg"

func _ready() -> void:
    load_settings()

# Load settings from ConfigFile
func load_settings() -> void:
    var config = ConfigFile.new()
    var err = config.load(CONFIG_FILE_PATH)
    
    if err == OK:
        master_volume = config.get_value("audio", "master_volume", 1.0)
        music_enabled = config.get_value("audio", "music_enabled", true)
        sfx_enabled = config.get_value("audio", "sfx_enabled", true)
        difficulty = config.get_value("gameplay", "difficulty", "Normal")
        tutorial_enabled = config.get_value("gameplay", "tutorial_enabled", true)
        haptics_enabled = config.get_value("gameplay", "haptics_enabled", true)
        unlimited_lives = config.get_value("gameplay", "unlimited_lives", false)
        
        flappy_tutorial_seen = config.get_value("tutorials", "flappy_seen", false)
        runner_tutorial_seen = config.get_value("tutorials", "runner_seen", false)
        explorer_tutorial_seen = config.get_value("tutorials", "explorer_seen", false)
        
        print("Settings loaded successfully")
    else:
        print("No settings file found, using defaults")

# Save settings to ConfigFile
func save_settings() -> void:
    var config = ConfigFile.new()
    
    # Audio settings
    config.set_value("audio", "master_volume", master_volume)
    config.set_value("audio", "music_enabled", music_enabled)
    config.set_value("audio", "sfx_enabled", sfx_enabled)
    
    # Gameplay settings
    config.set_value("gameplay", "difficulty", difficulty)
    config.set_value("gameplay", "tutorial_enabled", tutorial_enabled)
    config.set_value("gameplay", "haptics_enabled", haptics_enabled)
    config.set_value("gameplay", "unlimited_lives", unlimited_lives)
    
    # Tutorial flags
    config.set_value("tutorials", "flappy_seen", flappy_tutorial_seen)
    config.set_value("tutorials", "runner_seen", runner_tutorial_seen)
    config.set_value("tutorials", "explorer_seen", explorer_tutorial_seen)
    
    var err = config.save(CONFIG_FILE_PATH)
    if err == OK:
        print("Settings saved successfully")
    else:
        print("Failed to save settings")

# Setter methods that emit signals and save
func set_master_volume(volume: float) -> void:
    master_volume = clamp(volume, 0.0, 1.0)
    volume_changed.emit(master_volume)
    settings_changed.emit("master_volume", master_volume)
    save_settings()

func set_music_enabled(enabled: bool) -> void:
    music_enabled = enabled
    music_enabled_changed.emit(enabled)
    settings_changed.emit("music_enabled", enabled)
    save_settings()

func set_sfx_enabled(enabled: bool) -> void:
    sfx_enabled = enabled
    sfx_enabled_changed.emit(enabled)
    settings_changed.emit("sfx_enabled", enabled)
    save_settings()

func set_difficulty(new_difficulty: String) -> void:
    if new_difficulty in ["Easy", "Normal", "Hard"]:
        difficulty = new_difficulty
        difficulty_changed.emit(difficulty)
        settings_changed.emit("difficulty", difficulty)
        save_settings()

func set_tutorial_enabled(enabled: bool) -> void:
    tutorial_enabled = enabled
    tutorial_enabled_changed.emit(enabled)
    settings_changed.emit("tutorial_enabled", enabled)
    save_settings()

func set_haptics_enabled(enabled: bool) -> void:
    haptics_enabled = enabled
    settings_changed.emit("haptics_enabled", enabled)
    save_settings()

# Tutorial flag setters
func set_flappy_tutorial_seen(seen: bool) -> void:
    flappy_tutorial_seen = seen
    settings_changed.emit("flappy_tutorial_seen", seen)
    save_settings()

func set_runner_tutorial_seen(seen: bool) -> void:
    runner_tutorial_seen = seen
    settings_changed.emit("runner_tutorial_seen", seen)
    save_settings()

func set_explorer_tutorial_seen(seen: bool) -> void:
    explorer_tutorial_seen = seen
    settings_changed.emit("explorer_tutorial_seen", seen)
    save_settings()

# Getters
func get_master_volume() -> float:
    return master_volume

func is_music_enabled() -> bool:
    return music_enabled

func is_sfx_enabled() -> bool:
    return sfx_enabled

func get_difficulty() -> String:
    return difficulty

func is_tutorial_enabled() -> bool:
    return tutorial_enabled

func is_haptics_enabled() -> bool:
    return haptics_enabled

func has_seen_flappy_tutorial() -> bool:
    return flappy_tutorial_seen

func has_seen_runner_tutorial() -> bool:
    return runner_tutorial_seen

func has_seen_explorer_tutorial() -> bool:
    return explorer_tutorial_seen

# Difficulty scaling multipliers for games
func get_difficulty_multiplier() -> float:
    match difficulty:
        "Easy":
            return 0.8
        "Normal":
            return 1.0
        "Hard":
            return 1.3
        _:
            return 1.0

func get_obstacle_spawn_multiplier() -> float:
    match difficulty:
        "Easy":
            return 0.7
        "Normal":
            return 1.0
        "Hard":
            return 1.4
        _:
            return 1.0

# Unlimited lives getter/setter
func get_unlimited_lives() -> bool:
    return unlimited_lives

func set_unlimited_lives(enabled: bool) -> void:
    unlimited_lives = enabled
    settings_changed.emit("unlimited_lives", enabled)
    save_settings()