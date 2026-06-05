extends Node
class_name State

signal transition_to(to_state: String)

func enter(_enemy: Enemy) -> void: pass
func exit(_enemy: Enemy) -> void: pass
func update(_delta: float, _enemy: Enemy) -> void: pass

func transition(new_state: String) -> void:
  transition_to.emit(new_state)
