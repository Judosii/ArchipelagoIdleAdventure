class_name NavMeshCharacter extends CharacterBody2D

@export var nav : NavigationAgent2D
var speed = 300
var accel = 7
var active : bool

func _physics_process(delta):
	if active:
		var direction = Vector3()
		
		nav.target_position = get_global_mouse_position()
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()
