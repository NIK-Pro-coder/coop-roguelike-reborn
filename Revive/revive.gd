extends Node2D
class_name Revive

@onready var circle: Sprite2D = %Circle

@export var target_player: Player

func _ready() -> void:
  circle.material = circle.material.duplicate()

var max_dist: float = 240.0
var revive_progress: float = 0.0

# TODO: Make revive fasteer when more players are in the area

func _process(delta: float) -> void:
  if len(Qol.get_alive_players()) == 0:
    queue_free()
  
  var diff: Vector2 = (target_player.global_position - global_position)
  var dist: float = diff.length_squared()
  var a_dist: float = max_dist - (max_dist / 2.0 * revive_progress)
  
  var can_continue: bool = dist <= a_dist * a_dist
  
  if can_continue:
    revive_progress += delta / 10.0
  
  circle.scale = Vector2.ONE * (4.0 - revive_progress * 2.0)
  
  revive_progress = clamp(revive_progress, 0.0, 1.0)
  
  (circle.material as ShaderMaterial).set_shader_parameter("progress", revive_progress)
  (circle.material as ShaderMaterial).set_shader_parameter("can_continue", can_continue)

  if revive_progress >= 1.0:
    target_player.revive()
  
    queue_free()
