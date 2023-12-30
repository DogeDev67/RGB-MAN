extends Node2D

func _ready():
	$AnimationPlayer.play("booting")

func _physics_process(delta):

	if !$AnimationPlayer.is_playing():
		get_tree().change_scene_to_file("res://main_menu.tscn")
