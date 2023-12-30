extends StaticBody2D

@export var destination_scene : String
@onready var global = get_node("/root/Global")



func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("player"):
		$interact.visible = true
		global.destination_scene = destination_scene
	print(global.destination_scene)


func _on_door_area_exited(area):
	if area.get_parent().is_in_group("player"):
		$interact.visible = false
