extends TileMap

signal tilemap_size

onready var player = $Player
onready var map_size = calculate_map_size()
var ProjectileClass = preload("res://scenes/projectile.tscn")

func calculate_map_size() -> Rect2:
	var cell_to_pixel: Transform2D = Transform2D(
		Vector2(self.cell_size.x * self.scale.x, 0),
		Vector2(0, self.cell_size.y * self.scale.y),
		Vector2()
	)

	var cell_bounds: Rect2 = self.get_used_rect()

	return Rect2(
		cell_to_pixel * cell_bounds.position,
		cell_to_pixel * cell_bounds.size
	)

func _ready() -> void:
	emit_signal("tilemap_size", calculate_map_size())

func handle_fire(angle: float, pos: Vector2) -> void:
	var projectile: KinematicBody2D = ProjectileClass.instance()
	projectile.init(map_size, angle, pos)
	add_child(projectile)
