extends Node
class_name PartyMngr

@onready var lives_num: RichTextLabel = %LivesNum

var revive_scene: PackedScene = preload("uid://c32emlkkofwxg")

@export var lives_per_player: int = 3

var lives: int = 0
var added_lives: bool = false

func _process(_delta: float) -> void:
  if !added_lives:
    lives_num.visible = len(get_tree().get_nodes_in_group("player")) > 1
    
    lives = lives_per_player * (len(get_tree().get_nodes_in_group("player")) - 1)
    
    if lives > 0:
      added_lives = true
      print("Party lives: %s" % lives)
  
  lives_num.text = "Lives: %s" % lives

func request_revive(player: Player) -> void:
  var alive_players: Array[Player] = Qol.get_alive_players()
  
  if len(alive_players) == 0 or lives <= 0:
    print("Cannot revive")
    return
  
  lives -= 1
  print("Will revive, lives left: %s" % lives)
  
  var revive: Revive = revive_scene.instantiate()
  
  revive.global_position = player.global_position
  revive.target_player = player
  
  Qol.add_to_tree(revive)
