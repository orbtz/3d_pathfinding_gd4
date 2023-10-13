extends RigidBody3D

@onready var particles = preload("res://cpu_particles_3d.tscn")

@export var speed_to_delete: float;
var item_speed = 0;

func _physics_process(delta):
	item_speed = linear_velocity

func _on_area_3d_body_entered(body):
	if linear_velocity.round() != Vector3.ZERO:
		var new_particles = particles.instantiate()
		new_particles.transform.origin = Vector3(body.transform.origin.x, body.transform.origin.y + 2, body.transform.origin.z)

		get_parent().add_child(new_particles)
		
#		body.get_parent().queue_free()
