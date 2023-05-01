extends Node3D

var packed_player = preload("res://scenes/player/hunter.tscn")

func _ready():
	var player_list = NetworkManager.return_player_list()
	for i in range(player_list.size()):
		var obj = packed_player.instantiate()
		$Players.add_child(obj)
		#obj.position = Vector3(0, 1, 0)
		obj.name = str(player_list[i][0])
		obj.set_multiplayer_authority(player_list[i][0])
		print("multiplayer authority mapready: ", obj.get_multiplayer_authority())
		obj.set_nickname(player_list[i][1])
	pass
