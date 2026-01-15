extends CharacterBody2D

# ⚙️ DINO MOVEMENT SETTINGS
const GRAVITY: float = 1200.0
const JUMP_FORCE: float = -450.0
const MAX_JUMPS: int = 2

var is_immune: bool = false
var is_dead: bool = false
var jumps_remaining: int = MAX_JUMPS

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if animated_sprite:
		animated_sprite.play("run")


func _physics_process(delta: float) -> void:
	if is_dead:
		return  # Stop all movement + animation switching when dead

	velocity.y += GRAVITY * delta

	# Reset jumps when on ground
	if is_on_floor():
		jumps_remaining = MAX_JUMPS
		if animated_sprite.animation != "run":
			animated_sprite.play("run")
	else:
		if animated_sprite.animation != "jump":
			animated_sprite.play("jump")

	# Jump input
	if TouchInputHandler.check_jump_input() and jumps_remaining > 0:
		velocity.y = JUMP_FORCE
		jumps_remaining -= 1
		animated_sprite.play("jump")

	move_and_slide()


func play_dead_animation() -> void:
	if is_dead:
		return

	is_dead = true
	animated_sprite.play("dead")
	velocity = Vector2.ZERO  # Stop movement immediately


func grant_immunity(duration: float) -> void:
	is_immune = true
	animated_sprite.modulate = Color(0.3, 0.3, 1.0, 1.0)

	await get_tree().create_timer(duration).timeout

	is_immune = false
	animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)


func get_jumps_remaining() -> int:
	return jumps_remaining
