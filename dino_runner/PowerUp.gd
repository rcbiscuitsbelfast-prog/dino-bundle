extends Area2D

# ⚙️ POWERUP TYPES - ADD YOUR OWN!
enum PowerUpType {
	SHIELD,      # Grants immunity
	EXTRA_LIFE   # Gives extra life
}

const SPEED = 200.0

var powerup_type: PowerUpType

func setup(type: PowerUpType) -> void:
	powerup_type = type
	
	# 🎨 CUSTOMIZE POWERUP APPEARANCE HERE
	match powerup_type:
		PowerUpType.SHIELD:
			$ColorRect.color = Color(0.2, 0.5, 1.0)  # Blue shield
			$Label.text = "S"
		
		PowerUpType.EXTRA_LIFE:
			$ColorRect.color = Color(1.0, 0.84, 0.0)  # Gold heart
			$Label.text = "+1"

func _process(delta: float) -> void:
	position.x -= SPEED * delta
	
	# Rotate for visual effect
	rotation += delta * 2
	
	if position.x < -50:
		queue_free()
