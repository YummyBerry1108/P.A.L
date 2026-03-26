class_name EnemyDespawn extends Node

signal _change_despawn_timer(enemy_rid: int, off_screen: bool)

var enemies_is_on_player_screen: Dictionary = {}
var player_id_to_index: Dictionary = {}
var all_on_screen: int = 0
var player_cnt: int = 0

func bit_on(num, bit) -> int:
	return num | (1 << bit)
	
func bit_off(num, bit) -> int:
	#print("bit before : ", num >> 1 & 1, num >> 0 & 1)
	#var nn = (num | (1 << bit)) ^ (1 << bit)
	#print("bit after : ", nn >> 1 & 1, nn >> 0 & 1)
	return (num | (1 << bit)) ^ (1 << bit)

@rpc("any_peer", "call_local")
func add_player(player_id: int):
	if not multiplayer.is_server():
		return
	
	var player_id_str = str(player_id)
	
	player_id_to_index[player_id_str] = player_cnt
	all_on_screen = bit_on(all_on_screen, player_cnt)
	player_cnt += 1
	
	#print("Added : ", player_id_str)

func remove_player_rpc(player_id: int):
	#print("hello, i was this : ", player_id)
	remove_player.rpc(player_id)

@rpc("any_peer", "call_local")
func remove_player(player_id: int):
	if not multiplayer.is_server():
		return
	var player_id_str = str(player_id)
	
	#print("Removed : ", player_id_str)
	all_on_screen = bit_off(all_on_screen, player_id_to_index[player_id_str])

func update_enemy_onscreen_rpc(player_id: int, enemy_rid: RID, on_screen: bool):
	update_enemy_onscreen.rpc(player_id, enemy_rid, on_screen)

@rpc("any_peer", "call_local")
func update_enemy_onscreen(player_id: int, enemy_rid: RID, on_screen: bool):
	if not multiplayer.is_server():
		return
	#print(player_id_to_index)
	
	var player_id_str = str(player_id)
	var enemy_id = str(enemy_rid)
	#print("enemy id : ", enemy_id)
	
	if not enemies_is_on_player_screen.has(enemy_id):
		#print("RESET")
		enemies_is_on_player_screen[enemy_id] = all_on_screen
	
	if on_screen:
		enemies_is_on_player_screen[enemy_id] = bit_on(enemies_is_on_player_screen[enemy_id], player_id_to_index[player_id_str])
	else:
		enemies_is_on_player_screen[enemy_id] = bit_off(enemies_is_on_player_screen[enemy_id], player_id_to_index[player_id_str])
	
	#print("on_screen, the val => ", on_screen, ", ", enemies_is_on_player_screen[enemy_id])
	#print("pid, pid to index : ", player_id, ", ", player_id_to_index[player_id_str])
	_change_despawn_timer.emit(enemy_rid, enemies_is_on_player_screen[enemy_id] & all_on_screen == 0)
	
