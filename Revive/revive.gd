extends Node2D
class_name Revive

@onready var chain: Line2D = %Chain
@onready var circle: Sprite2D = %Circle

@export var target_player: Player

func _ready() -> void:
  circle.material = circle.material.duplicate()

var max_dist: float = 240.0
var revive_progress: float = 0.0

func _process(delta: float) -> void:
  chain.points = [Vector2.ZERO, target_player.global_position - global_position]
  
  var diff: Vector2 = (target_player.global_position - global_position)
  var dist: float = diff.length_squared()
  var a_dist: float = max_dist - (max_dist / 2.0 * revive_progress)
  
  chain.default_color = Color.RED
  if dist <= a_dist * a_dist:
    revive_progress += delta / 10.0
    chain.default_color = Color.WHITE
  chain.default_color.a = .5
  
  circle.scale = Vector2.ONE * (4.0 - revive_progress * 2.0)
  
  revive_progress = clamp(revive_progress, 0.0, 1.0)
  
  (circle.material as ShaderMaterial).set_shader_parameter("progress", revive_progress)

  if revive_progress >= 1.0:
    target_player.add_to_group("allies")
    target_player.is_ghost = false
  
    queue_free()
