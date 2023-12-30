extends Node
@export var particle = preload("res://clouds.tscn")
@export var queue_count = 2

var index = 0

func _ready():
	for i in range(queue_count):
		add_child(particle.instantiate())
		
		
func get_next_particle():
	return get_child(index)

func trigger():
	get_next_particle().emitting = true
	index = (index + 1) % queue_count
