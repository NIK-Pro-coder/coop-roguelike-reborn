@tool

extends CharacterBody2D
class_name Projectile

@export var dir: Vector2 = Vector2(1, 0):
  set(val):
    dir = val.normalized()
    
@export var speed: float = 200
@export var team: Hitbox.Teams = Hitbox.Teams.Player
@export var size: Vector2 = Vector2(20, 20)

var hitbox: Hitbox

func _ready() -> void:
  hitbox = Hitbox.new()
  add_child(hitbox)

func _physics_process(delta: float) -> void:
  if !Engine.is_editor_hint():
    velocity = dir * speed * delta * 60
    move_and_slide()

  hitbox.size = size
  hitbox.team = team
