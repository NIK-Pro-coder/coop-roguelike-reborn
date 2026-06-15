extends Node
class_name StatTracker

enum Stats {
  Health = 0,
  Damage = 1,
  Defence = 2,
  Speed = 3,
}

var stat_changes: Dictionary[String, StatChange] = {}

const handle_chars: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func get_new_handle() -> String:
  var handle: String = ""
  
  for i: int in range(10):
    handle += handle_chars[randi() % len(handle_chars)]
  
  if handle in stat_changes.keys():
    return get_new_handle()
  
  return handle

func get_changes_to_stat(stat: Stats) -> Array[StatChange]:
  var stats: Array[StatChange] = []
  
  for i: String in stat_changes:
    if stat_changes[i].stat == stat:
      stats.append(stat_changes[i])
  
  return stats

func get_flat_changes_to_stat(stat: Stats) -> float:
  var flat: float = 0.0
  
  for i: StatChange in get_changes_to_stat(stat):
    flat += i.flat_change
  
  return flat

func get_mult_changes_to_stat(stat: Stats) -> float:
  var mult: float = 0.0
  
  for i: StatChange in get_changes_to_stat(stat):
    mult += i.mult_change
  
  return mult
  
var health_flat: float = 0.0:
  get(): return get_flat_changes_to_stat(Stats.Health)
var health_mult: float = 1.0
var damage_flat: float = 0.0
var damage_mult: float = 1.0
var defence_flat: float = 0.0
var defence_mult: float = 1.0
var speed_flat: float = 0.0
var speed_mult: float = 1.0

func add_stat_change(stat: Stats, flat: float, mult: float) -> void:
  var handle: String = get_new_handle()
  
  var change: StatChange = StatChange.new()
  change.stat = stat
  change.flat_change = flat
  change.mult_change = mult
  
  stat_changes[handle] = change

func _process(delta: float) -> void:
  print(health_flat)
