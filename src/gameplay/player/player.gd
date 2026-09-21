extends CharacterBody3D

signal spawn_tower

@export_group("Player nodes")
@export var neck : Node3D
@export var head : Node3D
@export var standing_collision_shape : CollisionShape3D
@export var crouching_collision_shape : CollisionShape3D
@export var ray_cast_3d : RayCast3D
@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree

@export_group("Player stats")
# Speeds
@export var current_speed = 5.0

@export var walking_speed = 5.0
@export var sprinting_speed = 8.0
@export var crouching_speed = 3.0

@export var jump_velocity = 4.5

# States
var walking = false
var sprinting = false
var crouching = false
var free_looking = false
var sliding = false
var moving = false

# mouse sensitivity
const mouse_sens = 0.15
var move_camera := false

@export_group("Config")
# Lerp (smoothing movement)
@export var lerp_speed = 10.0
@export var crouching_depth = -0.5

# valores para la animacion
enum {BASE, WALK, CROUCH, CROUCHWALK}
var current_animation = BASE

var direction = Vector3.ZERO

func _ready():
	# Make mouse not visible
	GameManager.mouseCapture()

func _input(event):
	# Handler of camera movement with mouse
	if event is InputEventMouseMotion:
		if move_camera:
			if free_looking:
				neck.rotate_y(deg_to_rad(-event.relative.x) * mouse_sens)
			else:
				rotate_y(deg_to_rad(-event.relative.x) * mouse_sens)
			head.rotate_x(deg_to_rad(-event.relative.y) * mouse_sens)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("right click")
			move_camera = true
			GameManager.mouse_pos = event.position
			GameManager.mouseCapture()
			print(GameManager.mouse_pos)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
			move_camera = false
			GameManager.mouseVisible()
			Input.warp_mouse(GameManager.mouse_pos)
			

func _physics_process(delta):
	
	# Close game (remove later)
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	
	# Movement logic
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, crouching_depth, delta * lerp_speed)
		crouching_collision_shape.disabled = false
		standing_collision_shape.disabled = true
		walking = false
		sprinting = false
		crouching = true
	else:
		crouching = false
		if !ray_cast_3d.is_colliding(): 
			head.position.y = lerp(head.position.y, 0.0, delta * lerp_speed)
			crouching_collision_shape.disabled = true
			standing_collision_shape.disabled = false
			if Input.is_action_pressed("sprint"):
				current_speed = sprinting_speed
				sprinting = true
				walking = false
			else:
				current_speed = walking_speed
	
	# Handle free looking
	if Input.is_action_pressed("free_look"):
		free_looking = true
	else:
		free_looking = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("forward") or Input.is_action_pressed("backward"):
		moving = true
	else:
		moving = false

	check_animation()
	animation_change()

	move_and_slide()


func _on_camera_3d_spawn_tower_to_player(tower, raycast):
	spawn_tower.emit(tower, raycast)

func check_animation():
	if not crouching:
		current_animation = WALK if moving else BASE
	else:
		current_animation = CROUCHWALK if moving else CROUCH

func animation_change():
	match current_animation:
		BASE:
			animation_tree.set("parameters/Transition/transition_request", "Base")
		WALK:
			animation_tree.set("parameters/Transition/transition_request", "Walk")
		CROUCH:
			animation_tree.set("parameters/Transition/transition_request", "Crouch")
		CROUCHWALK:
			animation_tree.set("parameters/Transition/transition_request", "Crouch_walk")
