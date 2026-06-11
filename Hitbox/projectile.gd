@tool

extends CharacterBody2D
class_name Projectile

@export var dir: Vector2 = Vector2(1, 0):
  set(val):
    dir = val.normalized()
    
@export var speed: float = 200
@export var team: Hitbox.Teams = Hitbox.Teams.Player
@export var size: Vector2 = Vector2(20, 20)

@export var lifetime: float = -1.0

@export var damage: float = 10.0
@export var piercing: int = -1
var pierced: int = 0

var hitbox: DmgHitbox

func _ready() -> void:
  hitbox = DmgHitbox.new()
  hitbox.damage = damage
  add_child(hitbox)
  hitbox.hit.connect(func(what: Hurtbox) -> void:
    if piercing >= 0:
      pierced += 1
    if pierced > piercing:
      expire()
    hit_enemy(what)
  )
  
  if lifetime <= 0 :
    return
  
  var timer: Timer = Timer.new()
  timer.autostart = true
  timer.wait_time = lifetime
  timer.timeout.connect(expire)

  add_child(timer)

@warning_ignore("unused_parameter")
func hit_enemy(box: Hurtbox) -> void:
  pass

func expire() -> void:
  queue_free()

func _physics_process(delta: float) -> void:
  if !Engine.is_editor_hint():
    velocity = dir * speed * delta * 60
    move_and_slide()

  hitbox.size = size
  hitbox.team = team
