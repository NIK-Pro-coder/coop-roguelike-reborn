extends Camera2D
class_name MainCam

const PADDING: float = 100.0

func get_target_pos(players: Array[Node]) -> Vector2:
  var target_pos: Vector2 = Vector2.ZERO
  
  for i: Player in players:
    target_pos += i.global_position / len(players)
  
  return target_pos

func get_target_zoom(players: Array[Node], target_pos: Vector2) -> Vector2:
  var view_size: Vector2 = get_viewport_rect().size

  var zx: float = 1.0
  var zy: float = 1.0

  for i: Player in players:
    var diff: Vector2 = target_pos - i.global_position
    
    var wx: float = 2.0 * (abs(diff.x) + PADDING) / view_size.x
    zx = min(zx, 1.0 / wx)
    
    var wy: float = 2.0 * (abs(diff.y) + PADDING) / view_size.y
    zy = min(zx, 1.0 / wy)
  
  return min(zx, zy) * Vector2.ONE

var locked: bool = false
var lock_pos: Vector2 = Vector2.ZERO
var lock_zoom: float = 1.0

func lock(target_pos: Vector2, target_zoom: float = 1.0) -> void:
  locked = true
  lock_pos = target_pos
  lock_zoom = target_zoom

func unlock() -> void:
  locked = false

func _process(_delta: float) -> void:
  var players: Array[Node] = get_tree().get_nodes_in_group("player")
  
  var target_pos: Vector2 = get_target_pos(players)
  var target_zoom: Vector2 = get_target_zoom(players, target_pos)
  
  if locked:
    target_pos = lock_pos
    target_zoom = Vector2.ONE * lock_zoom
  
  global_position = global_position * .9 + target_pos * .1
  zoom = zoom * .9 + target_zoom * .1
