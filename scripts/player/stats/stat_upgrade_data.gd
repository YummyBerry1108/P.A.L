class_name StatUpgradeData 
extends Node

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }
enum OpType { ADD, MULTIPLY, OVERRIDE } 

const RARITY_COLORS: Dictionary = {
	Rarity.COMMON: Colors.WHITE,
	Rarity.UNCOMMON: Colors.GREEN,
	Rarity.RARE: Colors.BLUE,
	Rarity.EPIC: Colors.PURPLE,
	Rarity.LEGENDARY: Colors.GOLD
}

@export_category("Basic")
@export var upgrade_id: String = "NULL" # use to match actual upgrade effect, will upgrade at player script
@export var stat_name: String = ""  
@export var operation: OpType = OpType.ADD
@export var value: float = 0.0
@export_category("UI")
@export var title: String = "NULL"
@export var description: String = "NULL"
@export var rarity: Rarity
@export var upgrade_icon: Texture2D
@export var card_image: Texture2D
