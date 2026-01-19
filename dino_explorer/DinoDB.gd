extends Node

# 🦖 DINO DATABASE - Centralized dino information

const DINO_NAMES = [
  "cole", "doux", "kira", "kuro", "loki", "mono",
  "mort", "nico", "olaf", "sena", "tard", "vita"
]

const GENDERS = ["male", "female"]

const ANIMATIONS = ["idle", "move", "avoid", "bite", "dash", "dead", "hurt", "jump", "kick", "scan"]

# Frame counts based on actual sprite sheet dimensions
# All dinos use the same frame counts
const FRAME_COUNTS = {
  "idle": 3,
  "move": 6,
  "avoid": 3,
  "bite": 3,
  "dash": 6,
  "dead": 5,
  "hurt": 4,
  "jump": 4,
  "kick": 3,
  "scan": 6
}

const FRAME_SIZE = Vector2(24, 24)  # Each frame is 24x24 pixels

static func get_dino_path(dino_name: String, gender: String, animation: String) -> String:
  return "res://Assets/download/%s/%s/base/%s.png" % [gender, dino_name, animation]

static func get_frame_count(animation: String) -> int:
  return FRAME_COUNTS.get(animation, 4)

static func is_valid_dino(dino_name: String) -> bool:
  return dino_name in DINO_NAMES

static func is_valid_gender(gender: String) -> bool:
  return gender in GENDERS

static func get_random_dino() -> Dictionary:
  var dino_name = DINO_NAMES[randi() % DINO_NAMES.size()]
  var gender = GENDERS[randi() % GENDERS.size()]
  return {"name": dino_name, "gender": gender}

static func get_animation_speed(animation: String) -> float:
  # FPS for each animation
  var speeds = {
    "idle": 4.0,
    "move": 8.0,
    "avoid": 10.0,
    "bite": 12.0,
    "dash": 12.0,
    "dead": 4.0,
    "hurt": 10.0,
    "jump": 10.0,
    "kick": 12.0,
    "scan": 6.0
  }
  return speeds.get(animation, 8.0)
