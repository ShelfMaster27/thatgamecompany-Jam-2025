extends CharacterBody3D

@export var walk_speed = 10
@export var gravity = 5
@export var rotation_speed = 90
@export var accel = 50
@export var decel = 70
#@export var start_velocity
#@export var start_angle

func _ready():
	pass
func _process(delta):
	
	if Input.is_key_pressed(KEY_A):
		rotation_degrees.y += rotation_speed * delta
	if Input.is_key_pressed(KEY_D):
		rotation_degrees.y -= rotation_speed * delta
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var target_velocity = (horizontal * get_right() + vertical * get_forward()).normalized() * walk_speed;
	velocity = _move_toward(velocity, target_velocity, (accel if target_velocity > velocity else decel) * delta)
	move_and_slide()

func get_right():
	return Vector3(cos(rotation.y), 0, -sin(rotation.y))

func get_forward():
	return Vector3(cos(rotation.y + (PI/2)), 0, -sin(rotation.y + (PI/2)))

func _move_toward(vec, vec2, d):
	return Vector3(move_toward(vec.x, vec2.x, d),move_toward(vec.y, vec2.y, d),move_toward(vec.z, vec2.z, d))
