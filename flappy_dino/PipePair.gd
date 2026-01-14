extends Node2D

# ⚙️ PIPE SETTINGS
# Higher speed = pipes move faster (harder game)
const SPEED = 150.0

# Larger gap = easier to pass through
@export var gap: float = 150.0

@onready var top_pipe: ColorRect = $TopPipe
@onready var bottom_pipe: ColorRect = $BottomPipe

func _ready() -> void:
	# Randomize vertical position of gap
	var gap_center = randf_range(150.0, 450.0)
	top_pipe.position.y = gap_center - gap / 2 - 300
	bottom_pipe.position.y = gap_center + gap / 2

func _process(delta: float) -> void:
	# Move pipes left
	position.x -= SPEED * delta
	
	# Remove pipe when off-screen
	if position.x < -100:
		queue_free()
