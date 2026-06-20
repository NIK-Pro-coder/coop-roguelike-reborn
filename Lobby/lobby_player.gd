@tool

extends Control
class_name LobbyPlayer

@onready var num_text: RichTextLabel = %NumText
@onready var ready_text: RichTextLabel = %ReadyText
@onready var panel: Panel = %Panel

@export var info: LobbyPlayerInfo = LobbyPlayerInfo.new()

func _process(_delta: float) -> void:
  num_text.text = "Player %s" % info.player_num
  ready_text.text = "Ready" if info.is_ready else "Not Ready"
