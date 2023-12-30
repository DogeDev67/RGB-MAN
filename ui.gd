extends Control
@onready var global = get_node("/root/Global")


func _process(delta):
	$Panel/Label.text = global.current_room_name[global.current_room.x]
	$Panel/invCheck.text = "INVINCIBLE: " + str(global.playerInvincible)
