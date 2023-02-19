extends KinematicBody2D

signal fire_projectile

const VELOCITY = 200
const ROTATION_SPEED = 0.02
var map_size = Rect2()
onready var self_size = self.get_node("Sprite").get_rect()


func handle_move():
	var velocity = Vector2()
	var current_speed = VELOCITY

	if Input.is_action_pressed("turn_right"):
		rotate(ROTATION_SPEED)
		current_speed -= 100

	if Input.is_action_pressed("turn_left"):
		rotate(-ROTATION_SPEED)
		current_speed -= 100

	if Input.is_action_pressed("move_up"):
		velocity.y -= current_speed

	if Input.is_action_pressed("move_down"):
		velocity.y += current_speed

	var half_size_x = self_size.size.x / 2
	var half_size_y = self_size.size.y / 2

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

	move_and_slide(velocity.rotated(rotation))

func handle_fire(): 
	if Input.is_action_pressed("fire"):
		emit_signal("fire_projectile")

func _process(delta):
	if !(map_size.end.x && map_size.end.y && self_size.end.x && self_size.end.y):
		return
	handle_move()
	handle_fire()


func handle_map_size(map: Rect2) -> void:
	map_size = map
