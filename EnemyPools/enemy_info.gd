extends Resource
class_name EnemyInfo

@export var enemy: PackedScene
@export_range(1.0, 100.0, 0.1, "or_greater") var value: float = 1.0
