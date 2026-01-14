extends CharacterBody2D

# ⚙️ PLAYER MOVEMENT SETTINGS
const SPEED = 150.0

func _physics_process(_delta: float) -> void:
    var direction = TouchInputHandler.get_movement_input()
    velocity = direction * SPEED
    move_and_slide()
