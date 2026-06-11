extends Node
class_name HpComp

@export var max_hp: float = 100.0:
  set(val):
    var r: float = val / max_hp
    hp *= r
    max_hp = val

var hp: float = 0.0

func _ready() -> void:
  hp = max_hp

signal died
signal hurt(amt: float)

func damage(amt: float) -> void:
  if amt == 0.0:
    return

  hp += amt
  
  if amt > 0.0:
    hurt.emit(amt)
  
  if hp < 0:
    died.emit()

  hp = clamp(hp, 0.0, max_hp)
