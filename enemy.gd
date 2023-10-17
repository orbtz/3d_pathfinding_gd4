extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var life_bar : ProgressBar = $LifeBar

@onready var timer = $Timer

@export var main_camera : Camera3D
@export var life_bar_y = 0

var is_active = true

var SPEED = 2.0
var totalDelta = 0

func _process(delta):
	if life_bar.value == 0:
		get_tree().call_group("spawner", "remove_enemy", self)
		queue_free()
	
	var pos2d = main_camera.unproject_position(self.global_transform.origin)
	life_bar.set_position(Vector2(pos2d.x - 45, pos2d.y - 10 -life_bar_y))

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if is_active:
		velocity = velocity.move_toward(safe_velocity, .25)
		move_and_slide()

func check_hit_enemy(body):
	if (self == body):
		life_bar.value = life_bar.value - 1

func _on_navigation_agent_3d_target_reached():
	if is_active:
		get_tree().call_group("player", "on_enemy_reach", self)
		timer.start(1)
		is_active = false

func _on_timer_timeout():
	timer.stop()
	is_active = true
