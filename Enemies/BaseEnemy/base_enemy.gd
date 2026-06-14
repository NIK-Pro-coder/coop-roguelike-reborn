extends CharacterBody2D
class_name Enemy

@onready var nav_agent: NavigationAgent2D = %NavAgent
@onready var debug_state: RichTextLabel = %DebugState
@onready var state_machine: StateMachine = %StateMachine

var target: Player
var retarget: float = .25

var speed: float = 200.0

func grab_target() -> void:
  var dist: float = -1.0
  
  for i: Player in get_tree().get_nodes_in_group("player"):
    var d: float = i.global_position.distance_squared_to(global_position)
    
    if d < dist or dist < 0.0:
      dist = d
      target = i
  
  retarget = .25

var move_position: Vector2

func _ready() -> void:
  move_position = global_position
  
  if !Qol.is_debugging:
    debug_state.queue_free()

func _process(delta: float) -> void:
  retarget -= delta
  if retarget <= 0.0:
    grab_target()
  
  nav_agent.target_position = move_position
  nav_agent.max_speed = speed / 16.0
  
  if Qol.is_debugging:
    var state_name: String = "Skibidi"
    
    for i: String in state_machine.states:
      if state_machine.states[i] == state_machine.current_state:
        state_name = i
        break
        
    debug_state.text = "State: %s\nTarget: %s" % [state_name, str(target.name) if target else "null"]

var move_delta: float = 0.0
var target_vel: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
  move_delta = speed * delta
  var next_pos: Vector2 = nav_agent.get_next_path_position()
  var new_vel: Vector2 = (next_pos - global_position).normalized() * move_delta
  
  nav_agent.set_velocity(new_vel)
  
  velocity = velocity * .9 + target_vel * .1
  move_and_slide()

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
  target_vel = safe_velocity * move_delta * 16.0

func died() -> void:
  queue_free()
