extends Resource
class_name StatChange

@export var stat: StatTracker.Stats = StatTracker.Stats.Health
@export var flat_change: float = 0
@export_range(-100, 100, 0.01, "or_greater", "or_less", "suffix:%") var mult_change: float = 0.0:
  get():
    return mult_change / 100.0
