extends Node

@export var starting_weapon : PackedScene
@export var secondary_weapon : PackedScene
var hand : Marker3D
var equipped_weapon : Node
var hand_free = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hand = get_parent().find_child("hand")

func equip_weapon(weapon_to_equip, num):
	if num == 1:
		if equipped_weapon:
			print("deletando arma")
			equipped_weapon.queue_free()
			equipped_weapon = weapon_to_equip.instantiate()
			hand.add_child(equipped_weapon)
		else:
			equipped_weapon = weapon_to_equip.instantiate()
			hand.add_child(equipped_weapon)
	elif num == 2:
		if equipped_weapon:
			print("deletando arma")
			equipped_weapon.queue_free()
			equipped_weapon = weapon_to_equip.instantiate()
			hand.add_child(equipped_weapon)
		else:
			equipped_weapon = weapon_to_equip.instantiate()
			hand.add_child(equipped_weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("weapon_1"):
		equip_weapon(starting_weapon, 1)
	if Input.is_action_just_pressed("weapon_2"):
		equip_weapon(secondary_weapon, 2)

func shoot():
	if equipped_weapon:
		equipped_weapon.shoot()
