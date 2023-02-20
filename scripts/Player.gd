extends KinematicBody2D

signal fire

const SPEED = 10000
const ROTATION_SPEED = 1
const TURNING_COEF = 0.5
var map_size: Rect2
onready var self_size: Rect2 = $Sprite.get_rect()

func handle_move(delta: float) -> void:
	var velocity: Vector2 = Vector2()
	var current_speed: float = SPEED

	if Input.is_action_pressed("turn_right"):
		rotate(ROTATION_SPEED * delta)
		current_speed *= TURNING_COEF

	if Input.is_action_pressed("turn_left"):
		rotate(-ROTATION_SPEED * delta)
		current_speed *= TURNING_COEF

	if Input.is_action_pressed("move_up"):
		velocity.y -= current_speed

	if Input.is_action_pressed("move_down"):
		velocity.y += current_speed

	var half_size_x: float = self_size.size.x / 2
	var half_size_y: float = self_size.size.y / 2

	position.x = clamp(
		position.x,
		map_size.position.x + half_size_x,
		map_size.end.x - half_size_x
	)
	position.y = clamp(
		position.y,
		map_size.position.y + half_size_y,
		map_size.end.y - half_size_y
	)

	move_and_slide(velocity.rotated(rotation) * delta)

func handle_fire() -> void: 
	if Input.is_action_just_pressed("fire"):
		var rotation_pos = Vector2.UP.rotated(rotation) * self_size.end.y
		emit_signal(
			"fire",
			rotation,
			Vector2(position) + rotation_pos
		)

func _process(delta: float) -> void:
	if not map_size:
		return
	handle_move(delta)
	handle_fire()

func handle_map_size(map: Rect2) -> void:
	map_size = map
