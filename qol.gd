extends Node

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS

var want_to_debug: bool = true
var is_debugging: bool = want_to_debug and OS.is_debug_build()

var main_theme: Theme = load("uid://dlrj8hj0dxq8r")

func find_with_criteria(from: Node, criteria: Callable) -> Node:
  if criteria.call(from):
    return from
  
  for i: Node in from.get_children():
    var r: Node = find_with_criteria(i, criteria)
    
    if r:
      return r
  
  return null

func find_hp_comp(from: Node) -> Node:
  return find_with_criteria(from, func(x: Node) -> bool:
    return x is HpComp
  )

func create_timer(time: float, timeout: Callable) -> Timer:
  var t: Timer = Timer.new()
  t.autostart = true
  t.wait_time = time
  
  get_tree().get_root().add_child.call_deferred(t)
  
  t.timeout.connect(func() -> void:
    t.queue_free()
    timeout.call()
  )
  
  return t

func add_to_tree(node: Node) -> void:
  get_tree().get_root().add_child.call_deferred(node)

var cam: MainCam = null
var wave_mngr: WaveMngr = null

func _process(_delta: float) -> void:
  if !cam:
    cam = find_with_criteria(get_tree().get_root(), func(x: Node) -> bool:
      return x is MainCam
    )
  if !wave_mngr:
    wave_mngr = find_with_criteria(get_tree().get_root(), func(x: Node) -> bool:
      return x is WaveMngr
    )

func pause_game() -> void:
  get_tree().paused = true
  
func unpause_game() -> void:
  get_tree().paused = false
