extends Node2D

const HATCH_TIME := 120.0
const CRACK_WARNING_TIME := 30.0

var hatch_timer: float = HATCH_TIME
var dino_name: String = ""
var gender: String = ""
var hatched: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal hatching
signal hatched(dino: Node2D)

func _ready() -> void:
    add_to_group("egg")

    if dino_name.is_empty() or gender.is_empty():
        var random := DinoDB.get_random_dino()
        dino_name = random.name
        gender = random.gender

    _load_egg_sprites()
    _play_idle()

func _process(delta: float) -> void:
    if hatched:
        return

    hatch_timer -= delta

    if hatch_timer <= 0.0:
        hatch()
        return

    if hatch_timer <= CRACK_WARNING_TIME and animation_player.current_animation != "crack":
        _play_crack_warning()

func hatch() -> void:
    if hatched:
        return

    hatched = true
    position = Vector2.ZERO
    rotation = 0.0
    scale = Vector2.ONE
    modulate = Color(1, 1, 1, 1)
    animated_sprite.play("hatch")
    animation_player.play("hatch_burst")
    hatching.emit()

    await animation_player.animation_finished

    var dino_scene := preload("res://dino_explorer/PetDino.tscn")
    var new_dino := dino_scene.instantiate() as Node2D
    new_dino.set("dino_name", dino_name)
    new_dino.set("gender", gender)

    var parent := get_parent()
    if parent:
        parent.add_child(new_dino)
        var hatch_pos := global_position
        if parent is Node2D:
            hatch_pos = (parent as Node2D).global_position
        new_dino.global_position = hatch_pos

    hatched.emit(new_dino)
    queue_free()

func set_dino(name: String, gen: String) -> void:
    dino_name = name
    gender = gen

func _play_idle() -> void:
    position = Vector2.ZERO
    rotation = 0.0
    scale = Vector2.ONE
    modulate = Color(1, 1, 1, 1)
    animated_sprite.play("move")
    animation_player.play("idle_bob")

func _play_crack_warning() -> void:
    position = Vector2.ZERO
    rotation = 0.0
    scale = Vector2.ONE
    modulate = Color(1, 1, 1, 1)
    animated_sprite.play("crack")
    animation_player.play("crack")

func _load_egg_sprites() -> void:
    var sprite_frames := SpriteFrames.new()
    for anim in ["move", "crack", "hatch"]:
        sprite_frames.add_animation(anim)
        sprite_frames.set_animation_loop(anim, true)
        sprite_frames.set_animation_speed(anim, 5.0)

        var texture := load(_get_egg_texture_path(anim))
        if texture == null:
            texture = load("res://Assets/download/female/cole/egg/%s.png" % anim)

        if texture != null:
            sprite_frames.add_frame(anim, texture)

    animated_sprite.sprite_frames = sprite_frames

    if sprite_frames.has_animation("move"):
        animated_sprite.play("move")

func _get_egg_texture_path(state: String) -> String:
    return "res://Assets/download/%s/%s/egg/%s.png" % [gender, dino_name, state]
