@tool

extends Hitbox
class_name DmgHitbox

@export var damage: float = 10

func _ready() -> void:
  super._ready()
  
  hit.connect(deal_dmg)

func deal_dmg(to_what: Hurtbox) -> void:
  var parent: Node = to_what.get_parent()
  var hp_comp: HpComp = Qol.find_hp_comp(parent)
  
  if !hp_comp:
    push_error("Could not find health component on node %s" % parent)
    return
  
  hp_comp.damage(damage)
  
  var num: DmgNumber = DmgNumber.new()
  num.damage = damage
  num.global_position = to_what.global_position
  
  get_tree().get_root().add_child.call_deferred(num)
  
