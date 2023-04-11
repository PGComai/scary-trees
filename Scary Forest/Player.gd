extends CharacterBody3D

@export var h_sensitivity: float = 0.001
@export var v_sensitivity: float = 0.001

@onready var camera_3d = $Camera3D
@onready var spot_light_3d = $SpotLight3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var twist = 0.0
var flip = 0.0
var stopped = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		twist -= event.relative.x * h_sensitivity
		flip -= event.relative.y * v_sensitivity

func _physics_process(delta):
	
	rotation.y = twist
	if velocity.is_equal_approx(Vector3.ZERO):
		var v = clamp(flip, -PI/2, PI/2)
		camera_3d.rotation.x = v
		spot_light_3d.rotation.x = v
	else:
		camera_3d.rotation.x = lerp(camera_3d.rotation.x, 0.0, 0.05)
		flip = camera_3d.rotation.x
		spot_light_3d.rotation.x = camera_3d.rotation.x
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "fwd", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
