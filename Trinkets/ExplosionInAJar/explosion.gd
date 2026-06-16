extends VideoStreamPlayer

@onready var explosion: DmgHitbox = %Explosion

var attacker: Player = null

func _ready() -> void:
  explosion.attacker = attacker
  explosion.damage = attacker.damage * 2.5
  
  global_position -= size * scale / 2.0
  stream_position = 1

func _on_finished() -> void:
  queue_free()
