extends Node
var destination : Vector2
@onready var player = load("/root/playground/player")
var current_room_name = ["GETTING READY...", "PILLARS", "JUMP OF DOOM", "TELEPORTERS ?", "CHIPTUNE"]
var current_room : Vector2
var SPAWN_POINT : Vector2
var destination_scene : String
var playerInvincible = false


func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -15)

func _process(delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		swap_fullscreen_mode()

		
func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _set_current_room(dir : int):
	current_room.x += dir



func teleport():
	player.position = destination
	pass
