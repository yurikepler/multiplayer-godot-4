extends CharacterBody3D


const SPEED := 10.0

var deadzone := 0.2

var direction := Vector3()
var ray_origin := Vector3()
var ray_target := Vector3()

var isGamepad

var nickname = ""

@onready var gun_controller = $gun_controller
@onready var camera = $Camera3D

func _enter_tree():
	#print("player name tree: " + self.name, multiplayer.get_unique_id())
	set_multiplayer_authority(multiplayer.get_unique_id())
	pass

func _ready():
	if is_multiplayer_authority(): 
		print("player ID ready: ", multiplayer.get_unique_id())
		InputMap.action_set_deadzone("aim_up", deadzone)
		InputMap.action_set_deadzone("aim_down", deadzone)
		InputMap.action_set_deadzone("aim_left", deadzone)
		InputMap.action_set_deadzone("aim_right", deadzone)

		InputMap.action_set_deadzone("up", deadzone)
		InputMap.action_set_deadzone("down", deadzone)
		InputMap.action_set_deadzone("left", deadzone)
		InputMap.action_set_deadzone("right", deadzone)

		#camera.make_current()
	pass

func _physics_process(delta):
	if is_multiplayer_authority():
		#movement
		direction = Vector3.ZERO
		
		if Input.get_action_strength("right") || Input.get_action_strength("gamepad_right"):
			direction.x += 1
		if Input.get_action_strength("left") || Input.get_action_strength("gamepad_left"):
			direction.x -= 1
		if Input.get_action_strength("up") || Input.get_action_strength("gamepad_up"):
			direction.z -= 1
		if Input.get_action_strength("down") || Input.get_action_strength("gamepad_down"):
			direction.z += 1
		velocity = direction.normalized() * SPEED
		move_and_slide()

		if (Input.get_action_strength("right") || Input.get_action_strength("left") 
		|| Input.get_action_strength("up") || Input.get_action_strength("down")):
			isGamepad = false

		if (Input.get_action_strength("gamepad_right") || Input.get_action_strength("gamepad_left") 
		|| Input.get_action_strength("gamepad_up") || Input.get_action_strength("gamepad_down")):
			isGamepad = true

		#facing_gamepad
		if isGamepad:
			var look_vector = Vector3()
			look_vector.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
			look_vector.z = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
			if look_vector != Vector3.ZERO:
				look_at(position + look_vector.normalized(), Vector3.UP)

		#facing_mouse
		if !isGamepad:
			var mouse_position = get_viewport().get_mouse_position()

			ray_origin = $Camera3D.project_ray_origin(mouse_position)
			ray_target = ray_origin + $Camera3D.project_ray_normal(mouse_position) *2000

			var ray = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
			ray.collide_with_areas = true

			var space_state = get_world_3d().direct_space_state
			var intersection = space_state.intersect_ray(ray)

			if not intersection.is_empty():
				var pos = intersection.position
				var look_at_me = Vector3(pos.x, $body.position.y, pos.z)
				$body.look_at(look_at_me, Vector3.UP)

		#shoting
		if Input.is_action_pressed("fire"):
			gun_controller.shoot()

func set_nickname(nickname):
	self.nickname = nickname
	$nickname.text = nickname
	pass
	
