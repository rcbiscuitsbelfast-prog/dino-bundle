extends CharacterBody2D

# ⚙️ ENEMY AI SETTINGS
const SPEED = 100.0  # Slower than before
const CHASE_RANGE = 300.0  # Aggro range
const ATTACK_RANGE = 40.0  # Attack distance
const FLEE_RANGE = 150.0  # Back off when player invincible

var player: CharacterBody2D = null
var patrol_direction: Vector2 = Vector2.RIGHT
var game_node: Node = null
var dino_name: String = ""
var gender: String = ""
var current_animation: String = "idle"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
  # Get random dino type if not set
  if dino_name.is_empty() or gender.is_empty():
    var random = DinoDB.get_random_dino()
    dino_name = random.name
    gender = random.gender

  # Load dino sprites
  load_dino_sprites()

  # Random initial patrol direction
  patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

  # Get reference to game node
  await get_tree().process_frame
  game_node = get_tree().current_scene

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

func _physics_process(delta: float) -> void:
  if player == null:
    return
  
  var distance_to_player = position.distance_to(player.position)
  var player_invincible = false
  
  # Check if player is invincible
  if game_node and game_node.has_method("get") and "is_invincible" in game_node:
    player_invincible = game_node.is_invincible
  
  # 🏃 FLEE if player is invincible and close
  if player_invincible and distance_to_player < FLEE_RANGE:
    var flee_direction = (position - player.position).normalized()
    velocity = flee_direction * SPEED * 1.5  # Run away faster
    play_animation("avoid")
  # 🎯 CHASE PLAYER if close enough and not invincible
  elif distance_to_player < CHASE_RANGE and not player_invincible:
    var direction = (player.position - position).normalized()
    velocity = direction * SPEED
    
    if distance_to_player < ATTACK_RANGE:
      play_animation("bite")
    else:
      play_animation("move")
  else:
    # 🚶 PATROL when player is far
    velocity = patrol_direction * (SPEED * 0.5)
    play_animation("move")
    
    # Change direction randomly
    if randf() < 0.01:
      patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
  
  move_and_slide()

func play_animation(anim: String) -> void:
  if anim != current_animation:
    if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation(anim):
      animated_sprite.play(anim)
      current_animation = anim

func set_player(p: CharacterBody2D) -> void:
  player = p

func set_dino(name: String, gen: String) -> void:
  dino_name = name
  gender = gen
