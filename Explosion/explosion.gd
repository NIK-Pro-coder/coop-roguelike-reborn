extends VideoStreamPlayer

func _ready() -> void:
  global_position -= size * scale / 2.0
  stream_position = 1

func _on_finished() -> void:
  queue_free()
