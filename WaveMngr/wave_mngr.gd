extends Node
class_name WaveMngr

## The pool to take enemies from
@export var pool: EnemyPool
## The amount of initial points to spend on waves
@export_range(1.0, 100.0, 0.1, "or_greater") var starting_points: float = 10.0
## The amount of points to add after each wave
@export_range(1.0, 10.0, 0.1, "or_greater") var extra_points: float = 2.5
## The time to wait after a wave before spawning the next
@export_range(0.0, 5.0, 0.1, "or_greater", "suffix:s") var grace_period: float = 2.5

var wave_num: int = 0

var waves_to_spawn: int = 0
var enemies_spawned: Array[Enemy] = []

func begin_waves(amt: int = 3) -> void:
  waves_to_spawn = amt
  print("Begun %s waves" % amt)

var wave_cooldown: float

func spawn_wave() -> void:
  var points: float = starting_points + extra_points * wave_num
  wave_num += 1
  waves_to_spawn -= 1
  print("Spawned wave %s" % wave_num)
  
  var player_center: Vector2 = Vector2.ZERO
  var radius: float = 200
  var players: Array[Node] = get_tree().get_nodes_in_group("player")
  
  for i: Player in players:
    player_center += i.global_position / len(players)
  
  for i: Player in players:
    var dist: float = (player_center - i.global_position).length()
    
    if dist + 500 > radius:
      radius = dist + 500
  
  while points > 0.0:
    var available: Array[EnemyInfo] = pool.enemies.filter(func(x: EnemyInfo) -> bool:
      return x.value <= points
    )
    
    if len(available) <= 0.0:
      break
    
    var enemy_info: EnemyInfo = available.pick_random()
    
    points -= enemy_info.value
    
    var enemy: Enemy = enemy_info.enemy.instantiate()
    enemy.global_position = player_center + Vector2(
      randf_range(-1.0, 1.0),
      randf_range(-1.0, 1.0)
    ).normalized() * radius
    
    get_tree().get_root().add_child.call_deferred(enemy)
    
    enemies_spawned.append(enemy)

func _ready() -> void:
  wave_cooldown = grace_period * 2
  begin_waves()

func _process(delta: float) -> void:
  var idx: int = 0
  for i: Enemy in enemies_spawned:
    if !is_instance_valid(i):
      enemies_spawned.pop_at(idx)
      if len(enemies_spawned) <= 0:
        print("Wave %s finished" % wave_num)
        wave_cooldown = grace_period
    idx += 1
  
  if len(enemies_spawned) > 0:
    var hp_comp: HpComp = Qol.find_hp_comp(get_tree().get_root())
    
    if hp_comp:
      hp_comp.damage(1)
  
  if len(enemies_spawned) > 0 or waves_to_spawn <= 0:
    return
  
  wave_cooldown -= delta
  
  if wave_cooldown > 0:
    return
  
  spawn_wave()
