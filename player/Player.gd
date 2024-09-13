extends RigidBody2D


@export var moving_up_button: Key = KEY_W
@export var moving_down_button: Key = KEY_S
@export var moving_left_button: Key = KEY_A
@export var moving_right_button: Key = KEY_D
@export var moving_speed: int = 400
@export var invincibility_time: float = 0.5
@export var cannon_cooldown_time: float = 1
@export var rockets_cooldown_time: float = 5
@export var big_gun_cooldown_time: float = 10


@export var big_gun_projectile: PackedScene
@export var big_gun_projectile_speed: float = 400

@export var rocket_projectile: PackedScene
@export var rocket_projectile_speed: float = 500

@export var cannon_projectile: PackedScene
@export var cannon_projectile_speed: float = 600

const max_hit_points: int = 4
var hit_points: int = 0
var velocity: Vector2
var screen_size: Vector2
var invicibility: bool = false
var cannon: bool = true
var rockets: bool = true
var big_gun: bool = true
var invicibility_time_left: float = 0
var cannon_cooldown_time_left: float = 0
var rockets_cooldown_time_left: float = 0
var big_gun_cooldown_time_left: float = 0

signal death


func _ready() -> void:
	hit_points = max_hit_points
	screen_size = get_viewport_rect().size


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	movement_handling(delta)
	attack_handling()
	check_cooldowns(delta)
	
	if Input.is_key_pressed(KEY_1):
		$Sprite/AutoCannon.show()
	if Input.is_key_pressed(KEY_2):
		$Sprite/BigSpaceGun.show()
	if Input.is_key_pressed(KEY_3):
		$Sprite/Rockets.show()


func movement_handling(delta) -> void:
	velocity = Vector2.ZERO
	if Input.is_key_pressed(moving_right_button): velocity.x += 1
	if Input.is_key_pressed(moving_left_button): velocity.x -= 1
	if Input.is_key_pressed(moving_down_button): velocity.y += 1
	if Input.is_key_pressed(moving_up_button): velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * moving_speed
		$Sprite/EngineEffect.animation = "Moving"
	else: 
		$Sprite/EngineEffect.animation = "Idle"
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func attack_handling() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if $Sprite/AutoCannon.visible == true and cannon == true:
			$Sprite/AutoCannon.play()
			cannon = false
			cannon_cooldown_time_left = cannon_cooldown_time
		if $Sprite/Rockets.visible == true and rockets == true:
			$Sprite/Rockets.play()
			rockets = false
			rockets_cooldown_time_left = rockets_cooldown_time
		if $Sprite/BigSpaceGun.visible == true and big_gun == true:
			$Sprite/BigSpaceGun.play()
			big_gun = false
			big_gun_cooldown_time_left = big_gun_cooldown_time
	if $Sprite/AutoCannon.is_playing():
			if $Sprite/AutoCannon.frame == 1:
				cannon_shoot($Sprite/AutoCannon/CannonSpawnPoint1)
				cannon_shoot($Sprite/AutoCannon/CannonSpawnPoint2)
				$Sprite/AutoCannon.frame = 2
			if $Sprite/AutoCannon.frame == 6:
				$Sprite/AutoCannon.pause()
	if $Sprite/Rockets.is_playing():
			if $Sprite/Rockets.frame == 2:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint1)
				$Sprite/Rockets.frame == 3
			if $Sprite/Rockets.frame == 4:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint2)
				$Sprite/Rockets.frame == 5
			if $Sprite/Rockets.frame == 6:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint3)
				$Sprite/Rockets.frame == 7
			if $Sprite/Rockets.frame == 8:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint4)
				$Sprite/Rockets.frame == 9
			if $Sprite/Rockets.frame == 10:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint5)
				$Sprite/Rockets.frame == 11
			if $Sprite/Rockets.frame == 12:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint6)
				$Sprite/Rockets.frame == 13
			if $Sprite/Rockets.frame == 16:
				$Sprite/Rockets.pause()
	if $Sprite/BigSpaceGun.is_playing():
			if $Sprite/BigSpaceGun.frame == 6:
				big_gun_shoot($Sprite/BigSpaceGun/BigGunProjectileSpawnPoint)
				$Sprite/BigSpaceGun.frame = 7
			if $Sprite/BigSpaceGun.frame == 11:
				$Sprite/BigSpaceGun.pause()


func cannon_shoot(spawn_point) -> void:
	var projectile = cannon_projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = cannon_projectile_speed
	projectile.transform = spawn_point.global_transform


func rocket_shoot(spawn_point) -> void:
	var projectile = rocket_projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = rocket_projectile_speed
	projectile.transform = spawn_point.global_transform


func big_gun_shoot(spawn_point: Marker2D) -> void:
	var projectile = big_gun_projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = big_gun_projectile_speed
	projectile.transform = spawn_point.global_transform


func check_cooldowns(delta) -> void:
	if invicibility == true:
		invicibility_time_left -= delta
		if invicibility_time_left <= 0:
			invicibility = false
	if cannon == false:
		cannon_cooldown_time_left -= delta
		if cannon_cooldown_time_left <= 0:
			cannon = true
			$Sprite/AutoCannon.frame = 0
	if rockets == false:
		rockets_cooldown_time_left -= delta
		if rockets_cooldown_time_left <= 0:
			rockets = true
			$Sprite/Rockets.frame = 0
	if big_gun == false:
		big_gun_cooldown_time_left -= delta
		if big_gun_cooldown_time_left <= 0:
			big_gun = true
			$Sprite/BigSpaceGun.frame = 0


func take_damage() -> void:
	if invicibility == false:
		hit_points -= 1
		$Sprite/Hull.frame += 1
		if hit_points == 0:
			hide()
			death.emit()
		get_invicibility(invincibility_time)


func get_invicibility(time: float) -> void:
	invicibility = true
	invicibility_time_left = time


func start(pos):
	position = pos
	show()
