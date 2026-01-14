extends Node2D

# 🐦 FLAPPY DINO - PIPE PAIR WITH SEPARATE COLLISION

const SPEED := 150.0
const PIPE_WIDTH := 40.0
const PIPE_HEIGHT := 250.0

@export var gap: float = 150.0

@onready var top_pipe: Area2D = $TopPipe
@onready var bottom_pipe: Area2D = $BottomPipe
@onready var gap_visual: ColorRect = $GapVisual

signal passed

var _scored := false
var _hit := false
var _bird: Node2D

func _ready() -> void:
	top_pipe.body_entered.connect(_on_pipe_body_entered)
	bottom_pipe.body_entered.connect(_on_pipe_body_entered)

	_bird = get_parent().get_node_or_null("Bird")

	var view_height := get_viewport_rect().size.y
	var margin := 40.0
	var min_center := margin + gap / 2.0
	var max_center := view_height - margin - gap / 2.0
	var gap_center := randf_range(min_center, max_center)

	# Position pipes so the gap between them is clear.
	# Each pipe is a fixed-size segment; the gap is between top_pipe's bottom edge and bottom_pipe's top edge.
	top_pipe.position.y = gap_center - gap / 2.0
	bottom_pipe.position.y = gap_center + gap / 2.0

	gap_visual.size = Vector2(PIPE_WIDTH, gap)
	gap_visual.position = Vector2(-PIPE_WIDTH / 2.0, gap_center - gap / 2.0)

func _process(delta: float) -> void:
	position.x -= SPEED * delta

	if not _scored and _bird and global_position.x < _bird.global_position.x:
		_scored = true
		passed.emit()

	if position.x < -100:
		queue_free()

func _on_pipe_body_entered(body: Node2D) -> void:
	if _hit:
		return
	if _bird and body != _bird:
		return

	_hit = true
	var game := get_parent()
	if game and game.has_method("take_damage"):
		game.take_damage()
	queue_free()
