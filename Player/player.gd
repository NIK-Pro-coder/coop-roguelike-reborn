extends CharacterBody2D
class_name Player

@onready var stat_tracker: StatTracker = %StatTracker
@onready var anim: AnimationPlayer = %Anim
@onready var spell_selected_txt: RichTextLabel = %SpellSelectedTxt
@onready var hp_comp: HpComp = %HpComp
@onready var hurtbox: Hurtbox = %Hurtbox

@export var device: int = -1

func _ready() -> void:
  var new_sp: Array[Spell] = []
  for i: Spell in spells:
    var s: Spell = i.duplicate()
    
    new_sp.append(s)
    spell_cd[s] = 0.0

  spells.clear()
  spells = new_sp

#region Trinket

@export var trinkets: Array[Trinket] = []

func equip_trinket(trinket: Trinket) -> void:
  for i: Trinket in trinkets:
    if i.name == trinket.name:
      i.unequip(self)
      i.stack_level += trinket.stack_level
      i.equip(self)
      
      return
  
  var t: Trinket = trinket.duplicate()
  
  trinkets.append(t)
  
  t.equip(self)

func unequip_trinket(trinket: Trinket) -> void:
  for i: Trinket in trinkets:
    if i.name == trinket.name:
      i.unequip(self)
      i.stack_level -= trinket.stack_level
      
      if i.stack_level > 0.0:
        i.equip(self)
      else:
        trinkets.erase(i)
      
      return

func trinket_move() -> void:
  if is_ghost: return
  
  for i: Trinket in trinkets:
    i.move(self)

func trinket_attack(s: Spell) -> Spell:
  if is_ghost: return
  
  var new_s: Spell = s
  
  for i: Trinket in trinkets:
    new_s = i.attack(self, new_s)
  
  return new_s

func trinket_player_hit(amt: float) -> void:
  if is_ghost: return
  
  for i: Trinket in trinkets:
    i.player_hit(self, amt)

func trinket_player_healed(amt: float) -> void:
  if is_ghost: return
  
  for i: Trinket in trinkets:
    i.player_healed(self, amt)

func trinket_update(delta: float) -> void:
  if is_ghost: return
  
  for i: Trinket in trinkets:
    i.update(self, delta)

func trinket_on_hit(enemy: Enemy) -> void:
  if is_ghost: return
  
  for i: Trinket in trinkets:
    i.on_hit(self, enemy)

func trinket_on_kill(enemy: Enemy) -> void:
  if is_ghost: return
  
  for i: Trinket in trinkets:
    i.on_kill(self, enemy)

#endregion

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

#region Player stats

var speed: float = 250:
  get(): return speed * stat_tracker.speed_mult + stat_tracker.speed_flat
var health: float = 100:
  get(): return health * stat_tracker.health_mult + stat_tracker.health_flat
var damage: float = 10:
  get(): return damage * stat_tracker.damage_mult + stat_tracker.damage_flat
var defence: float = 0:
  get(): return defence * stat_tracker.defence_mult + stat_tracker.defence_flat

var roll_duration: float = .25
var roll_cooldown: float = .15

#endregion

#region Movement

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
  
  hurtbox.active = roll_time <= roll_duration * .5
  
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

#endregion

#region Spellcasting

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
    
  var s: Spell = spells[sel_spell]
  var aim_assist_points: Array[Vector2] = s.get_aim_assist_points(self)
      
  if spell_cd[s] > 0.0:
    return
  
  var cast: bool = false
  var dir: Vector2 = Vector2(0, 0)
  var tolerance: float = 1.0
  
  if device < 0 :
    cast = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
    dir = (get_global_mouse_position() - global_position).normalized()
  else :
    tolerance = .8
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
    var min_dist: float = -1.0
    var new_dir: Vector2 = dir
    var ang: float = dir.angle()
    
    for i: Vector2 in aim_assist_points:
      # Prefer enemy closest to the direction vector
      var diff: Vector2 = i - global_position
        
      var dot: float = dir.dot(diff.normalized())

      var norm_diff: Vector2 = diff.rotated(-ang)        
      var dist: float = abs(norm_diff.y)
      
      # You have to aim with about +- 10° accuracy to have aim-assist
      if dot >= tolerance and (dist < min_dist or min_dist < 0.0):
        min_dist = dist
        new_dir = diff.normalized()
        
    dir = new_dir
    
    trinket_attack(s).cast(self, dir)
    spell_cd[s] = s.cooldown

#endregion

func _physics_process(delta: float) -> void:
  trinket_update(delta)
  
  handle_move(delta)
  if !is_ghost:
    handle_roll(delta)
    handle_spells(delta)
  
  var last_pos: Vector2 = global_position
  move_and_slide()
  if last_pos != global_position:
    trinket_move()
  
  hp_comp.max_hp = health

func _process(_delta: float) -> void:
  modulate.a = modulate.a * .9 + (.05 if is_ghost else .1)

var is_ghost: bool = false

func _on_hp_comp_died() -> void:
  is_ghost = true
  remove_from_group("allies")
  hp_comp.full_heal()

func _on_hp_comp_hurt(amt: float) -> void:
  trinket_player_hit(amt)

func _on_hp_comp_healed(amt: float) -> void:
  trinket_player_healed(amt)
