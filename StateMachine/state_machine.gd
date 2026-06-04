extends Node
class_name StateMachine

@export var initial_state: State

var states: Dictionary[String, State] = {}
var current_state: State

func _ready() -> void:
  for i in get_children():
    if i is State:
      states[i.name.to_lower()] = i
      i.transition_to.connect(transition_to)

  if initial_state:
    current_state = initial_state
    current_state.enter()

func transition_to(to_state: String) -> void:
  if current_state:
    current_state.exit()
  
  if !to_state in states:
    push_error("Could not find state: %s" % to_state)
    return
  
  current_state = states[to_state]
  current_state.enter()
