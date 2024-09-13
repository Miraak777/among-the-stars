extends Node2D


@export var mob_scene: PackedScene

var score: int
var is_battle_started: bool = false
var screen_length: float


func _ready() -> void:
	score = 0
	$Player.position = $StartPosition.position
	var screen_length = get_viewport_rect().size.x


func _process(delta: float) -> void:
	pass


func _on_score_timer_timeout() -> void:
	score += 1


func _on_start_delay_timeout() -> void:
	is_battle_started = true
