extends Area2D

# ⚙️ PET DINO SETTINGS
var can_pet: bool = true

signal petted

func _ready() -> void:
	$Label.text = "Press SPACE to pet"
	$Label.visible = false

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
