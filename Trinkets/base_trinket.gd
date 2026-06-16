extends Resource
class_name Trinket

enum Rarity {
  Common = 0,
  Rare = 1,
  Epic = 2,
  Mythic = 3,
  Legendary = 4,
}

@export var name: String
@export_multiline() var description: String

@export var rarity: Rarity = Rarity.Common

var stack_level: float = 1.0

@warning_ignore_start("unused_parameter")

func equip(player: Player) -> void: pass
func unequip(player: Player) -> void: pass
func move(player: Player) -> void: pass
func attack(player: Player, spell: Spell) -> Spell: return spell
func on_hit(player: Player, enemy: Enemy) -> void: pass
func on_kill(player: Player, enemy: Enemy) -> void: pass
func update(player: Player, delta: float) -> void: pass
func player_hit(player: Player, amt: float) -> void: pass
func player_healed(player: Player, amt: float) -> void: pass

@warning_ignore_restore("unused_parameter")
