extends CanvasLayer

signal start_pressed

@onready var start_button: Button = $Overlay/Panel/VBox/StartButton

func _ready() -> void:	
	process_mode = Node.PROCESS_MODE_ALWAYS
	start_button.pressed.connect(func():
		start_pressed.emit()
	)
