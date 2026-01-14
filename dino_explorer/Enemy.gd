extends CharacterBody2D

# ⚙️ ENEMY AI SETTINGS
const SPEED = 80.0
const CHASE_RANGE = 200.0  # How close player must be to chase
const ATTACK_RANGE = 40.0  # How close to damage player

var player: CharacterBody2D = null
var patrol_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	# Random initial patrol direction
	patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	var distance_to_player = position.distance_to(player.position)
	
	# 🎯 CHASE PLAYER if close enough
	if distance_to_player < CHASE_RANGE:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED
		$ColorRect.color = Color(1.0, 0.3, 0.3)  # Red when chasing
	else:
		# 🚶 PATROL when player is far
		velocity = patrol_direction * (SPEED * 0.5)
		$ColorRect.color = Color(0.8, 0.2, 0.2)  # Darker when patrolling
		
		# Change direction randomly
		if randf() < 0.01:
			patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	move_and_slide()

func set_player(p: CharacterBody2D) -> void:
	player = p
