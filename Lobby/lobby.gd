extends Control
class_name Lobby

func _ready() -> void:
  Qol.pause_game()

var joycons: Array[int] = []

func _process(_delta: float) -> void:
  var connected: Array[int] = Input.get_connected_joypads()
  
  for i: int in connected:
    if !i in joycons:
      joycons.append(i)
      print("Joycon %s connected!" % i)
  
  for i: int in joycons.duplicate():
    if !i in connected:
      joycons.erase(i)
      print("Joycon %s disconnected!" % i)

  for i: int in joycons:
    if MultiInput.is_action_pressed("join", i):
      print("%s jpined the game" % i)
