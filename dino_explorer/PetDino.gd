extends Area2D

# ⚙️ PET DINO SETTINGS
const WANDER_SPEED = 30.0
var can_pet: bool = true
var wander_direction: Vector2 = Vector2.ZERO
var original_position: Vector2
var dino_name: String = ""
var gender: String = ""
var current_animation: String = "idle"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal petted

func _ready() -> void:
  # Get random dino type if not set
  if dino_name.is_empty() or gender.is_empty():
    var random = DinoDB.get_random_dino()
    dino_name = random.name
    gender = random.gender

  # Load dino sprites
  load_dino_sprites()

  $Label.text = "Press SPACE to pet"
  $Label.visible = false
  original_position = position
  wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

  # Start idle animation
  play_animation("idle")

func load_dino_sprites() -> void:
  var sprite_frames = SpriteFrames.new()

  # Add all animations to SpriteFrames
  for anim in DinoDB.ANIMATIONS:
    sprite_frames.add_animation(anim)

    var path = DinoDB.get_dino_path(dino_name, gender, anim)
    var texture = load(path)

    if texture:
      var frames = SpriteSheetLoader.extract_frames(texture, DinoDB.get_frame_count(anim))
      for frame in frames:
        sprite_frames.add_frame(anim, frame)
      sprite_frames.set_animation_speed(anim, DinoDB.get_animation_speed(anim))
      sprite_frames.set_animation_loop(anim, true)

  animated_sprite.sprite_frames = sprite_frames

func _process(delta: float) -> void:
  # Gentle wandering
  if can_pet:
    position += wander_direction * WANDER_SPEED * delta
    
    # Keep near original position
    if position.distance_to(original_position) > 100:
      wander_direction = (original_position - position).normalized()
    
    # Change direction occasionally
    if randf() < 0.01:
      wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
    
    # Play move animation when moving, idle when still
    if wander_direction.length() > 0:
      play_animation("move")
    else:
      play_animation("idle")

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
  play_animation("jump")  # Celebration animation
  $Label.text = "❤️ Pet!"
  petted.emit()
  
  await get_tree().create_timer(2.0).timeout
  queue_free()

func play_animation(anim: String) -> void:
  if anim != current_animation:
    if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim):
      animated_sprite.play(anim)
      current_animation = anim

func set_dino(name: String, gen: String) -> void:
  dino_name = name
  gender = gen
