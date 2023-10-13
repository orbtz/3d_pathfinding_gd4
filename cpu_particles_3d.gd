extends CPUParticles3D

func _ready():
	restart()

func _on_timer_timeout():
	queue_free()
