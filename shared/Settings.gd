extends Control

# ⚙️ SETTINGS SCREEN SCRIPT
# Handles UI interactions and connects to SettingsManager

@onready var volume_slider: HSlider = $VBoxContainer/VolumeContainer/VolumeSlider
@onready var volume_value: Label = $VBoxContainer/VolumeContainer/VolumeValue
@onready var music_toggle: CheckButton = $VBoxContainer/MusicContainer/MusicToggle
@onready var sfx_toggle: CheckButton = $VBoxContainer/SFXContainer/SFXToggle
@onready var difficulty_selector: OptionButton = $VBoxContainer/DifficultyContainer/DifficultySelector
@onready var tutorial_toggle: CheckButton = $VBoxContainer/TutorialContainer/TutorialToggle
@onready var haptics_toggle: CheckButton = $VBoxContainer/HapticsContainer/HapticsToggle
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready() -> void:
	setup_difficulty_options()
	load_current_settings()
	connect_signals()

func setup_difficulty_options() -> void:
	difficulty_selector.clear()
	difficulty_selector.add_item("Easy")
	difficulty_selector.add_item("Normal")
	difficulty_selector.add_item("Hard")

func load_current_settings() -> void:
	# Load current values from SettingsManager
	volume_slider.value = SettingsManager.get_master_volume() * 100
	volume_value.text = str(int(SettingsManager.get_master_volume() * 100)) + "%"
	
	music_toggle.button_pressed = SettingsManager.is_music_enabled()
	sfx_toggle.button_pressed = SettingsManager.is_sfx_enabled()
	
	# Set difficulty selector
	var current_difficulty = SettingsManager.get_difficulty()
	match current_difficulty:
		"Easy":
			difficulty_selector.select(0)
		"Normal":
			difficulty_selector.select(1)
		"Hard":
			difficulty_selector.select(2)
	
	tutorial_toggle.button_pressed = SettingsManager.is_tutorial_enabled()
	haptics_toggle.button_pressed = SettingsManager.is_haptics_enabled()

func connect_signals() -> void:
	volume_slider.value_changed.connect(_on_volume_changed)
	music_toggle.toggled.connect(_on_music_toggled)
	sfx_toggle.toggled.connect(_on_sfx_toggled)
	difficulty_selector.item_selected.connect(_on_difficulty_changed)
	tutorial_toggle.toggled.connect(_on_tutorial_toggled)
	haptics_toggle.toggled.connect(_on_haptics_toggled)
	back_button.pressed.connect(_on_back_pressed)
	
	# Connect to SettingsManager signals for real-time updates
	SettingsManager.volume_changed.connect(_on_settings_volume_changed)

func _on_volume_changed(value: float) -> void:
	volume_value.text = str(int(value)) + "%"
	SettingsManager.set_master_volume(value / 100.0)

func _on_settings_volume_changed(volume: float) -> void:
	# Update UI when settings change externally
	volume_slider.value = volume * 100
	volume_value.text = str(int(volume * 100)) + "%"

func _on_music_toggled(enabled: bool) -> void:
	SettingsManager.set_music_enabled(enabled)
	music_toggle.text = enabled ? "On" : "Off"

func _on_sfx_toggled(enabled: bool) -> void:
	SettingsManager.set_sfx_enabled(enabled)
	sfx_toggle.text = enabled ? "On" : "Off"

func _on_difficulty_changed(index: int) -> void:
	var difficulties = ["Easy", "Normal", "Hard"]
	if index >= 0 and index < difficulties.size():
		SettingsManager.set_difficulty(difficulties[index])

func _on_tutorial_toggled(enabled: bool) -> void:
	SettingsManager.set_tutorial_enabled(enabled)
	tutorial_toggle.text = enabled ? "Show" : "Hide"

func _on_haptics_toggled(enabled: bool) -> void:
	SettingsManager.set_haptics_enabled(enabled)
	haptics_toggle.text = enabled ? "On" : "Off"

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://launcher/Launcher.tscn")