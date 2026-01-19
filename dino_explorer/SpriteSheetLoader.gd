extends RefCounted

# 🎨 SPRITE SHEET LOADER - Extract frames from sprite sheets

# Load a sprite sheet and extract individual frames
# Returns an array of AtlasTexture objects
static func extract_frames(texture: Texture2D, frame_count: int) -> Array:
  if not texture:
    return []
  
  var frames = []
  var sheet_width = texture.get_width()
  var sheet_height = texture.get_height()
  
  var frame_width = sheet_width / frame_count
  var frame_height = sheet_height
  
  for i in range(frame_count):
    var region = Rect2(i * frame_width, 0, frame_width, frame_height)
    var atlas_texture = AtlasTexture.new()
    atlas_texture.atlas = texture
    atlas_texture.region = region
    frames.append(atlas_texture)
  
  return frames

# Load a sprite sheet and create a SpriteFrames resource
static func load_animation(path: String, frame_count: int, animation_speed: float = 8.0) -> SpriteFrames:
  var texture = load(path)
  if not texture:
    return null
  
  var sprite_frames = SpriteFrames.new()
  var frames = extract_frames(texture, frame_count)
  
  for frame in frames:
    sprite_frames.add_frame("default", frame)
  
  sprite_frames.set_animation_speed("default", animation_speed)
  sprite_frames.set_animation_loop("default", true)
  
  return sprite_frames
