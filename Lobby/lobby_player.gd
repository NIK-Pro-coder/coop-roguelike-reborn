@tool

extends Control
class_name LobbyPlayer

@onready var num_text: RichTextLabel = %NumText
@onready var ready_text: RichTextLabel = %ReadyText

@export var player_num: int = 0

@export var ready_state: bool = false

func _process(_delta: float) -> void:
  num_text.text = "Player %s" % player_num
  ready_text.text = "Ready" if ready_state else "Not Ready"
