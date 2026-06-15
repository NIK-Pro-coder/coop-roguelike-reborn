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
  var mult: float = 1.0
  
  for i: StatChange in get_changes_to_stat(stat):
    mult += i.mult_change
  
  return mult
  
var health_flat: float = 0.0:
  get(): return get_flat_changes_to_stat(Stats.Health)
var health_mult: float = 1.0:
  get(): return get_mult_changes_to_stat(Stats.Health)
var damage_flat: float = 0.0:
  get(): return get_flat_changes_to_stat(Stats.Damage)
var damage_mult: float = 1.0:
  get(): return get_mult_changes_to_stat(Stats.Damage)
var defence_flat: float = 0.0:
  get(): return get_flat_changes_to_stat(Stats.Defence)
var defence_mult: float = 1.0:
  get(): return get_mult_changes_to_stat(Stats.Defence)
var speed_flat: float = 0.0:
  get(): return get_flat_changes_to_stat(Stats.Speed)
var speed_mult: float = 1.0:
  get(): return get_mult_changes_to_stat(Stats.Speed)

func add_stat_change(stat: Stats, flat: float, mult: float, duration: float) -> String:
  var handle: String = get_new_handle()
  
  var change: StatChange = StatChange.new()
  change.stat = stat
  change.flat_change = flat
  change.mult_change = mult
  
  stat_changes[handle] = change
  
  if duration > 0.0:
    Qol.create_timer(duration, cancel_stat_change.bind(handle))
  
  return handle

func cancel_stat_change(handle: String) -> void:
  if !handle in stat_changes:
    return
  
  stat_changes.erase(handle)

func add_hp_change(flat: float, mult: float, duration: float = -1) -> String: return add_stat_change(Stats.Health, flat, mult, duration)
func add_flat_hp_change(change: float, duration: float = -1) -> String: return add_hp_change(change, 0.0, duration)
func add_mult_hp_change(change: float, duration: float = -1) -> String: return add_hp_change(0.0, change, duration)

func add_dmg_change(flat: float, mult: float, duration: float = -1) -> String: return add_stat_change(Stats.Damage, flat, mult, duration)
func add_flat_dmg_change(change: float, duration: float = -1) -> String: return add_dmg_change(change, 0.0, duration)
func add_mult_dmg_change(change: float, duration: float = -1) -> String: return add_dmg_change(0.0, change, duration)

func add_def_change(flat: float, mult: float, duration: float = -1) -> String: return add_stat_change(Stats.Defence, flat, mult, duration)
func add_flat_def_change(change: float, duration: float = -1) -> String: return add_def_change(change, 0.0, duration)
func add_mult_def_change(change: float, duration: float = -1) -> String: return add_def_change(0.0, change, duration)

func add_spd_change(flat: float, mult: float, duration: float = -1) -> String: return add_stat_change(Stats.Speed, flat, mult, duration)
func add_flat_spd_change(change: float, duration: float = -1) -> String: return add_spd_change(change, 0.0, duration)
func add_mult_spd_change(change: float, duration: float = -1) -> String: return add_spd_change(0.0, change, duration)
