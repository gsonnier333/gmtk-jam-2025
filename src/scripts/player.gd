extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@export var acceleration: float = 40.0
@export var jump_velocity: float = -700.0
@export var reset_time_sec: float = 5.0
@export var x_wrap: float = 384.0
@export var y_wrap: float = -216.0

@export var time_slow: float = 0.1
@export var time_stop_duration: float = 0.2
@export var shake_intensity: float = 1.0
@export var shake_duration: float = 0.3

@onready var shadow: AnimatedSprite2D = %Shadow
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite

signal warped(from: Vector2, to: Vector2)

const QUEUE_TICKS: int = 5
var player_position_queue: PackedVector2Array = []
var player_velocity_queue: PackedVector2Array = []
var max_queue_size: int
var tick_count: int = 0
var elapsed_time: float = 0.0

func _ready() -> void:
	max_queue_size = int(Engine.get_physics_ticks_per_second() * reset_time_sec)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		jump()
	if event.is_action_pressed("escape"):
		handle_escape()
	if event.is_action("debug"):
		print(player_velocity_queue)
	if event.is_action("time-jump"):
		go_to_shadow()

func _process(delta: float) -> void:
	add_pos_to_queue(global_position, delta)
	if player_position_queue.is_empty():
		shadow.global_position = global_position
	else:
		shadow.global_position = player_position_queue[0]
	

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	
func add_pos_to_queue(pos: Vector2, delta):
	player_position_queue.append(pos)
	if elapsed_time < reset_time_sec:
		elapsed_time += delta
	else:
		player_position_queue.remove_at(0)
		shadow.show()

func handle_movement(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction > 0:
		player_sprite.flip_h = false
		
	elif direction < 0:
		player_sprite.flip_h = true
	else:
		player_sprite.frame = 0
	# handle movement differently in the air
	screen_wrap()
	if is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, acceleration)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration/3)
		else:
			velocity.x = move_toward(velocity.x, 0, acceleration)

	move_and_slide()

func go_to_shadow():
	if !player_position_queue.is_empty() and shadow.visible:
		Events.player_warped.emit(global_position, player_position_queue[0])
		elapsed_time = 0.0
		global_position = player_position_queue[0]
		shadow.global_position = player_position_queue[0]
		shadow.hide()
		player_position_queue.clear()
		Events.freeze_frame.emit(time_slow, time_stop_duration)
		Events.camera_shake.emit(shake_intensity, shake_duration)

func jump():
	velocity.y = jump_velocity

func handle_escape():
	get_tree().quit()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, x_wrap)
	global_position.y = wrapf(global_position.y, 0, y_wrap)
