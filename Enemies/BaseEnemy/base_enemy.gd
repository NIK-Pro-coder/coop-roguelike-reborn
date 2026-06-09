extends CharacterBody2D
class_name Enemy

@onready var nav_agent: NavigationAgent2D = %NavAgent

var target: Player
var retarget: float = .25

var speed: float = 250.0

func grab_target() -> void:
  var dist: float = -1.0
 
  for i in get_tree().get_nodes_in_group("player"):
    var d: float = (i as Player).global_position.distance_squared_to(global_position)
    
    if d < dist or dist < 0.0:
      dist = d
      target = i
  
  retarget = .25

var move_position: Vector2

func _ready() -> void:
  move_position = global_position

func _process(delta: float) -> void:
  retarget -= delta
  if retarget <= 0.0:
    grab_target()
  
  nav_agent.target_position = move_position

var move_delta: float = 0.0

func _physics_process(delta: float) -> void:
  move_delta = speed * delta * 4
  var next_pos: Vector2 = nav_agent.get_next_path_position()
  var new_vel: Vector2 = (next_pos - global_position).normalized() * move_delta
  
  nav_agent.set_velocity(new_vel)

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
  velocity = safe_velocity * move_delta
  move_and_slide()
