extends Camera2D
@onready var global = get_node("/root/Global")
var screenwidth = 576
var screenheight = 324

func _process(delta):
	position.x = global.current_room.x * screenwidth
	position.y = global.current_room.y * screenheight
	pass
