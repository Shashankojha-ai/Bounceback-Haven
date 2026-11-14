extends Node2D

var scroll_offset: float = 0.0
var scroll_speed: float = 300.0

func _process(delta: float) -> void:
	scroll_offset = fmod(scroll_offset + scroll_speed * delta, 80.0)
	queue_redraw()

func _draw() -> void:
	# lab backdrop
	var bg_rect = Rect2(Vector2.ZERO, Vector2(1280.0, 720.0))
	draw_rect(bg_rect, Color(0.06, 0.08, 0.12, 1.0))

	# scrolling grid
	var grid_color = Color(0.12, 0.18, 0.28, 0.5)
	var x = -scroll_offset
	while x < 1280.0:
		draw_line(Vector2(x, 70.0), Vector2(x, 650.0), grid_color, 1.0)
		x += 80.0

	for y in range(120, 650, 60):
		draw_line(Vector2(0.0, y), Vector2(1280.0, y), grid_color, 1.0)

	# ceiling barrier rail (y: 0 - 70)
	var ceiling_rect = Rect2(Vector2.ZERO, Vector2(1280.0, 70.0))
	draw_rect(ceiling_rect, Color(0.09, 0.11, 0.17, 1.0))
	draw_line(Vector2(0.0, 70.0), Vector2(1280.0, 70.0), Color(0.0, 0.9, 1.0, 1.0), 3.0)

	var cx = -scroll_offset
	while cx < 1280.0:
		draw_line(Vector2(cx, 0.0), Vector2(cx + 35.0, 70.0), Color(0.0, 0.8, 0.9, 0.25), 8.0)
		cx += 70.0

	# floor bounce rail (y: 650 - 720)
	var floor_rect = Rect2(Vector2(0.0, 650.0), Vector2(1280.0, 70.0))
	draw_rect(floor_rect, Color(0.09, 0.11, 0.17, 1.0))
	draw_line(Vector2(0.0, 650.0), Vector2(1280.0, 650.0), Color(0.0, 1.0, 0.65, 1.0), 3.5)

	var fx = -scroll_offset
	while fx < 1280.0:
		draw_line(Vector2(fx, 650.0), Vector2(fx + 35.0, 720.0), Color(0.0, 0.9, 0.6, 0.25), 8.0)
		fx += 70.0
