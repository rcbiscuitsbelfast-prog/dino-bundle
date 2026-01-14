extends CharacterBody2D

# ⚙️ BIRD SETTINGS - EASY TO ADJUST!
# Higher gravity = bird falls faster
const GRAVITY = 900.0

# More negative flap = bird jumps higher
const FLAP_STRENGTH = -300.0

@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var sprite: Sprite2D = $ColorRect/AnimationPlayer/Fly000

var is_dead: bool = false
var is_hurt: bool = false

func _ready() -> void:
	# Flip bird horizontally
	if sprite:
		sprite.flip_h = true  # Set to false if you want to flip the other way
	
	# Start with fly animation
	if animation_player:
		animation_player.play("fly")

func _physics_process(delta: float) -> void:
	# Don't process if dead
	if is_dead:
		return
	
	# Apply gravity to make bird fall
	velocity.y += GRAVITY * delta
	
	# Check for flap input (both keyboard and touch)
	# Only allow flapping if game has started (not paused)
	if not get_tree().paused and TouchInputHandler.check_flap_input():
		velocity.y = FLAP_STRENGTH
		# Keep fly animation playing when flapping
		if animation_player and not is_hurt:
			animation_player.play("fly")
	
	move_and_slide()
	
	# Smooth rotation based on velocity (only if not dead)
	if not is_dead:
		var target_rotation = clamp(velocity.y / 500.0, -0.5, 0.5)
		rotation = lerp(rotation, target_rotation, delta * 5.0)

func play_hurt_animation() -> void:
	# Play hurt animation when taking damage
	is_hurt = true
	if animation_player:
		animation_player.play("hurt")
		# After hurt animation, return to fly
		await animation_player.animation_finished
		is_hurt = false
		if not is_dead and animation_player:
			animation_player.play("fly")

func play_dead_animation() -> void:
	# Play dead animation when bird dies
	is_dead = true
	if animation_player:
		animation_player.play("dead")
