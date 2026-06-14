extends Resource
class_name Spell

@export var name: String
@export_multiline() var desc: String

@export_range(0.1, 5.0, 0.01, "or_greater", "suffix:s") var cooldown: float = 1.5
@export_range(0.0, 5.0, 0.01, "or_greater", "suffix:s") var chargeup: float = 0.0

enum Targets {
  Enemies = 0,
  Allies = 1,
  None = 2,
}

@export var target: Targets = Targets.Enemies

@warning_ignore("unused_parameter")
func cast(player: Player, target_dir: Vector2) -> void:
  print("Cast: %s" % target_dir)

func get_aim_assist_points(player: Player) -> Array[Vector2]:
  var points: Array[Vector2] = []
  
  if target == Targets.Enemies:
    for i: Enemy in player.get_tree().get_nodes_in_group("enemies"):
      points.append(i.global_position)
  elif target == Targets.Allies:
    for i: Node2D in player.get_tree().get_nodes_in_group("allies"):
      points.append(i.global_position)
  
  return points
