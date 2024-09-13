extends Sprite2D


@export var paralax_speed_multiplier: float = 1.0

var scroll_speed: float
var background_repeat_threshold: int


func _ready() -> void:
	scroll_speed = get_parent().get_meta("speed")
	background_repeat_threshold = get_parent().get_meta("background_repeat_threshold")


func _process(delta: float) -> void:
	position.y += scroll_speed * delta * paralax_speed_multiplier
	if position.y > background_repeat_threshold: position.y = background_repeat_threshold * -1
