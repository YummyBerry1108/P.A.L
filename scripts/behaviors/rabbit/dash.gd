extends Behavior

var dash_start_point: Vector2
var dash_finish_point: Vector2
var time_left: float = 0.0
var fire_trail: FireTrail

var projectile_container: Node2D

func _enter_behavior() -> void:
	spawn_fire_trail.rpc()
	
	time_left = actor.dash_duration
	actor.set_collision_mask_value(PhysicsLayers.ENEMY, false)
	actor.set_collision_layer_value(PhysicsLayers.ENEMY, false)

func _physics_update(delta: float) -> void:
	if fire_trail:
		update_fire_trail.rpc()
	actor.velocity = actor.direction * actor.dash_speed * actor.speed_multiplier
	
	time_left -= delta
	if time_left <= 0:
		behavior_tree_component.change_behavior("idle")

func _exit_behavior() -> void:
	dash_finish_point = actor.global_position
	actor.set_collision_mask_value(PhysicsLayers.ENEMY, true)
	actor.set_collision_layer_value(PhysicsLayers.ENEMY, true)
	
@rpc("any_peer", "call_local")
func spawn_fire_trail() -> void:
	dash_start_point = actor.global_position
	fire_trail = actor.fire_trail_scene.instantiate()
	fire_trail.damage = actor.damage/3.0
	add_child(fire_trail, true)
	
	var color: String = "red" if actor.variant_type == actor.VariantType.normal else "blue"
	fire_trail.animation_player.play("fire_flip_"+color)

@rpc("any_peer", "call_local")
func update_fire_trail() -> void:
	fire_trail.update_path(dash_start_point, actor.global_position)
