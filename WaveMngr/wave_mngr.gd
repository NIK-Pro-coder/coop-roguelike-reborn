extends Node
class_name WaveMngr

@onready var wave_cd: RichTextLabel = %WaveCD
@onready var wave_text: RichTextLabel = %WaveText

## The pool to take enemies from
@export var pool: EnemyPool
## The amount of initial points to spend on waves
@export_range(1.0, 100.0, 0.1, "or_greater") var starting_points: float = 5.0
## The amount of points to add after each wave
@export_range(1.0, 10.0, 0.1, "or_greater") var extra_points: float = 2.5
## The time to wait after a wave before spawning the next
@export_range(0.0, 5.0, 0.1, "or_greater", "suffix:s") var grace_period: float = 2.5

@export var spawn_around: Vector2 = Vector2.ZERO
@export var spawn_radius: float = 500

var wave_num: int = 0

var waves_to_spawn: int = 0
var enemies_spawned: Array[Enemy] = []

signal waves_started
signal wave_spawned
signal wave_finished
signal all_waves_finished

func begin_waves(amt: int = 3) -> void:
  waves_to_spawn = amt
  
  waves_started.emit()
  print("Begun %s waves" % amt)

var wave_cooldown: float

func spawn_wave() -> void:
  var points: float = starting_points + extra_points * wave_num
  wave_num += 1
  waves_to_spawn -= 1
  
  wave_spawned.emit()
  print("Spawned wave %s (points: %s)" % [wave_num, points])
  
  while points > 0.0:
    var available: Array[EnemyInfo] = pool.enemies.filter(func(x: EnemyInfo) -> bool:
      return x.value <= points
    )
    
    if len(available) <= 0.0:
      break
    
    var enemy_info: EnemyInfo = available.pick_random()
    
    points -= enemy_info.value
    
    var enemy: Enemy = enemy_info.enemy.instantiate()
    enemy.global_position = spawn_around + Vector2(
      randf_range(-1.0, 1.0),
      randf_range(-1.0, 1.0)
    ).normalized() * spawn_radius
    
    get_tree().get_root().add_child.call_deferred(enemy)
    
    enemies_spawned.append(enemy)

func _ready() -> void:
  wave_cooldown = grace_period * 2
  begin_waves(20)

func _process(delta: float) -> void:
  wave_text.text = "- Wave %s -" % (wave_num if len(enemies_spawned) > 0 else wave_num + 1)
  if len(enemies_spawned) <= 0:
    wave_cd.text = "Starting in %.1fs" % wave_cooldown
  else:
    wave_cd.text = "%s enemies left" % len(enemies_spawned)
  
  var idx: int = 0
  for i: Enemy in enemies_spawned:
    if !is_instance_valid(i):
      enemies_spawned.pop_at(idx)
      if len(enemies_spawned) <= 0:
        wave_finished.emit()
        print("Wave %s finished" % wave_num)
        wave_cooldown = grace_period
        if waves_to_spawn == 0:
          all_waves_finished.emit()
          print("Waves finished")
    idx += 1
  
  if len(enemies_spawned) > 0 or waves_to_spawn <= 0:
    return
  
  wave_cooldown -= delta
  
  if wave_cooldown > 0:
    return
  
  spawn_wave()
