extends Node

# 📚 TUTORIAL MANAGER - HANDLES TUTORIAL FLOW
# Manages showing tutorials once per game and tutorial flags

signal tutorial_shown(tutorial_type: String)
signal tutorial_completed(tutorial_type: String)

var current_tutorial: String = ""
var is_tutorial_active: bool = false

func _ready() -> void:
	print("TutorialManager initialized")

# Check if tutorial should be shown
func should_show_tutorial(game_type: String) -> bool:
	# Don't show if tutorials are disabled
	if not SettingsManager.is_tutorial_enabled():
		return false
	
	# Check if specific tutorial has been seen
	match game_type:
		"flappy":
			return not SettingsManager.has_seen_flappy_tutorial()
		"runner":
			return not SettingsManager.has_seen_runner_tutorial()
		"explorer":
			return not SettingsManager.has_seen_explorer_tutorial()
		_:
			return false

# Show tutorial for specific game
func show_tutorial(game_type: String) -> void:
	if is_tutorial_active:
		return
	
	current_tutorial = game_type
	is_tutorial_active = true
	
	# Mark tutorial as seen
	match game_type:
		"flappy":
			SettingsManager.set_flappy_tutorial_seen(true)
		"runner":
			SettingsManager.set_runner_tutorial_seen(true)
		"explorer":
			SettingsManager.set_explorer_tutorial_seen(true)
	
	tutorial_shown.emit(game_type)
	print("Showing tutorial for: ", game_type)

# Complete tutorial (called when user skips or completes)
func complete_tutorial() -> void:
	if current_tutorial != "":
		tutorial_completed.emit(current_tutorial)
		is_tutorial_active = false
		current_tutorial = ""
		print("Tutorial completed: ", current_tutorial)

# Skip tutorial
func skip_tutorial() -> void:
	complete_tutorial()

# Reset tutorial flags (for testing)
func reset_tutorial_flags() -> void:
	SettingsManager.set_flappy_tutorial_seen(false)
	SettingsManager.set_runner_tutorial_seen(false)
	SettingsManager.set_explorer_tutorial_seen(false)
	print("Tutorial flags reset")