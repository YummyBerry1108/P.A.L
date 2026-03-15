class_name StatUpgradeData 
extends Node

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

const RARITY_COLORS: Dictionary = {
	Rarity.COMMON: Colors.WHITE,
	Rarity.UNCOMMON: Colors.GREEN,
	Rarity.RARE: Colors.BLUE,
	Rarity.EPIC: Colors.PURPLE,
	Rarity.LEGENDARY: Colors.GOLD
}

@export_category("Basic")
@export var upgrade_id: String = "NULL" # use to match actual upgrade effect, will upgrade at player script
@export var title: String = "NULL"
@export var description: String = "NULL"
@export var rarity: Rarity
