extends CharacterBody3D

@export var walk_speed = 10

@export var rotation_speed = 90
@export var walk_accel = 50
@export var walk_decel = 70
@export var fly_start_speed = 20
@export var fly_start_direction = Vector3(0,-0.5,-1).normalized()
@export var fly_accel = 20
@export var fly_terminal_speed = 10
@export var fly_drag = 0.1
@export var gravity = 15

var is_flying = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("toggle_fly"):
		is_flying = not is_flying
		velocity = fly_start_direction * fly_start_speed
	
	if is_flying:
		$CollisionShape3D.rotation_degrees.x = 90
		$MeshInstance3D.rotation_degrees.x = 90
		$Camera3D.rotation_degrees.x = -10
		$Camera3D.position.y = 2
	else:
		$CollisionShape3D.rotation_degrees.x = 0
		$MeshInstance3D.rotation_degrees.x = 0
		$Camera3D.rotation_degrees.x = -20
		$Camera3D.position.y = 5

func _physics_process(delta):
	if not is_flying:
		if Input.is_key_pressed(KEY_A):
			rotation_degrees.y += rotation_speed * delta
		if Input.is_key_pressed(KEY_D):
			rotation_degrees.y -= rotation_speed * delta
		var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var vertical = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
		var target_velocity = (horizontal * get_right() + vertical * get_forward()).normalized() * walk_speed;
		velocity = _move_toward(velocity, target_velocity, (walk_accel if target_velocity > velocity else walk_decel) * delta)
		move_and_slide()
	else:
		if Input.is_key_pressed(KEY_A):
			rotation_degrees.y += rotation_speed * delta
		if Input.is_key_pressed(KEY_D):
			rotation_degrees.y -= rotation_speed * delta
		if Input.is_key_pressed(KEY_W) and rotation_degrees.x < 90:
			rotation_degrees.x += rotation_speed * delta
		if Input.is_key_pressed(KEY_S) and rotation_degrees.x > -90:
			rotation_degrees.x -= rotation_speed * delta
		
		var velocity_length = velocity.length()
		velocity_length += fly_accel * delta
		
		velocity = _move_toward(velocity.normalized(),-transform.basis.z,1) * velocity_length
		# Add forward motion
		
		#var drag_force = -velocity.normalized() * fly_drag * velocity.length_squared()
		#velocity += drag_force * delta

		velocity += Vector3.DOWN * gravity * delta
		
		# Clamp speed
		if velocity.length() > fly_terminal_speed:
			velocity = velocity.normalized() * fly_terminal_speed
		
		move_and_slide()
		print(position, ",", velocity)

func get_right():
	return Vector3(cos(rotation.y), 0, -sin(rotation.y))

func get_forward():
	return Vector3(cos(rotation.y + (PI/2)), 0, -sin(rotation.y + (PI/2)))

func _move_toward(vec, vec2, d):
	return Vector3(move_toward(vec.x, vec2.x, d), move_toward(vec.y, vec2.y, d), move_toward(vec.z, vec2.z, d))
