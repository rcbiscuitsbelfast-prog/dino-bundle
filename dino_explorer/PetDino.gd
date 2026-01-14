extends Area2D

# ⚙️ PET DINO SETTINGS
const WANDER_SPEED = 30.0
var can_pet: bool = true
var wander_direction: Vector2 = Vector2.ZERO
var original_position: Vector2
var time: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal petted

func _ready() -> void:
	$Label.text = "Press SPACE to pet"
	$Label.visible = false
	original_position = position
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	# Animation player ready for future sprite-based animations

func _process(delta: float) -> void:
	# Gentle wandering
	if can_pet:
		position += wander_direction * WANDER_SPEED * delta
		
		# Keep near original position
		if position.distance_to(original_position) > 100:
			wander_direction = (original_position - position).normalized()
		
		# Change direction occasionally
		if randf() < 0.01:
			wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		
		# Add gentle bobbing animation
		time += delta
		rotation = sin(time * 2) * 0.05

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and can_pet:
		$Label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and can_pet and $Label.visible:
		pet()

func pet() -> void:
	can_pet = false
	$ColorRect.color = Color(1.0, 0.84, 0.0)  # Turn gold
	$Label.text = "❤️ Pet!"
	petted.emit()
	
	await get_tree().create_timer(2.0).timeout
	queue_free()
