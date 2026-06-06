extends CharacterBody2D
class_name Enemy

var target: Player
var retarget: float = .25

func grab_target() -> void:
  var dist: float = -1.0
 
  for i in get_tree().get_nodes_in_group("player"):
    var d: float = (i as Player).global_position.distance_squared_to(global_position)
    
    if d < dist or dist < 0.0:
      dist = d
      target = i
  
  retarget = .25

func _process(delta: float) -> void:
  retarget -= delta
  if retarget <= 0.0:
    grab_target()

func _physics_process(_delta: float) -> void:
  move_and_slide()
