extends Camera2D
class_name MainCam

func _process(delta: float) -> void:
  var players: Array[Node] = get_tree().get_nodes_in_group("player")
  var center: Vector2 = Vector2.ZERO
  
  for i: Player in players:
    center += i.global_position / len(players)
  
  global_position = center
