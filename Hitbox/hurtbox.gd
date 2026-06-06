@tool

extends Area2D
class_name Hurtbox

@export var size: Vector2 = Vector2(20, 20)

var shape: CollisionShape2D

func _ready() -> void:
  shape = CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  add_child(shape)

func _process(_delta: float) -> void:
  (shape.shape as RectangleShape2D).size = size
