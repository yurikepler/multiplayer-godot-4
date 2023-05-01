extends Node3D

@export var bullet : PackedScene
@export var muzzle_speed = 10
@export var millistoshot = 100
@onready var rof_timer = $Timer

var damage
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	rof_timer.wait_time = millistoshot / 1000.0
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func shoot():
	if can_shoot:
		var new_bullet = bullet.instantiate()
		
		new_bullet.global_transform = $muzzle.global_transform
		new_bullet.speed = muzzle_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		can_shoot = false
		rof_timer.start()


func _on_timer_timeout():
	can_shoot = true
	pass # Replace with function body.
