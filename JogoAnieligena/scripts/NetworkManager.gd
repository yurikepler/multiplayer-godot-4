extends Node

const IPPADRAO = "127.0.0.1"
const PORT = 6007
const MAXPLAYERS = 4

var ip = IPPADRAO
var id = 0
var player_name = ""
var peer = null
var players = []

signal list_updated
signal conection_reset
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(self.connected_to_server)
	multiplayer.connection_failed.connect(self.connection_failed)
	multiplayer.server_disconnected.connect(self.server_lost_connection)
	pass # Replace with function body.

func connected_to_server():
	id = multiplayer.multiplayer_peer.get_unique_id()
	rpc("register_player", id, player_name)
	pass

func peer_disconnected(id):
	rpc("remove_player", id)
	pass

func connection_failed():
	reset_conection()
	pass

func server_lost_connection():
	if not get_tree().current_scene.name == "testing_network_ui":
		get_tree().change_scene_to_file("res://scenes/UI/testing_network_ui.tscn")
	reset_conection()
	pass

func reset_conection():
	peer = null
	multiplayer.set_multiplayer_peer(null)
	players.clear()
	emit_signal("conection_reset")
	pass

@rpc("any_peer", "call_local")
func remove_player(id):
	for i in range(players.size()):
		if players[i][0] == id:
			players.remove_at(i)
			emit_signal("list_updated")
			return
	var player = get_node_or_null(str(id))
	if player:
		print("player queue free id: "+ id)
		player.queue_free()
	pass
	
@rpc("any_peer")
func register_player(id, name):
	if multiplayer.is_server():
		for i in range(players.size()):
			rpc_id(id, "register_player", players[i][0], players[i][1])
		rpc("register_player", id, name)
	players.append([id, name])
	emit_signal("list_updated")

func create_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAXPLAYERS)
	var ip = return_ip()
	peer.peer_disconnected.connect(self.peer_disconnected)
	if ip.begins_with("192"):
		multiplayer.set_multiplayer_peer(peer)
		id = multiplayer.multiplayer_peer.get_unique_id()
		register_player(id, player_name)
	else:
		reset_conection()
	
func connect_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.set_multiplayer_peer(peer)
	
func update_name(name):
	player_name = name
	pass

func update_ip(new_ip):
	ip = new_ip
	pass

func return_player_list():
	return players

func return_ip():
	var list_ip = IP.get_local_addresses()
	for i in range(list_ip.size()):
		if list_ip[i].begins_with("192"):
			return list_ip[i]
	return IPPADRAO




