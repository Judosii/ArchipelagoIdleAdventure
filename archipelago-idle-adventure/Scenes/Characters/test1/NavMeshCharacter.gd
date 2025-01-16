class_name NavMeshCharacter extends CharacterBody2D

signal moving
signal foundItem

@export var active : bool
@export var speed = 300

@export_category("Nodes")

@export var nav : NavigationAgent2D
@export var anim : AnimationPlayer
var accel = 7

func _physics_process(delta):
	if active:
		var direction = Vector3()
		
		nav.target_position = get_global_mouse_position()
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()
		moving.emit()
	else:
		anim.play("Idle")

func _on_moving() -> void:
	if velocity != Vector2.ZERO && anim.current_animation == "Walk":
		return
	anim.play("Walk")

func ReceivedItem():
	anim.play("ReceivedItem")

func FoundItem():
		anim.play("SendingItem")
