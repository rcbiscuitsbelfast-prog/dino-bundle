extends CharacterBody2D

# ⚙️ BIRD SETTINGS - EASY TO ADJUST!
# Higher gravity = bird falls faster
const GRAVITY = 900.0

# More negative flap = bird jumps higher
const FLAP_STRENGTH = -300.0

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer

func _ready() -> void:
	# Animation player ready for future sprite-based animations
	pass

func _physics_process(delta: float) -> void:
	# Apply gravity to make bird fall
	velocity.y += GRAVITY * delta
	
	# Check for flap input (both keyboard and touch)
	# Only allow flapping if game has started (not paused)
	if not get_tree().paused and TouchInputHandler.check_flap_input():
		velocity.y = FLAP_STRENGTH
		# Flap animation - rotate up
		if color_rect:
			color_rect.rotation = -0.3
	
	move_and_slide()
	
	# Smooth rotation based on velocity
	if color_rect:
		var target_rotation = clamp(velocity.y / 500.0, -0.5, 0.5)
		color_rect.rotation = lerp(color_rect.rotation, target_rotation, delta * 5.0)
