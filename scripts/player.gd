extends CharacterBody2D

@onready var dialog_system = $"../dialogSystem"
@onready var steps = $steps
@onready var sprite_2d = $Sprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var root: Node

func _ready():
	root = get_node("../..")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	if !dialog_system.is_active:
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if !steps.playing:
				steps.play()
			if direction < 0:
				sprite_2d.flip_h = true
			elif direction > 0:
				sprite_2d.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			steps.stop()

	move_and_slide()