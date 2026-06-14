extends Node

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
