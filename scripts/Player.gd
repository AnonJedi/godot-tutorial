extends KinematicBody2D

signal fire

const SPEED := 150
const ROTATION_SPEED := 1.0
const TURNING_COEF := 0.5
var map_rect: Rect2
var is_gun_ready := true

onready var self_size: Vector2 = $Sprite.get_rect().size
onready var fire_timeout = $FireTimeout

export(float) var fire_timeout_sec


func _ready() -> void:
	fire_timeout.wait_time = fire_timeout_sec


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

	var half_size_x: float = self_size.x / 2
	var half_size_y: float = self_size.y / 2

	position.x = clamp(
		position.x,
		map_rect.position.x + half_size_x,
		map_rect.end.x - half_size_x
	)
	position.y = clamp(
		position.y,
		map_rect.position.y + half_size_y,
		map_rect.end.y - half_size_y
	)

	move_and_slide(velocity.rotated(rotation))


func handle_fire() -> void: 
	if Input.is_action_just_pressed("fire") and is_gun_ready:
		var rotation_pos = Vector2.UP.rotated(rotation) * self_size.y / 2
		is_gun_ready = false
		fire_timeout.start()
		
		print(self_size.y)
		emit_signal(
			"fire",
			rotation,
			position + rotation_pos
		)


func _process(delta: float) -> void:
	if not map_rect:
		return
	handle_move(delta)
	handle_fire()


func handle_map_size(map: Rect2) -> void:
	map_rect = map


func on_fire_timeout() -> void:
	is_gun_ready = true
