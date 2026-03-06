class_name StatUpgradeData 
extends Node

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

const RARITY_COLORS: Dictionary = {
	Rarity.COMMON: Colors.WHITE,   # 白
	Rarity.UNCOMMON: Colors.GREEN, # 綠
	Rarity.RARE: Colors.BLUE,      # 藍
	Rarity.EPIC: Colors.PURPLE,    # 紫
	Rarity.LEGENDARY: Colors.GOLD  # 金
}

@export_category("Basic")
@export var upgrade_id: String = "NULL" # use to match actual upgrade effect, will upgrade at player script
@export var title: String = "NULL"
@export var description: String = "NULL"
@export var rarity: Rarity
