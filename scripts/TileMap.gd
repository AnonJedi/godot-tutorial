extends TileMap

signal tilemap_size

onready var player = get_node("Player")

func calculate_map_size():
	var cell_to_pixel = Transform2D(
		Vector2(self.cell_size.x * self.scale.x, 0),
		Vector2(0, self.cell_size.y * self.scale.y),
		Vector2()
	)

	var cell_bounds = self.get_used_rect()
	return Rect2(
		cell_to_pixel * cell_bounds.position,
		cell_to_pixel * cell_bounds.size
	)

func _ready():
	emit_signal("tilemap_size", calculate_map_size())
