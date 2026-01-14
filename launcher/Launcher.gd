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
