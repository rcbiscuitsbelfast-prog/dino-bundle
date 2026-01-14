extends CharacterBody2D

# ⚙️ DINO MOVEMENT SETTINGS
const GRAVITY = 1200.0
const JUMP_FORCE = -450.0
const MAX_JUMPS = 2

var is_immune: bool = false
var jumps_remaining: int = MAX_JUMPS
var time: float = 0.0

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Animation player ready for future sprite-based animations
	pass

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	# Reset jumps when on ground
	if is_on_floor():
		jumps_remaining = MAX_JUMPS
	
	# Check for jump input (both keyboard and touch)
	# Allow double jump: can jump if we have jumps remaining
	if TouchInputHandler.check_jump_input() and jumps_remaining > 0:
		velocity.y = JUMP_FORCE
		jumps_remaining -= 1
	
	move_and_slide()
	
	# Running animation
	time += delta
	if color_rect:
		if is_on_floor():
			# Running bounce
			color_rect.position.y = sin(time * 15) * 2
		else:
			# In air - slight rotation
			color_rect.rotation = clamp(velocity.y / 1000.0, -0.3, 0.3)
			color_rect.position.y = 0

func grant_immunity(duration: float) -> void:
	is_immune = true
	if color_rect:
		color_rect.color = Color(0.2, 0.2, 1.0)  # Blue when immune
	await get_tree().create_timer(duration).timeout
	is_immune = false
	if color_rect:
		color_rect.color = Color(0.2, 0.8, 0.2)  # Back to green

func get_jumps_remaining() -> int:
	return jumps_remaining
