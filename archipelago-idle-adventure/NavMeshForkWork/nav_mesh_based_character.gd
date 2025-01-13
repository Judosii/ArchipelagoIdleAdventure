extends CharacterBody2D

var speed = 300
var accel = 7

@onready var nav : NavigationAgent2D = $NavigationAgent2D

func _ready():
	# Make sure to wait for the first physics frame so the NavigationServer can sync
	await get_tree().physics_frame
	
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta):
	var direction = Vector3()
	
	nav.target_position = get_global_mouse_position()
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()
