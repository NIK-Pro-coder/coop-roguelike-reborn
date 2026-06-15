extends State
class_name AttackState

@export var max_dist: float = 150.0

var attack_cooldown: float = 1.5

func update(delta: float, enemy: Enemy) -> void:
  enemy.move_position = enemy.global_position
    
  var diff: Vector2 = (enemy.global_position - enemy.target.global_position)
  
  if diff.length_squared() > max_dist * max_dist:
    transition("follow")
    return
  
  attack_cooldown -= delta
  if attack_cooldown <= 0.0:
    var proj: Projectile = Projectile.new()
    proj.global_position = enemy.global_position
    proj.dir = -diff.normalized()
    proj.speed = 100
    proj.damage = enemy.damage
    proj.team = Hitbox.Teams.Enemy
    proj.attacker = enemy
    
    Qol.add_to_tree(proj)
    
    attack_cooldown = 1.5
