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
var speed_multiplier: float = 1.0

@onready var sprite: Sprite2D = $Rock2

func set_speed_multiplier(multiplier: float) -> void:
	speed_multiplier = multiplier

func setup(type: ObstacleType) -> void:
	obstacle_type = type
	
	# 🎨 CUSTOMIZE OBSTACLE APPEARANCE HERE
	if sprite:
		match obstacle_type:
			ObstacleType.CACTUS:
				# Use Rock2 for cactus (or load different sprite later)
				sprite.visible = true
				sprite.scale = Vector2(2.5, 2.5)
				sprite.position = Vector2(0, 9)
				$CollisionShape2D.shape.size = Vector2(50, 50)
				$CollisionShape2D.position = Vector2(0, 9)
			
			ObstacleType.ROCK:
				# Use Rock2 for rock
				sprite.visible = true
				sprite.scale = Vector2(2.125, 2)
				sprite.position = Vector2(0, 9)
				$CollisionShape2D.shape.size = Vector2(50, 50)
				$CollisionShape2D.position = Vector2(0, 9)
			
			ObstacleType.PTERODACTYL:
				# Use Rock2 for pterodactyl (or load different sprite later)
				sprite.visible = true
				sprite.scale = Vector2(2.0, 1.5)
				sprite.position = Vector2(0, -91)  # Fly higher
				$CollisionShape2D.shape.size = Vector2(40, 30)
				$CollisionShape2D.position = Vector2(0, -91)
				# Fly at different height
				position.y -= 100

func _process(delta: float) -> void:
	position.x -= SPEED * speed_multiplier * delta
	
	if position.x < -50:
		queue_free()
