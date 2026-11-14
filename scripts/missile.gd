extends Area2D

@export var tracking_duration: float = 1.3
@export var rocket_speed: float = 920.0

var elapsed: float = 0.0
var launched: bool = false
var target_player: Node2D = null

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var warning_sprite: Sprite2D = $WarningSprite
@onready var rocket_sprite: Sprite2D = $RocketSprite

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collision_shape.set_deferred("disabled", true)
	warning_sprite.visible = true
	rocket_sprite.visible = false

func _process(delta: float) -> void:
	elapsed += delta

	if not launched:
		position.x = 1220.0
		if is_instance_valid(target_player):
			position.y = lerpf(position.y, target_player.position.y, delta * 6.5)
		position.y = clampf(position.y, 110.0, 610.0)

		# flash warning icon
		var alpha = 0.4 + 0.6 * sin(elapsed * 18.0)
		warning_sprite.modulate.a = alpha

		if elapsed >= tracking_duration:
			launch()
	else:
		position.x -= rocket_speed * delta
		if position.x < -150.0:
			queue_free()

func launch() -> void:
	launched = true
	warning_sprite.visible = false
	rocket_sprite.visible = true
	collision_shape.set_deferred("disabled", false)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit()
