@tool

extends Control
class_name LobbyPlayer

@onready var num_text: RichTextLabel = %NumText
@onready var ready_text: RichTextLabel = %ReadyText
@onready var panel: Panel = %Panel

var panel_style: StyleBoxFlat

func _ready() -> void:
  panel_style = panel.get_theme_stylebox("panel").duplicate()

@export var info: LobbyPlayerInfo = LobbyPlayerInfo.new()

func _process(_delta: float) -> void:
  num_text.text = "Player %s" % info.player_num
  ready_text.text = "Ready" if info.is_ready else "Not Ready"

  if info.color != panel_style.border_color:
    panel_style.border_color = info.color
    panel.add_theme_stylebox_override("panel", panel_style)
