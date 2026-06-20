extends Control
class_name Lobby

@onready var player_container: HBoxContainer = %PlayerContainer

var lobby_player_scene: PackedScene = load("uid://boxavn6kx5d4w")

func _ready() -> void:
  Qol.pause_game()
  visible = true

var joycons: Array[int] = []

func handle_joycons() -> void:
  var connected: Array[int] = Input.get_connected_joypads()
  
  for i: int in connected:
    if !i in joycons:
      joycons.append(i)
      print("Joycon %s connected!" % i)
  
  for i: int in joycons.duplicate():
    if !i in connected:
      joycons.erase(i)
      print("Joycon %s disconnected!" % i)

var players_joined: Array[int] = []
var players_ready: Array[bool] = []

func player_join(device: int) -> void:
  players_joined.append(device)
  
  var player: LobbyPlayer = lobby_player_scene.instantiate()
  
  player_container.add_child(player)

func handle_join() -> void:
  for i: int in joycons:
    if !i in players_joined and MultiInput.is_action_pressed("join", i):
      player_join(i)
      print("%s joined the game" % i)

func player_leave(device: int) -> void:
  for i: int in range(len(players_joined)):
    if players_joined[i] == device:
      players_joined.pop_at(i)
      player_container.get_children()[i].queue_free()
      break

func handle_leave() -> void:
  for i: int in joycons:
    if i in players_joined and MultiInput.is_action_pressed("leave", i):
      player_leave(i)
      print("%s left the game" % i)

func _process(_delta: float) -> void:
  handle_joycons()
  handle_join()
  handle_leave()
  
