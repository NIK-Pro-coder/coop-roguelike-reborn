@tool

extends Area2D
class_name Hurtbox

enum Teams {
  Player = 2,
  Enemy = 4,
}

@export var size: Vector2 = Vector2(20, 20)
@export var team: Teams = Teams.Player
@export var active: bool = true

var shape: CollisionShape2D
var iframes: Dictionary[String, float] = {}

func _ready() -> void:
  collision_mask = 0
  
  shape = CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  add_child(shape)

func _process(delta: float) -> void:
  for i: String in iframes:
    iframes[i] -= delta
    if iframes[i] <= 0.0:
      iframes.erase(i)
  
  collision_layer = team
  (shape.shape as RectangleShape2D).size = size

signal got_hit(from: Hitbox)

func hit(hitbox: Hitbox) -> void:
  if hitbox.iframe_group in iframes:
    return
  
  iframes[hitbox.iframe_group] = hitbox.iframe_length
  got_hit.emit(hitbox)
