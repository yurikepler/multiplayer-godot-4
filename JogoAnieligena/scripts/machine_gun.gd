extends Node3D

@onready var aimcast = $muzzle/aimcast
@onready var rof_timer = $Timer

var damage
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	if can_shoot:
		if aimcast.is_colliding():
			print("acertou")
			rof_timer.start()
			can_shoot = false

func _on_timer_timeout():
	can_shoot = true
