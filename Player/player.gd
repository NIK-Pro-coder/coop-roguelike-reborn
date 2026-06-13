extends CharacterBody2D
class_name Player

@onready var anim: AnimationPlayer = %Anim
@onready var spell_selected_txt: RichTextLabel = %SpellSelectedTxt

#region MulitInput warppers

func get_action_strength(action_name: String) -> float:
  return MultiInput.get_action_strength(action_name, device)

func is_action_pressed(action_name: String) -> bool:
  return MultiInput.is_action_pressed(action_name, device)

func get_action_axis(negative: String, positive: String) -> float:
  return MultiInput.get_action_axis(negative, positive, device)

func get_action_vector(negx: String, posx: String, negy: String, posy: String) -> Vector2:
  return MultiInput.get_action_vector(negx, posx, negy, posy, device)

#endregion

@export var device: int = -1

#region Player stats

var speed: float = 250
var roll_duration: float = .25
var roll_cooldown: float = .15

#endregion

func _ready() -> void:
  var new_sp: Array[Spell] = []
  for i: Spell in spells:
    var s: Spell = i.duplicate()
    
    new_sp.append(s)
    spell_cd[s] = 0.0

  spells.clear()
  spells = new_sp

var last_move_dir: Vector2

var rolling: bool = false

func handle_move(delta: float) -> void:
  if rolling:
    return
  
  last_move_dir = get_action_vector(
    "left", "right",
    "up", "down"
  )
  
  velocity = last_move_dir * speed * delta * 60

var roll_time: float = 0.0
var roll_dir: Vector2 = Vector2.ZERO

func handle_roll(delta: float) -> void:
  roll_time -= delta
  
  if !rolling:
    if roll_time > -roll_cooldown:
      return

    if !last_move_dir:
      return
    
    if is_action_pressed("roll"):
      rolling = true
      roll_dir = last_move_dir
      roll_time = roll_duration
    
    return
  
  if roll_time <= 0.0:
    rolling = false
    return

  velocity = last_move_dir * speed * 2.5 * delta * 60

@export var spells: Array[Spell] = []
var spell_cd: Dictionary[Spell, float] = {}
var sel_spell: int = 0
var cycled: bool = false

func handle_spells(delta: float) -> void:
  for i: Spell in spell_cd:
    spell_cd[i] = max(0.0, spell_cd[i] - delta)
  
  if is_action_pressed("cycle_spell") :
    if !cycled :
      sel_spell = (sel_spell + 1) % len(spells)
      spell_selected_txt.text = "Selected '%s'" % [spells[sel_spell].name]
      anim.stop()
      anim.play("show_select")
    cycled = true
  else :
    cycled = false

  if spell_cd[spells[sel_spell]] > 0.0:
    return
  
  var cast: bool = false
  var dir: Vector2 = Vector2(0, 0)
  
  if device < 0 :
    cast = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
    dir = (get_global_mouse_position() - global_position).normalized()
  else :
    dir = Vector2(
      Input.get_joy_axis(device, JOY_AXIS_RIGHT_X),
      Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y)
    )
    if abs(dir.x) < 0.05:
      dir.x = 0
    if abs(dir.y) < 0.05:
      dir.y = 0
    dir = dir.normalized()
    
    cast = dir.length_squared() > 0

  if cast :
    var s: Spell = spells[sel_spell]
    
    if s.target == Spell.Targets.Enemies:
      var min_dist: float = -1.0
      var new_dir: Vector2 = dir
      var ang: float = dir.angle()
      
      for i: Enemy in get_tree().get_nodes_in_group("enemies"):
        # Prefer enemy closest to the direction vector
        var diff: Vector2 = i.global_position - global_position
        
        var real_diff: Vector2 = diff
        if s.travel_speed > 0.0:
          # Account for enemy velocity (approx.)
          var vel_diff: Vector2 = i.velocity * (diff.length() / s.travel_speed)
          real_diff = (i.global_position + vel_diff) - global_position
          
        var dot: float = dir.dot(real_diff.normalized())

        var norm_diff: Vector2 = real_diff.rotated(-ang)        
        var dist: float = abs(norm_diff.y)
        
        if dot >= .9 and (dist < min_dist or min_dist < 0.0):
          min_dist = dist
          new_dir = real_diff.normalized()
          
      dir = new_dir
    
    s.cast(self, dir)
    spell_cd[s] = s.cooldown
  
func _physics_process(delta: float) -> void:
  handle_move(delta)
  handle_roll(delta)
  handle_spells(delta)
  
  move_and_slide()
