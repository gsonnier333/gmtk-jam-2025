extends CharacterBody2D


@export var speed: float = 300.0
@export var jump_velocity: float = -700.0
@export var reset_time_sec: float = 5.0

@onready var shadow: Sprite2D = %Shadow

const QUEUE_TICKS: int = 5
var player_movements_queue: PackedVector2Array = []
var max_queue_size: int
var tick_count: int = 0

func _ready() -> void:
	max_queue_size = int((Engine.get_physics_ticks_per_second() * reset_time_sec) / QUEUE_TICKS)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		jump()
	if event.is_action_pressed("escape"):
		handle_escape()
	if event.is_action("debug"):
		print(len(player_movements_queue))
		print(player_movements_queue)
	if event.is_action("time-jump"):
		global_position = player_movements_queue[0]
		shadow.global_position = player_movements_queue[0]
		player_movements_queue.clear()

func _process(delta: float) -> void:
	if player_movements_queue.is_empty():
		shadow.global_position = global_position
	else:
		shadow.global_position = player_movements_queue[0]
	

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	if tick_count >= QUEUE_TICKS:
		add_pos_to_queue(global_position)
		tick_count = 0
	else:
		tick_count += 1
	
func add_pos_to_queue(pos: Vector2):
	if len(player_movements_queue) < max_queue_size:
		player_movements_queue.append(pos)
	else:
		player_movements_queue.append(pos)
		player_movements_queue.remove_at(0)

func handle_movement(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func jump():
	velocity.y = jump_velocity

func handle_escape():
	get_tree().quit()
