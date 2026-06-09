@tool

extends Area2D
class_name Hitbox

enum Teams {
  Player = 2,
  Enemy = 4,
}

@export var size: Vector2 = Vector2(20, 20)
@export var team: Teams = Teams.Player

var shape: CollisionShape2D

func _ready() -> void:
  collision_mask = 0
  
  shape = CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  add_child(shape)

func _process(_delta: float) -> void:
  collision_layer = team
  (shape.shape as RectangleShape2D).size = size
