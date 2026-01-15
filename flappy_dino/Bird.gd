extends CharacterBody2D

const GRAVITY: float = 900.0
const FLAP_STRENGTH: float = -300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_dead: bool = false
var is_hurt: bool = false

func _ready() -> void:
	# Flip the bird horizontally if needed
	sprite.flip_h = true

	# Start with the fly animation
	sprite.play("fly")


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Apply gravity
	velocity.y += GRAVITY * delta

	# Flap input (touch or keyboard)
	if not get_tree().paused and TouchInputHandler.check_flap_input():
		velocity.y = FLAP_STRENGTH

		# Keep fly animation active unless hurt
		if not is_hurt:
			sprite.play("fly")

	move_and_slide()

	# Smooth rotation based on falling/rising
	if not is_dead:
		var target_rotation: float = clamp(velocity.y / 500.0, -0.5, 0.5)
		rotation = lerp(rotation, target_rotation, delta * 5.0)


func play_hurt_animation() -> void:
	is_hurt = true
	sprite.play("hurt")
	await sprite.animation_finished

	is_hurt = false
	if not is_dead:
		sprite.play("fly")


func play_dead_animation() -> void:
	is_dead = true
	sprite.play("dead")
