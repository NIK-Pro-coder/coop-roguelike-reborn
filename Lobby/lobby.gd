extends Control
class_name Lobby

@onready var player_container: HBoxContainer = %PlayerContainer
@onready var start_in: RichTextLabel = %StartIn

var player_scene: PackedScene = load("uid://cdhqce348kp2a")
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

var players_joined: Array[LobbyPlayerInfo] = []

func player_join(device: int) -> void:
  var info: LobbyPlayerInfo = LobbyPlayerInfo.new()
  
  info.device_id = device
  
  players_joined.append(info)
  
  var player: LobbyPlayer = lobby_player_scene.instantiate()
  
  player_container.add_child(player)

func has_joined(device_id: int) -> bool:
  for i: LobbyPlayerInfo in players_joined:
    if i.device_id == device_id:
      return true
  
  return false

func handle_join() -> void:
  for i: int in joycons:
    if MultiInput.is_action_pressed("join", i) and !has_joined(i):
      player_join(i)
      print("%s joined the game" % i)

func player_leave(device: int) -> void:
  for i: int in range(len(players_joined)):
    if players_joined[i].device_id == device:
      players_joined.pop_at(i)
      player_container.get_children()[i].queue_free()
      break

func handle_leave() -> void:
  for i: int in joycons:
    if has_joined(i) and MultiInput.is_action_pressed("leave", i):
      player_leave(i)
      print("%s left the game" % i)

var toggled: Dictionary[int, bool] = {}

func handle_ready() -> void:
  for i: LobbyPlayerInfo in players_joined:
    if !i.device_id in toggled:
      toggled[i.device_id] = false
    
    if MultiInput.is_action_pressed("toggle_ready", i.device_id):
      if !toggled[i.device_id]:
        i.is_ready = !i.is_ready
        if i.is_ready:
          print("%s is ready" % i.device_id)
        else:
          print("%s is no longer ready" % i.device_id)
        
      toggled[i.device_id] = true
    else:
      toggled[i.device_id] = false

func update_players() -> void:
  for i: int in range(len(players_joined)):
    var info: LobbyPlayerInfo = players_joined[i]
    var f: float = float(i) / float(len(players_joined))
    var col: Color = Color.from_ok_hsl(f, 1.0, .5)
    
    info.player_num = i + 1
    info.color = col
    
    (player_container.get_children()[i] as LobbyPlayer).info = info

var start_time: float = 0.0
var is_starting: bool = false

func _process(delta: float) -> void:
  handle_joycons()
  handle_join()
  handle_leave()
  handle_ready()
  
  update_players()
  
  var can_start: bool = len(players_joined) > 0
  for i: LobbyPlayerInfo in players_joined:
    if !i.is_ready:
      can_start = false
      break
  
  if can_start:
    if !is_starting:
      start_time = 5
      is_starting = true
      
    start_time -= delta
  else:
    is_starting = false
  
  start_in.visible = is_starting
  start_in.text = "Starting in %ss" % int(ceil(start_time))
  
  if start_time <= 0.0 and is_starting:
    for i: LobbyPlayerInfo in players_joined:
      var p: Player = player_scene.instantiate()
      
      p.device = i.device_id
      
      Qol.add_to_tree(p)
    
    Qol.unpause_game()
    queue_free()
    Qol.wave_mngr.begin_waves(20)
