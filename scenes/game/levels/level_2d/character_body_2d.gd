extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 250.0
const JUMP_VELOCITY = -500.0
const COYOTE_FRAMES = 8
const BUFFERED_JUMP_FRAMES = 6

@export var use_camera_smoothing: bool = true

# Frames since last on floor (start w/ none)
var coyote_countdown: int = 0
var buffer_countdown: int = 0

@onready var camera_2d: Camera2D = %Camera2D
@onready var camera_pivot = $CameraPivot
@onready var animation_player = %AnimationPlayer
@onready var graphics = %Graphics
@onready var dust_cloud: Node2D = %DustCloud


func _ready() -> void:
	if use_camera_smoothing:
		camera_2d.top_level = true
	#camera_2d.zoom = Vector2.ONE * 0.5

func _process(delta: float) -> void:
	if use_camera_smoothing:
		camera_2d.global_position = lerp(camera_2d.global_position, camera_pivot.global_position, delta * 10)


func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		coyote_countdown = COYOTE_FRAMES
		if animation_player.current_animation in [&"jump", &"jump_up"]:
			# should hand landed this frame
			dust_cloud.emit()
	elif coyote_countdown > 0:
		coyote_countdown -= 1
		# apply gravity if fall is immediate, but can still jump
		#velocity += get_gravity() * delta
	else:
		# more gravity for snappier jumps
		velocity += get_gravity() * delta * 2

	# Handle jump.
	if (buffer_countdown > 0 and is_on_floor()) \
		or (Input.is_action_just_pressed("jump") and coyote_countdown > 0):
			velocity.y = JUMP_VELOCITY
			coyote_countdown = 0
			buffer_countdown = 0
	elif Input.is_action_just_pressed("jump"):
		buffer_countdown = BUFFERED_JUMP_FRAMES
	else:
		buffer_countdown = max(buffer_countdown - 1, 0)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
	if is_on_floor():
		if direction:
			animation_player.play(&"run")
		else:
			animation_player.play(&"stand")
	else:
		if direction:
			animation_player.play(&"jump")
		else:
			animation_player.play(&"jump_up")
	if velocity.x >= 0:
		graphics.scale.x = 1
	else:
		graphics.scale.x = -1

	move_and_slide()
