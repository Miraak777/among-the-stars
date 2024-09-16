extends CharacterBody2D


@export var moving_up_button: Key = KEY_W
@export var moving_down_button: Key = KEY_S
@export var moving_left_button: Key = KEY_A
@export var moving_right_button: Key = KEY_D
@export var moving_speed: int = 400
@export var invincibility_time: float = 0.5
@export var cannon_cooldown_time: float = 1
@export var rockets_cooldown_time: float = 5
@export var big_gun_cooldown_time: float = 10

@export var cannon_projectile: PackedScene
@export var cannon_projectile_speed: float = 600
@export var cannon_projectile_base_damage: float = 20

@export var rocket_projectile: PackedScene
@export var rocket_projectile_speed: float = 500
@export var rocket_projectile_base_damage: float = 50

@export var big_gun_projectile: PackedScene
@export var big_gun_projectile_speed: float = 400
@export var big_gun_projectile_base_damage: float = 100


const max_hit_points: int = 4
var hit_points: int = 0
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
	attack_handling()
	check_cooldowns(delta)
	
	if Input.is_key_pressed(KEY_1):
		$Sprite/AutoCannon.show()
	if Input.is_key_pressed(KEY_2):
		$Sprite/BigSpaceGun.show()
	if Input.is_key_pressed(KEY_3):
		$Sprite/Rockets.show()


func attack_handling() -> void:
	if Input.is_action_pressed("CannonShoot"):
		if $Sprite/AutoCannon.visible == true and cannon == true:
			$Sprite/AutoCannon.play()
			cannon = false
			cannon_cooldown_time_left = cannon_cooldown_time
	if Input.is_action_pressed("RocketShoot"):
		if $Sprite/Rockets.visible == true and rockets == true:
			$Sprite/Rockets.play()
			rockets = false
			rockets_cooldown_time_left = rockets_cooldown_time
	if Input.is_action_pressed("BigGunShoot"):
		if $Sprite/BigSpaceGun.visible == true and big_gun == true:
			$Sprite/BigSpaceGun.play()
			big_gun = false
			big_gun_cooldown_time_left = big_gun_cooldown_time
	if $Sprite/AutoCannon.is_playing():
			if $Sprite/AutoCannon.frame == 0:
				cannon_shoot($Sprite/AutoCannon/CannonSpawnPoint1)
				$Sprite/AutoCannon.frame = 1
			if $Sprite/AutoCannon.frame == 2:
				cannon_shoot($Sprite/AutoCannon/CannonSpawnPoint2)
				$Sprite/AutoCannon.frame = 3
			if $Sprite/AutoCannon.frame == 6:
				$Sprite/AutoCannon.pause()
	if $Sprite/Rockets.is_playing():
			if $Sprite/Rockets.frame == 0:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint1)
				$Sprite/Rockets.frame = 1
			if $Sprite/Rockets.frame == 2:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint2)
				$Sprite/Rockets.frame = 3
			if $Sprite/Rockets.frame == 4:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint3)
				$Sprite/Rockets.frame = 5
			if $Sprite/Rockets.frame == 6:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint4)
				$Sprite/Rockets.frame = 7
			if $Sprite/Rockets.frame == 8:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint5)
				$Sprite/Rockets.frame = 9
			if $Sprite/Rockets.frame == 10:
				rocket_shoot($Sprite/Rockets/RocketSpawnPoint6)
				$Sprite/Rockets.frame = 11
			if $Sprite/Rockets.frame == 16:
				$Sprite/Rockets.pause()
	if $Sprite/BigSpaceGun.is_playing():
			if $Sprite/BigSpaceGun.frame == 0:
				big_gun_shoot($Sprite/BigSpaceGun/BigGunProjectileSpawnPoint)
				$Sprite/BigSpaceGun.frame = 5
			if $Sprite/BigSpaceGun.frame == 11:
				$Sprite/BigSpaceGun.pause()


func cannon_shoot(spawn_point: Marker2D) -> void:
	var projectile: PhysicsBody2D = cannon_projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = cannon_projectile_speed
	projectile.damage = cannon_projectile_base_damage
	projectile.transform = spawn_point.global_transform


func rocket_shoot(spawn_point: Marker2D) -> void:
	var projectile = rocket_projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = rocket_projectile_speed
	projectile.damage = rocket_projectile_base_damage
	projectile.transform = spawn_point.global_transform


func big_gun_shoot(spawn_point: Marker2D) -> void:
	var projectile = big_gun_projectile.instantiate()
	owner.add_child(projectile)
	projectile.speed = big_gun_projectile_speed
	projectile.damage = big_gun_projectile_base_damage
	projectile.transform = spawn_point.global_transform


func check_cooldowns(delta: float) -> void:
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


func _physics_process(delta: float) -> void:
	movement_handling(delta)


func movement_handling(delta: float) -> void:
	velocity = Vector2.ZERO
	var move_up: bool = Input.is_action_pressed("MoveUp")
	var move_down: bool = Input.is_action_pressed("MoveDown")
	var move_left: bool = Input.is_action_pressed("MoveLeft")
	var move_right: bool = Input.is_action_pressed("MoveRight")
	if move_up: velocity.y -= moving_speed
	if move_left: velocity.x -= moving_speed
	if move_right: velocity.x += moving_speed
	if move_down: velocity.y += moving_speed
	velocity = velocity.limit_length(moving_speed)
	move_and_slide()
	if true in [move_up, move_down, move_left, move_right]:
		$Sprite/EngineEffect.animation = "Moving"
	else: 
		$Sprite/EngineEffect.animation = "Idle"



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


func start(pos: Vector2):
	position = pos
	show()
