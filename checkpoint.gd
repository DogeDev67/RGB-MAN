extends StaticBody2D
@onready var global = get_node("/root/Global")
var activated = false

func activate():
	if activated == false:
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.play("on")
		activated = true
		global.SPAWN_POINT = position
