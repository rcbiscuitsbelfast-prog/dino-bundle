extends CharacterBody2D

# ⚙️ DINO MOVEMENT SETTINGS
const GRAVITY = 1200.0
const JUMP_FORCE = -450.0

var is_immune: bool = false

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	move_and_slide()

func grant_immunity(duration: float) -> void:
	is_immune = true
	$ColorRect.color = Color(0.2, 0.2, 1.0)  # Blue when immune
	await get_tree().create_timer(duration).timeout
	is_immune = false
	$ColorRect.color = Color(0.2, 0.8, 0.2)  # Back to green
