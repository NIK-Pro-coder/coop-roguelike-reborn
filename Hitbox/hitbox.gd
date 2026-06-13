@tool

extends Area2D
class_name Hitbox

enum Teams {
  Player = 4,
  Enemy = 2,
}

@export var size: Vector2 = Vector2(20, 20)
@export var team: Teams = Teams.Player
@export var iframe_group: String = ""
@export var iframe_length: float = .5

var shape: CollisionShape2D

func _ready() -> void:
  if iframe_group == "":
    iframe_group = str(get_instance_id())
  
  collision_layer = 0
  
  shape = CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  add_child(shape)

signal hit(what: Hurtbox)

func _process(_delta: float) -> void:
  collision_mask = team
  (shape.shape as RectangleShape2D).size = size
  
  for i: Hurtbox in get_overlapping_areas():
    if not iframe_group in i.iframes or i.iframes[iframe_group] <= 0 :
      i.hit(self)
      hit.emit(i)
