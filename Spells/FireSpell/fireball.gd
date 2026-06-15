@tool

extends Projectile

var explosion_scene: PackedScene = load("uid://bxs8c64gm6v7")

func expire() -> void:
  super.expire()
  
  var exp_part: DmgHitbox = explosion_scene.instantiate()
  exp_part.global_position = global_position
  exp_part.attacker = attacker
  
  if attacker is Player:
    exp_part.damage = attacker.damage * 2.5
  
  get_tree().get_root().add_child.call_deferred(exp_part)
