@tool

extends Area2D
class_name Hurtbox

enum Teams {
  Player = 4,
  Enemy = 2,
}

@export var size: Vector2 = Vector2(20, 20)
@export var team: Teams = Teams.Player

var shape: CollisionShape2D

func _ready() -> void:
  collision_layer = 0
  
  shape = CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  add_child(shape)

func _process(_delta: float) -> void:
  collision_mask = team
  (shape.shape as RectangleShape2D).size = size
