extends Area2D

signal collected(value: int)

@export var value: int = 10
var scroll_speed: float = 300.0
var pulse_time: float = 0.0
var is_picked: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta
	if not is_picked:
		pulse_time += delta * 6.0
		var wobble = 1.0 + 0.12 * sin(pulse_time)
		sprite.scale = Vector2(wobble, wobble)

	if position.x < -100.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if is_picked:
		return

	if body.has_method("trigger_bounce") or body.is_in_group("player"):
		is_picked = true
		emit_signal("collected", value)
		if body.has_signal("coin_collected"):
			body.emit_signal("coin_collected", value)

		var tw = create_tween()
		tw.tween_property(self, "scale", Vector2(1.6, 1.6), 0.12)
		tw.parallel().tween_property(self, "modulate:a", 0.0, 0.12)
		tw.tween_callback(queue_free)
