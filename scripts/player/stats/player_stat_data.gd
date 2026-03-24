extends Node
class_name PlayerStatData

@onready var stat_upgrades: StatUpgradeManager = $"../StatUpgrades"

const SPEED: float = 300.0

@export_category("Basic")
@export var damage: float = 10.0
@export var max_hp: float = 100.0 :
	set(value):
		max_hp = value
		hp = value
		owner.max_health_changed.emit(value)

@export var hp: float = 100.0
@export var speed_mutiplier: float = 1.0

func _on_stat_upgrade_received(upgrade_id: String) -> void:
	apply_upgrade.rpc(upgrade_id)

@rpc("any_peer", "call_local", "reliable")
func apply_upgrade(upgrade_id: String) -> void:
		
	var stat_upgrade: StatUpgradeData
	for curr_stat_upgrade: StatUpgradeData in stat_upgrades.get_children():
		if curr_stat_upgrade.upgrade_id == upgrade_id:
			stat_upgrade = curr_stat_upgrade
			break
	
	if stat_upgrade.stat_name in self:
		
		var current_value = self.get(stat_upgrade.stat_name)
		var new_value = current_value
		
		match stat_upgrade.operation:
			SkillUpgrade.OpType.ADD:
				new_value += stat_upgrade.value
			SkillUpgrade.OpType.MULTIPLY:
				new_value *= stat_upgrade.value
			SkillUpgrade.OpType.OVERRIDE:
				new_value = stat_upgrade.value
				
		if typeof(current_value) == TYPE_INT:
			new_value = int(new_value)
			
		self.set(stat_upgrade.stat_name, new_value)
		#if is_multiplayer_authority():
			#print("已將 player %d 的 %s 從 %s 修改為 %s" % [multiplayer.get_unique_id(), stat_upgrade.stat_name, current_value, new_value])
	else:
		push_warning("SkillData 中找不到變數: " + stat_upgrade.stat_name)
