extends RigidBody2D
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = randi_range(0, 360)
	angular_velocity = speed * (rotation_degrees - 180) / 180
