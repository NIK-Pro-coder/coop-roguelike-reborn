extends Node
class_name State

@warning_ignore("unused_signal")
signal transition_to(to_state: String)

func enter() -> void: pass
func exit() -> void: pass
func update(_delta: float) -> void: pass
