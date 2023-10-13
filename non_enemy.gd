extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var points: Array[Vector3] = []
var next_point_target_index = 0

var SPEED = 3.0

func _ready():
	nav_agent.target_position = points[next_point_target_index]

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()


func _on_navigation_agent_3d_target_reached():
	if (next_point_target_index + 1) >= points.size():
		next_point_target_index = 0
	else:
		next_point_target_index = next_point_target_index + 1
		
	nav_agent.target_position = points[next_point_target_index]
