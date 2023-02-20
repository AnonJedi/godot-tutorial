extends KinematicBody2D

const VELOCITY: int = 20000
var map_size: Rect2
onready var self_size: Rect2 = $Sprite.get_rect()

func _process(delta: float) -> void:
	if not (map_size and map_size.has_point(position)):
		queue_free()
		return

	move_and_slide(Vector2.UP.rotated(rotation) * VELOCITY * delta)

func init(size: Rect2, direction: float, pos: Vector2) -> void:
	rotate(direction)
	map_size = size

	var rotated_pos: Vector2 = Vector2.UP.rotated(direction)
	position = pos + rotated_pos
