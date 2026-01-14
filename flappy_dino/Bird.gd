extends CharacterBody2D

# ⚙️ BIRD SETTINGS - EASY TO ADJUST!
# Higher gravity = bird falls faster
const GRAVITY = 900.0

# More negative flap = bird jumps higher
const FLAP_STRENGTH = -300.0

func _physics_process(delta: float) -> void:
    # Apply gravity to make bird fall
    velocity.y += GRAVITY * delta
    
    # Check for flap input (both keyboard and touch)
    if TouchInputHandler.check_flap_input():
        velocity.y = FLAP_STRENGTH
    
    move_and_slide()
