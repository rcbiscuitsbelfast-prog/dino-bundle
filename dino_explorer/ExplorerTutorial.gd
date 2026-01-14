extends CanvasLayer

# 🧭 DINO EXPLORER TUTORIAL
# Shows on first launch to teach movement and objectives

@onready var got_it_button: Button = $TutorialPanel/VBox/GotItButton
@onready var skip_button: Button = $TutorialPanel/VBox/SkipButton

func _ready() -> void:
    got_it_button.pressed.connect(_on_got_it_pressed)
    skip_button.pressed.connect(_on_skip_pressed)

func _on_got_it_pressed() -> void:
    TutorialManager.complete_tutorial()
    if get_parent().has_method("start_game"):
        get_parent().start_game()
    queue_free()

func _on_skip_pressed() -> void:
    TutorialManager.skip_tutorial()
    if get_parent().has_method("start_game"):
        get_parent().start_game()
    queue_free()