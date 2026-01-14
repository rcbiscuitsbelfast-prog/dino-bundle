extends CharacterBody2D

# ⚙️ PLAYER MOVEMENT SETTINGS
const SPEED = 150.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var time: float = 0.0

func _ready() -> void:
    # Simple idle animation (bounce)
    if animation_player:
        animation_player.play("RESET")

func _physics_process(delta: float) -> void:
    var direction = TouchInputHandler.get_movement_input()
    velocity = direction * SPEED
    move_and_slide()
    
    # Simple visual feedback based on movement
    time += delta
    if velocity.length() > 10:
        # Moving - slight bob
        rotation = sin(time * 10) * 0.05
    else:
        # Idle - subtle bounce
        rotation = sin(time * 2) * 0.02
