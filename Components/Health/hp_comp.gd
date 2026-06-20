@tool

extends Node
class_name HpComp

func _process(_delta: float) -> void:
  if !use_hp_bar or !hp_bar:
    return

  hp_bar.max_value = max_hp
  hp_bar.value = hp_bar.value * .9 + hp * .1
  hp_bar.visible = hp < max_hp

@export var max_hp: float = 100.0:
  set(val):
    var r: float = val / max_hp
    hp *= r
    max_hp = val

var hp: float = 0.0

@export var use_hp_bar: bool = false:
  set(val):
    use_hp_bar = val
    notify_property_list_changed()
var hp_bar: ProgressBar

func _get_property_list() -> Array[Dictionary]:
  var props: Array[Dictionary] = []

  if use_hp_bar :
    props.append({
      "name": "hp_bar",
      "class_name": &"ProgressBar",
      "type": TYPE_OBJECT,
      "hint": PROPERTY_HINT_NODE_TYPE,
      "hint_string": "ProgressBar",
    })
  
  return props

func _ready() -> void:
  hp = max_hp

signal died
signal hurt(amt: float)
signal healed(amt: float)

func kill() -> void:
  damage(max_hp)

func full_heal() -> void:
  damage(-max_hp)

func damage(amt: float) -> void:
  if amt == 0.0:
    return
  
  if (amt > 0.0 and hp <= 0.0) or (amt < 0.0 and hp >= max_hp):
    return
  
  var num: DmgNumber = DmgNumber.new()
  num.damage = amt
  num.global_position = (get_parent() as Node2D).global_position if get_parent() is Node2D else Vector2.ZERO
  
  get_tree().get_root().add_child.call_deferred(num)

  hp -= amt
  
  if amt > 0.0:
    hurt.emit(amt)
  else:
    healed.emit(amt)
  
  if hp <= 0:
    died.emit()

  hp = clamp(hp, 0.0, max_hp)
