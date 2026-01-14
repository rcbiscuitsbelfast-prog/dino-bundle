extends CharacterBody2D

# ⚙️ DINO MOVEMENT SETTINGS
const GRAVITY = 1200.0
const JUMP_FORCE = -450.0
const MAX_JUMPS = 2

var is_immune: bool = false
var jumps_remaining: int = MAX_JUMPS

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Start with run animation
	if animated_sprite:
		animated_sprite.play("run")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	# Reset jumps when on ground
	if is_on_floor():
		jumps_remaining = MAX_JUMPS
		# Play run animation when on ground
		if animated_sprite and animated_sprite.animation != "run":
			animated_sprite.play("run")
	else:
		# Play jump animation when in air
		if animated_sprite and animated_sprite.animation != "jump":
			animated_sprite.play("jump")
	
	# Check for jump input (both keyboard and touch)
	# Allow double jump: can jump if we have jumps remaining
	if TouchInputHandler.check_jump_input() and jumps_remaining > 0:
		velocity.y = JUMP_FORCE
		jumps_remaining -= 1
		# Switch to jump animation immediately when jumping
		if animated_sprite:
			animated_sprite.play("jump")
	
	move_and_slide()

func grant_immunity(duration: float) -> void:
	is_immune = true
	if animated_sprite:
		# Make sprite blue-tinted when immune
		animated_sprite.modulate = Color(0.3, 0.3, 1.0, 1.0)
	await get_tree().create_timer(duration).timeout
	is_immune = false
	if animated_sprite:
		# Return to normal color
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

func get_jumps_remaining() -> int:
	return jumps_remaining
