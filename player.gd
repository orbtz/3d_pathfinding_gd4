extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var timer = $Timer
@onready var hud: TextureProgressBar = $TextureProgressBar

var SPEED = 2.5
var target_reached = true

var pickable_item: RigidBody3D = null

var impulse_vector: Vector3 = Vector3.ZERO
var upper_impulse_value = 0

func _physics_process(delta):
	if hud.value <= 0:
		nav_agent.set_velocity(Vector3.ZERO)
		get_tree().call_group("node_3d", "show_gameover_text")
		return
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	if (target_reached):
		nav_agent.set_velocity(Vector3.ZERO)
	else:
		nav_agent.set_velocity(new_velocity)
		
	if pickable_item:
		pickable_item.global_transform.origin = Vector3(global_transform.origin.x, 3, global_transform.origin.z)

func update_target_location(target_location):
	if target_location == Vector3.ZERO:
		return
	
	if pickable_item:
		var direction = (target_location - global_transform.origin).normalized()
		var force = direction * 2
		pickable_item.apply_impulse(force, Vector3(0, 0, 0))
		
		pickable_item = null
		timer.start(1)
	else:
		nav_agent.target_position = target_location

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if impulse_vector == Vector3.ZERO:
		velocity = velocity.move_toward(safe_velocity, .25)
		move_and_slide()
	else:
		velocity = velocity.move_toward(impulse_vector, .25)
		move_and_slide()
		
		upper_impulse_value = upper_impulse_value - 0.1
		impulse_vector = Vector3(impulse_vector.x, upper_impulse_value, impulse_vector.z)
		if transform.origin.y <= 0.16 && upper_impulse_value < 0:
			impulse_vector = Vector3.ZERO
			transform.origin.y = 0.12

func _on_navigation_agent_3d_target_reached():
	target_reached = true

func _on_navigation_agent_3d_path_changed():
	target_reached = false

func _on_area_3d_area_entered(area):
	if timer.is_stopped():
		get_tree().call_group("node_3d", "remove_body_target")
	
		if area.get_parent().is_in_group("pickable"):
			pickable_item = area.get_parent()
		else:
			area.get_parent().queue_free()

func _on_timer_timeout():
	timer.stop()

func on_enemy_reach(character_body: CharacterBody3D):
	hud.value = hud.value - 1
	
	var velo = character_body.velocity
	upper_impulse_value = 3
	impulse_vector = Vector3(velo.x, upper_impulse_value, velo.z)
