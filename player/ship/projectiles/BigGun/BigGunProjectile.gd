extends PhysicsBody2D

var speed: float = 0
var damage: float = 0


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(transform.x * speed * delta)
	if collision_info:
		collision_info.get_collider().take_damage(damage)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
