extends CharacterBody2D
class_name Player

@export var speed: float = 300.0
@export var acceleration: float = 40.0
@export var jump_velocity: float = -700.0
@export var reset_time_sec: float = 5.0
@export var x_wrap: float = 640.0
@export var y_wrap: float = 360.0

@export var time_slow: float = 0.1
@export var time_stop_duration: float = 0.2
@export var shake_intensity: float = 1.0
@export var shake_duration: float = 0.3

@export var coyote_frames: int = 5
var frames_since_on_ground: int = 0

@export var vel_buffer_max_frames: int = 5

@onready var shadow: AnimatedSprite2D = %Shadow
@onready var player_sprite: AnimatedSprite2D = %PlayerSprite
@onready var jump_sound: AudioStreamPlayer = %JumpSound
@onready var loop_sound: AudioStreamPlayer = %LoopSound


signal warped(from: Vector2, to: Vector2)

const QUEUE_TICKS: int = 5
var player_position_queue: PackedVector2Array = []
var player_animation_frames_queue: Array = []
var velocity_buffer: PackedVector2Array = []
var max_queue_size: int
var tick_count: int = 0
var elapsed_time: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	max_queue_size = int(Engine.get_physics_ticks_per_second() * reset_time_sec)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("escape"):
		handle_escape()
	if event.is_action("debug"):
		print(global_position)
	if event.is_action("loop"):
		go_to_shadow()

func _process(delta: float) -> void:
	move_shadow(delta)
	

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_velocity_buffer(velocity)
		
func handle_velocity_buffer(vel: Vector2) -> void:
	velocity_buffer.append(vel)
	if len(velocity_buffer) >= vel_buffer_max_frames:
		velocity_buffer.remove_at(0)
		
func set_player_velocity(vel: Vector2) -> void:
	velocity = vel
	velocity_buffer.clear()

func get_velocity_from_buf() -> Vector2:
	if velocity_buffer.is_empty():
		return velocity
	
	var largest_vel_magnitude_index: int = 0
	for vel in range(len(velocity_buffer)):
		if velocity_buffer[vel].length() > velocity_buffer[largest_vel_magnitude_index].length():
			largest_vel_magnitude_index = vel
	
	return velocity_buffer[largest_vel_magnitude_index]

func move_shadow(delta) -> void:
	player_position_queue.append(global_position)
	player_animation_frames_queue.append([player_sprite.frame, player_sprite.flip_h])
	if elapsed_time < reset_time_sec:
		elapsed_time += delta
	else:
		player_position_queue.remove_at(0)
		player_animation_frames_queue.remove_at(0)
		shadow.show()
	if player_position_queue.is_empty():
		shadow.global_position = global_position
	else:
		shadow.global_position = player_position_queue[0]
	if player_animation_frames_queue.is_empty():
		shadow.frame = player_sprite.frame
		shadow.flip_h = player_sprite.flip_h
	else:
		shadow.frame = player_animation_frames_queue[0][0]
		shadow.flip_h = player_animation_frames_queue[0][1]

func handle_movement(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		frames_since_on_ground += 1
	else:
		frames_since_on_ground = 0
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
			velocity.x = move_toward(velocity.x, direction * speed, acceleration/1.5)
		else:
			velocity.x = move_toward(velocity.x, 0, acceleration/3)
	
	var hold = velocity
	move_and_slide()

func go_to_shadow():
	if !player_position_queue.is_empty() and shadow.visible:
		loop_sound.play()
		Events.player_warped.emit(global_position, player_sprite.flip_h)
		elapsed_time = 0.0
		global_position = player_position_queue[0]
		shadow.global_position = player_position_queue[0]
		shadow.hide()
		player_position_queue.clear()
		player_animation_frames_queue.clear()
		var buffer_vel = get_velocity_from_buf()
		velocity = buffer_vel
		velocity_buffer.clear()
		Events.freeze_frame.emit(time_slow, time_stop_duration)
		Events.camera_shake.emit(shake_intensity, shake_duration)

func jump():
	if is_on_floor() or frames_since_on_ground < coyote_frames:
		jump_sound.play()
		velocity.y = jump_velocity

func handle_escape():
	Events.toggle_settings.emit()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, x_wrap)
	global_position.y = wrapf(global_position.y, 0, y_wrap)
