extends CharacterBody2D
@onready var cloud_queue = get_node("/root/CloudQueue")
@onready var global = get_node("/root/Global")
@onready var sprite = $AnimatedSprite2D
@onready var coyote_timer = $coyote_timer
@onready var aniplayer = $AnimationPlayer

@export var particle = preload("res://clouds.tscn")
@export var queue_count = 10
@export var movement_speed = 200.0
@export var gravity = 2.0
@export var jump_force = 200.0
@export var particle_amount = 30
@export var extra_jumps = 1

var invincible = false
var MAXTIME = 100
var can_jump = false
var dir = 0
var acceleration = 10
var friction = 60.0
var is_jumping = false
var index = 0
var JUMPS_LEFT = extra_jumps
var PARTICLE_AMOUNT = particle_amount
var SPAWN_POINT : Vector2
var SPEED = movement_speed
var GRAVITY = gravity
var JUMP_FORCE = jump_force
var y_velocity_limit = 400
var ui = load("res://ui.tscn")


func _ready():
	if get_tree().current_scene.name == "playground":
		$Camera2D.add_child(ui.instantiate())
	global.player = self
	for i in range(queue_count):
		$particles.add_child(particle.instantiate())
	SPAWN_POINT = Vector2.ZERO




func _physics_process(delta):
	if Input.is_action_just_pressed("invincibility_toggle"):
		invincible = !invincible
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 1:
		dir = 1
	if direction == -1:
		dir = -1
	jump()
	if invincible == true:
		$hurtbox/CollisionShape2D.disabled = true
		global.playerInvincible = true
	elif invincible == false:
		$hurtbox/CollisionShape2D.disabled = false
		global.playerInvincible = false
	SPAWN_POINT = global.SPAWN_POINT
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	if velocity.x == 0:
		sprite.pause()
	else:
		sprite.play("walking")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * (SPEED), (acceleration))
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	if is_on_floor():
		can_jump = true
	if velocity.y < 0:
		sprite.play("jumping")
	elif velocity.y > 0:
		sprite.play("falling")
		
	if velocity == Vector2.ZERO:
		sprite.play("idle")
	
	if Input.is_action_just_pressed("door"):
		for area in $hurtbox.get_overlapping_areas():
			if area.get_parent().is_in_group("door"):
				get_tree().change_scene_to_file(global.destination_scene)
		
	if !coyote_timer.is_stopped() or is_on_floor():
		JUMPS_LEFT = extra_jumps
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()


func death():
	var deathpos = position
	$explosion.position = deathpos
	$explosion.emitting = true
	
	if SPAWN_POINT == null:
		SPAWN_POINT = Vector2.ZERO
	position = SPAWN_POINT

func get_next_particle():
	return $particles.get_child(index)

func trigger():
	if index == 10:
		index = 0
	get_next_particle().emitting = true
	index = (index + 1)
	
func jump():
	var direction = Input.get_axis("ui_left", "ui_right")

	if Input.is_action_just_pressed("ui_jump") && (!coyote_timer.is_stopped() or JUMPS_LEFT > 0):
		
		$AudioStreamPlayer.play()
		aniplayer.play("jump")
		is_jumping = true
		trigger()
		velocity.y = 0
		velocity.y -= JUMP_FORCE
		JUMPS_LEFT -= 1
		
		
	if is_on_wall() && !is_on_floor():
		JUMPS_LEFT = extra_jumps
		velocity.y = friction

		if Input.is_action_just_pressed("ui_jump"):
			aniplayer.play("jump")
			$AudioStreamPlayer.play()
			velocity.x = -direction * 200
			velocity.y = 0
			velocity.y -= JUMP_FORCE
	if !is_on_floor_only() && velocity.y < y_velocity_limit:
		velocity.y += GRAVITY * 2
func _on_hurtbox_area_entered(area):
	if area.get_parent().is_in_group("lethal"):
		death()
	elif area.get_parent().is_in_group("checkpoint"):
		area.get_parent().activate()
	elif area.get_parent().is_in_group("teleporter"):
		area.get_parent().teleport()
		
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():

	print(position)
	print($Camera2D.position)
	if position.y < 324 and position.y > 0:
		if position.x < $Camera2D.position.x:
			global.current_room.x -= 1
		elif position.x > $Camera2D.position.x:
			global.current_room.x += 1
			
	else:
		if position.y > $Camera2D.position.y:
			global.current_room.y += 1
		elif position.y < $Camera2D.position.y:
			global.current_room.y -= 1

# goofy aah code
