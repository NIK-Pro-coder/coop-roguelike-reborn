extends Node
class_name PartyMngr

@export var lives_per_player: int = 3

var lives: int = 0
var added_lives: bool = false

func _process(_delta: float) -> void:
  if !added_lives:
    lives = lives_per_player * len(get_tree().get_nodes_in_group("player"))
    
    if lives > 0:
      added_lives = true
      print(lives)
