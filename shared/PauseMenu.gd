extends CanvasLayer

# ⏸️ PAUSE MENU SYSTEM
# Shows overlay with pause/resume options
# Works across all games and handles game pausing

signal resume_requested
signal restart_requested
signal settings_requested
signal menu_requested

@onready var pause_overlay: ColorRect = $PauseOverlay
@onready var pause_panel: Panel = $PauseOverlay/PausePanel
@onready var resume_button: Button = $PauseOverlay/PausePanel/VBox/ResumeButton
@onready var restart_button: Button = $PauseOverlay/PausePanel/VBox/RestartButton
@onready var settings_button: Button = $PauseOverlay/PausePanel/VBox/SettingsButton
@onready var menu_button: Button = $PauseOverlay/PausePanel/VBox/MenuButton

var is_paused: bool = false

func _ready() -> void:
    hide_pause_menu()
    connect_signals()

func connect_signals() -> void:
    resume_button.pressed.connect(_on_resume_pressed)
    restart_button.pressed.connect(_on_restart_pressed)
    settings_button.pressed.connect(_on_settings_pressed)
    menu_button.pressed.connect(_on_menu_pressed)

func _unhandled_input(event: InputEvent) -> void:
    # Toggle pause with ESC key
    if event.is_action_pressed("ui_pause"):
        if is_paused:
            resume_game()
        else:
            pause_game()

func pause_game() -> void:
    if not is_paused:
        is_paused = true
        get_tree().paused = true
        show_pause_menu()
        
        # Optionally mute audio when paused
        if SettingsManager.is_music_enabled():
            AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func resume_game() -> void:
    if is_paused:
        is_paused = false
        get_tree().paused = false
        hide_pause_menu()
        
        # Restore audio
        AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func show_pause_menu() -> void:
    pause_overlay.visible = true
    pause_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    pause_panel.visible = true

func hide_pause_menu() -> void:
    pause_overlay.visible = false
    pause_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    pause_panel.visible = false

func _on_resume_pressed() -> void:
    resume_game()
    resume_requested.emit()

func _on_restart_pressed() -> void:
    resume_game()  # Unpause first
    restart_requested.emit()

func _on_settings_pressed() -> void:
    # Open settings without unpausing
    settings_requested.emit()

func _on_menu_pressed() -> void:
    resume_game()  # Unpause first
    menu_requested.emit()