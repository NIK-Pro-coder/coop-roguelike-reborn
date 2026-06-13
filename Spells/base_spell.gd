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

@export_range(0.0, 100.0, 0.01, "or_greater", "suffix:px/s") var travel_speed: float = 0.0

@warning_ignore("unused_parameter")
func cast(player: Player, target_dir: Vector2) -> void:
  print("Cast: %s" % target_dir)
