extends Node3D

@onready var player = $Player
@onready var camera = $Player/Camera3D
@onready var click_check = preload("res://click_rb3d_check.tscn")
@onready var gameover = $GameOver_Label

var current_body_target = null
var current_moveable_body_target = null

func _input(event):
	if Input.is_action_just_pressed("click"):
		current_body_target = null
		current_moveable_body_target = null
		
		var mouse_pos = get_viewport().get_mouse_position()
		var dropPlane  = Plane(Vector3(0, 10, 0), 0)
		var position3D = dropPlane.intersects_ray(camera.project_ray_origin(mouse_pos), camera.project_ray_normal(mouse_pos))
		
		var new_check = click_check.instantiate()
		new_check.transform.origin = position3D

		add_child(new_check)
		
		get_tree().call_group("player", "update_target_location", position3D)

func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	
	if current_moveable_body_target != null:
		get_tree().call_group("player", "update_target_location", current_moveable_body_target.transform.origin)
	elif current_body_target != null:
		get_tree().call_group("player", "update_target_location", current_body_target.transform.origin)

func update_body_target(body):
	current_body_target = body

func update_movable_body_target(body):
	current_moveable_body_target = body

func remove_body_target():
	current_body_target = null
	
func show_gameover_text():
	gameover.visible = true
