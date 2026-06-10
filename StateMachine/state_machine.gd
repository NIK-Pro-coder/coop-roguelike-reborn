extends Node
class_name StateMachine

@export var initial_state: State
@onready var enemy: Enemy = get_parent()

var states: Dictionary[String, State] = {}
var current_state: State

func _ready() -> void:
  for i: Node in get_children():
    if i is State:
      states[i.name.to_lower()] = i
      i.transition_to.connect(transition_to)

  if initial_state:
    current_state = initial_state
    current_state.enter(enemy)

func transition_to(to_state: String) -> void:
  if current_state:
    current_state.exit(enemy)
  
  if !to_state in states:
    push_error("Could not find state: %s" % to_state)
    return
  
  current_state = states[to_state]
  current_state.enter(enemy)

func _physics_process(delta: float) -> void:
  if current_state:
    current_state.update(delta, enemy)
