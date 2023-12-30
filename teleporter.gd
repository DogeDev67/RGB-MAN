extends StaticBody2D
@onready var global = get_node("/root/Global")
@export var destination : Vector2

func _physics_process(delta):

	rotation_degrees += 1
	$destinationindicator.position = destination

func teleport():
	$CPUParticles2D.emitting = true
	$AudioStreamPlayer.play()
	global.destination = destination
	global.teleport()
	pass #teleport function is on the global script

