extends Node2D

const COIN_SCENE = preload("res://scenes/coin.tscn")
const BUMPER_SCENE = preload("res://scenes/bounce_bumper.tscn")
const LASER_SCENE = preload("res://scenes/laser_obstacle.tscn")
const MISSILE_SCENE = preload("res://scenes/missile.tscn")

@export var base_speed: float = 340.0

var current_speed: float = 340.0
var score_distance: float = 0.0
var total_coins: int = 0
var game_running: bool = true

var obstacle_timer: float = 1.0
var coin_timer: float = 0.5
var missile_timer: float = 7.0

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var background: Node2D = $Background
@onready var entities: Node2D = $Entities

func _ready() -> void:
	randomize()
	current_speed = base_speed
	score_distance = 0.0
	total_coins = 0
	game_running = true

	background.scroll_speed = current_speed
	player.bounced.connect(_on_player_bounced)
	player.coin_collected.connect(_on_coin_collected)
	player.died.connect(_on_player_died)
	hud.restart_requested.connect(_on_restart_game)

func _process(delta: float) -> void:
	if not game_running:
		return

	# meter tracker + gradual difficulty ramping
	score_distance += current_speed * delta * 0.08
	current_speed = base_speed + (score_distance * 0.09)
	background.scroll_speed = current_speed
	hud.update_stats(int(score_distance), total_coins)

	tick_spawners(delta)

func tick_spawners(delta: float) -> void:
	obstacle_timer -= delta
	if obstacle_timer <= 0.0:
		spawn_obstacle()
		obstacle_timer = randf_range(1.5, 2.4)

	coin_timer -= delta
	if coin_timer <= 0.0:
		spawn_coin_formation()
		coin_timer = randf_range(2.0, 3.4)

	missile_timer -= delta
	if missile_timer <= 0.0:
		spawn_missile()
		missile_timer = randf_range(8.0, 12.0)

func spawn_obstacle() -> void:
	if randf() < 0.45:
		var bumper = BUMPER_SCENE.instantiate()
		bumper.position = Vector2(1340.0, randf_range(160.0, 560.0))
		bumper.scroll_speed = current_speed
		bumper.bumper_hit.connect(_on_bumper_hit)
		entities.add_child(bumper)
	else:
		var laser = LASER_SCENE.instantiate()
		laser.position = Vector2(1340.0, randf_range(160.0, 560.0))
		laser.beam_length = randf_range(110.0, 160.0)
		laser.beam_angle_deg = [0.0, 45.0, -45.0, 90.0].pick_random()
		laser.scroll_speed = current_speed
		entities.add_child(laser)

func spawn_coin_formation() -> void:
	var use_arc = (randi() % 2 == 1)
	var base_y = randf_range(190.0, 530.0)

	for i in range(5):
		var coin = COIN_SCENE.instantiate()
		var px = 1350.0 + (i * 44.0)
		var py = base_y
		if use_arc:
			py += sin(i * 0.75) * 55.0
		coin.position = Vector2(px, py)
		coin.scroll_speed = current_speed
		entities.add_child(coin)

func spawn_missile() -> void:
	var rocket = MISSILE_SCENE.instantiate()
	rocket.position = Vector2(1220.0, player.position.y)
	rocket.target_player = player
	entities.add_child(rocket)

func _on_player_bounced(_type: String, combo: int) -> void:
	hud.update_combo(combo)

func _on_coin_collected(amount: int) -> void:
	var combo_mult = player.combo_count if is_instance_valid(player) else 1
	total_coins += amount * combo_mult
	hud.update_stats(int(score_distance), total_coins)

func _on_bumper_hit(points: int) -> void:
	var combo_mult = player.combo_count if is_instance_valid(player) else 1
	total_coins += (points / 10) * combo_mult
	hud.update_stats(int(score_distance), total_coins)

func _on_player_died() -> void:
	game_running = false
	background.scroll_speed = 0.0
	hud.show_game_over(int(score_distance), total_coins)

func _on_restart_game() -> void:
	get_tree().reload_current_scene()
