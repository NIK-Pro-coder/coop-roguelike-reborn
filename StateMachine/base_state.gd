extends Node
class_name State

@warning_ignore("unused_signal")
signal transition_to(to_state: String)

func enter(_enemy: Enemy) -> void: pass
func exit(_enemy: Enemy) -> void: pass
func update(_delta: float, _enemy: Enemy) -> void: pass
