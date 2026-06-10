extends Resource
class_name Spell

@export var name: String
@export_multiline() var desc: String

@export_range(0.1, 5.0, 0.01, "or_greater") var cooldown: float = 1.5
@export_range(0.0, 5.0, 0.01, "or_greater") var chargeup: float = 0.0

@warning_ignore("unused_parameter")
func cast(player: Player, target_dir: Vector2) -> void:
  pass
