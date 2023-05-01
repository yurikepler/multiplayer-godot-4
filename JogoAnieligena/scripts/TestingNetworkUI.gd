extends CanvasLayer


func _ready():
	NetworkManager.list_updated.connect(self.list_updated)
	NetworkManager.conection_reset.connect(self.conection_reset)

func _on_host_button_pressed():
	NetworkManager.update_name($MainMenu/MarginContainer/VBoxContainer/PlayerName.text)
	NetworkManager.create_server()
	$MainMenu/MarginContainer/VBoxContainer/HostButton.disabled = true
	$MainMenu/MarginContainer/VBoxContainer/ClientButton.disabled = true
	var ip = NetworkManager.return_ip()
	$MainMenu/MarginContainer/VBoxContainer/ServerIp.text = "Give this IP to your friends: " + ip

func _on_client_button_pressed():
	NetworkManager.update_ip($MainMenu/MarginContainer/VBoxContainer/IpAdress.text)
	NetworkManager.update_name($MainMenu/MarginContainer/VBoxContainer/PlayerName.text)
	NetworkManager.connect_server()
	$MainMenu/MarginContainer/VBoxContainer/ClientButton.disabled = true
	$MainMenu/MarginContainer/VBoxContainer/HostButton.disabled = true

func _on_start_game_pressed():
	if multiplayer.is_server():
		rpc("start_game")

@rpc("any_peer", "call_local")
func start_game():
	get_tree().change_scene_to_file("res://scenes/mapas/mapa1.tscn")

func list_updated():
	var list = NetworkManager.return_player_list()
	$MainMenu2/MarginContainer/PlayerList.clear()
	for i in range(list.size()):
		if list[i][0] == NetworkManager.id:
			$MainMenu2/MarginContainer/PlayerList.add_item("ID: " + str(list[i][0]) + " - " + list[i][1] + "(you)")
		else:
			$MainMenu2/MarginContainer/PlayerList.add_item("ID: " + str(list[i][0]) + " - " + list[i][1])
		
func conection_reset():
	$ErrorPanel.show()

func _on_error_button_pressed():
	$MainMenu/MarginContainer/VBoxContainer/ClientButton.disabled = false
	$MainMenu/MarginContainer/VBoxContainer/HostButton.disabled = false
	$ErrorPanel.hide()
