extends Area2D

# ⚙️ OBSTACLE TYPES - EASY TO ADD MORE!
# Add new obstacle types to this list
enum ObstacleType {
	CACTUS,      # Standard obstacle
	ROCK,        # Smaller, lower obstacle
	PTERODACTYL  # Flying obstacle
}

const SPEED = 200.0

var obstacle_type: ObstacleType

func setup(type: ObstacleType) -> void:
	obstacle_type = type
	
	# 🎨 CUSTOMIZE OBSTACLE APPEARANCE HERE
	match obstacle_type:
		ObstacleType.CACTUS:
			$ColorRect.color = Color(0.8, 0.2, 0.2)  # Red
			$ColorRect.size = Vector2(20, 40)
			$ColorRect.position = Vector2(-10, -20)
			$CollisionShape2D.shape.size = Vector2(20, 40)
		
		ObstacleType.ROCK:
			$ColorRect.color = Color(0.5, 0.5, 0.5)  # Gray
			$ColorRect.size = Vector2(30, 25)
			$ColorRect.position = Vector2(-15, -12.5)
			$CollisionShape2D.shape.size = Vector2(30, 25)
		
		ObstacleType.PTERODACTYL:
			$ColorRect.color = Color(0.6, 0.3, 0.8)  # Purple
			$ColorRect.size = Vector2(35, 20)
			$ColorRect.position = Vector2(-17.5, -10)
			$CollisionShape2D.shape.size = Vector2(35, 20)
			# Fly at different height
			position.y -= 100

func _process(delta: float) -> void:
	position.x -= SPEED * delta
	
	if position.x < -50:
		queue_free()
