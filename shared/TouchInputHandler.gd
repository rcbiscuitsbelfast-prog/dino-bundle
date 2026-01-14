extends Node

# 🎮 TOUCH INPUT HANDLER - SHARED UTILITY
# Handles both keyboard and touch input for all games
# Supports multitouch prevention and input conflict resolution

signal input_detected(input_type: String)
signal touch_detected(position: Vector2)

var last_touch_time: float = 0.0
var touch_cooldown: float = 0.1  # Minimum time between touches to prevent spam

func _ready() -> void:
	print("TouchInputHandler initialized - supporting keyboard and touch")

func _unhandled_input(event: InputEvent) -> void:
	# Handle touch input
	if event is InputEventScreenTouch:
		if event.pressed and _can_process_touch():
			last_touch_time = Time.get_unix_time_from_system()
			touch_detected.emit(event.position)
			input_detected.emit("touch")
	
	# Handle keyboard input (for desktop)
	elif event.is_action_pressed("ui_accept"):
		input_detected.emit("keyboard")
	elif event.is_action_pressed("ui_flap"):
		input_detected.emit("touch_key")

func _can_process_touch() -> bool:
	# Prevent spam touches by requiring minimum cooldown
	var current_time = Time.get_unix_time_from_system()
	return (current_time - last_touch_time) >= touch_cooldown

# Public methods for games to check input
func is_input_pressed() -> bool:
	return Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_flap")

func get_input_direction() -> Vector2:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	return direction.normalized()

# Static convenience methods for easy access
static func check_flap_input() -> bool:
	return Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_flap")

static func check_jump_input() -> bool:
	return Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_flap")

static func get_movement_input() -> Vector2:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	return direction.normalized()