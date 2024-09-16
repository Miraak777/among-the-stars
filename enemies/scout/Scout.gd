extends RigidBody2D


@export var projectile: PackedScene
@export var projectile_speed: float = 500
@export var moving_speed: float = 300
@export var hit_points: float = 100


var dead: bool = false
var ai: bool = true


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	if dead == true: death()


func shoot(spawn_point: Marker2D) -> void:
	var projectile = projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = projectile_speed
	projectile.transform = spawn_point.global_transform


func take_damage(damage: float) -> void:
	hit_points -= damage
	if hit_points <= 0: dead = true


func death() -> void:
	if $Sprite/Destruction.is_playing() == false:
		ai = false
		$CollisionPolygon2D.disabled = true
		$Sprite/Hull.hide()
		$Sprite/Weapon.hide()
		$Sprite/Destruction.show()
		$Sprite/Destruction.play()
	if $Sprite/Destruction.frame == 15: queue_free()
