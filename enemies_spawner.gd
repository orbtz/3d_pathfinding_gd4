extends Node

@onready var enemy = preload("res://enemy.tscn")
@export var spawn_position: Vector3

@export var main_camera: Camera3D
@export var life_hud_y: float

var current_alive_enemy = null

func _process(delta):
	if current_alive_enemy == null:
		var new_enemy = enemy.instantiate()
		
		new_enemy.main_camera = main_camera
		new_enemy.life_bar_y = life_hud_y
		
		new_enemy.transform.origin = spawn_position
		add_child(new_enemy)
		
		current_alive_enemy = new_enemy

func remove_enemy(enemy):
	current_alive_enemy = null
