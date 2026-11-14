@tool
extends Node2D

@export var body_color: Color = Color(0.18, 0.22, 0.32, 1.0)
@export var accent_color: Color = Color(0.0, 0.9, 1.0, 1.0)
@export var visor_color: Color = Color(0.05, 0.85, 1.0, 1.0)
@export var pupil_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var thruster_metal: Color = Color(0.3, 0.35, 0.45, 1.0)

var eye_offset: Vector2 = Vector2(6.0, -2.0)
var pulse_time: float = 0.0

func _process(delta: float) -> void:
	pulse_time += delta * 4.0
	queue_redraw()

func _draw() -> void:
	# 1. Underbelly Thruster Nozzle
	var nozzle_points = PackedVector2Array([
		Vector2(-10.0, 16.0),
		Vector2(10.0, 16.0),
		Vector2(6.0, 24.0),
		Vector2(-6.0, 24.0)
	])
	draw_colored_polygon(nozzle_points, thruster_metal)
	draw_polyline(nozzle_points, Color(0.5, 0.6, 0.7, 1.0), 1.5)

	# 2. Main Cyber-Orb Body (Outer Glow & Shadow)
	draw_circle(Vector2.ZERO, 25.0, Color(0.08, 0.1, 0.16, 1.0))
	draw_circle(Vector2.ZERO, 24.0, body_color)

	# Highlights for spherical depth
	draw_circle(Vector2(-6.0, -8.0), 16.0, Color(0.26, 0.32, 0.46, 0.8))
	draw_circle(Vector2(-9.0, -11.0), 7.0, Color(0.45, 0.55, 0.75, 0.6))

	# 3. Outer Neon Accent Ring (The Bounce Coil)
	var glow_alpha = 0.7 + 0.3 * sin(pulse_time)
	var pulse_glow = accent_color
	pulse_glow.a = glow_alpha
	draw_arc(Vector2.ZERO, 23.5, -PI, PI, 32, pulse_glow, 2.5)

	# 4. Top Antenna / Cyber Crest
	draw_line(Vector2(0.0, -22.0), Vector2(0.0, -32.0), thruster_metal, 3.0)
	draw_circle(Vector2(0.0, -33.0), 4.5, pulse_glow)

	# 5. Visor (Cyber-Eye)
	var visor_rect = Rect2(Vector2(-4.0, -10.0), Vector2(22.0, 14.0))
	draw_rect(visor_rect, Color(0.02, 0.05, 0.1, 0.9), true)
	draw_rect(visor_rect, accent_color, false, 1.5)

	# Visor glowing eye
	draw_circle(eye_offset, 5.0, visor_color)
	draw_circle(eye_offset + Vector2(1.0, -1.0), 2.0, pupil_color)
