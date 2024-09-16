extends Node2D


@export var mob_scout: PackedScene

var score: int
var is_battle_started: bool = false
var screen_length: float


func _ready() -> void:
	score = 0
	$Player.position = $StartPosition.position
	screen_length = get_viewport_rect().size.x


func _process(delta: float) -> void:
	pass


func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_delay_timeout() -> void:
	is_battle_started = true
	$NewWaveCountdown.start()


func spawn_scout() -> void:
	var mob_scout = mob_scout.instantiate()
	add_child(mob_scout)
	var spawn_coordinate_x = randi_range(0, screen_length)
	mob_scout.position.x = spawn_coordinate_x
	mob_scout.position.y = 50


func _on_new_wave_countdown_timeout() -> void:
	spawn_scout()
