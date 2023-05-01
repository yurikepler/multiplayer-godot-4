extends RigidBody3D

@export var speed = 10

const KILL_TIME = 5
var timer = 0

func _physics_process(delta):
	var foward_direction = global_transform.basis.z.normalized()
	var upward_direction = global_transform.basis.y.normalized() * 0.05
	
	global_translate((foward_direction + upward_direction) * speed * delta)
	
	timer += delta
	if timer >= KILL_TIME:
		print("dead")
		queue_free()
