extends Control

func _ready() -> void:
	# Show banner ad on launcher
	AdManager.show_banner_ad()

func _on_flappy_pressed() -> void:
	get_tree().change_scene_to_file("res://flappy_dino/FlappyGame.tscn")

func _on_runner_pressed() -> void:
	get_tree().change_scene_to_file("res://dino_runner/RunnerGame.tscn")

func _on_explorer_pressed() -> void:
	get_tree().change_scene_to_file("res://dino_explorer/ExplorerGame.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://shared/Settings.tscn")

func _on_credits_pressed() -> void:
	# Show a simple credits dialog
	var credits_dialog = AcceptDialog.new()
	credits_dialog.title = "Credits"
	credits_dialog.dialog_text = "🦖 DINO GAME BUNDLE\n\nDeveloped with Godot 4.4\n\nFeaturing:\n• Flappy Dino\n• Dino Runner  \n• Dino Explorer\n\nThanks for playing!"
	add_child(credits_dialog)
	credits_dialog.popup_centered()
