extends CharacterBody2D

# ⚙️ ENEMY AI SETTINGS
const SPEED = 100.0  # Slower than before
const CHASE_RANGE = 300.0  # Aggro range
const ATTACK_RANGE = 40.0  # Attack distance
const FLEE_RANGE = 150.0  # Back off when player invincible

var player: CharacterBody2D = null
var patrol_direction: Vector2 = Vector2.RIGHT
var game_node: Node = null
var time: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    # Random initial patrol direction
    patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
    # Get reference to game node
    await get_tree().process_frame
    game_node = get_tree().current_scene
    # Animation player ready for future sprite-based animations

func _physics_process(delta: float) -> void:
    if player == null:
        return
    
    var distance_to_player = position.distance_to(player.position)
    var player_invincible = false
    
    # Check if player is invincible
    if game_node and game_node.has_method("get") and "is_invincible" in game_node:
        player_invincible = game_node.is_invincible
    
    # 🏃 FLEE if player is invincible and close
    if player_invincible and distance_to_player < FLEE_RANGE:
        var flee_direction = (position - player.position).normalized()
        velocity = flee_direction * SPEED * 1.5  # Run away faster
        $ColorRect.color = Color(0.5, 0.5, 0.5)  # Gray when fleeing
    # 🎯 CHASE PLAYER if close enough and not invincible
    elif distance_to_player < CHASE_RANGE and not player_invincible:
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
    
    # Add visual animation based on movement
    time += delta
    if velocity.length() > 10:
        rotation = sin(time * 8) * 0.08
    else:
        rotation = sin(time * 3) * 0.03

func set_player(p: CharacterBody2D) -> void:
    player = p
