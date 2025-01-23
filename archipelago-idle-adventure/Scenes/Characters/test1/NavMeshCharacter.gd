class_name NavMeshCharacter extends CharacterBody2D

signal moving
signal foundItem

@export var active : bool
@export var speed = 300

@export var list : Array[Node2D]
var i: int = 0

@export_category("Nodes")
@export var nav : NavigationAgent2D
@export var anim : AnimationPlayer
@export var locationParent: Node2D
var accel = 7

func _ready() -> void:
	list.append_array(locationParent.get_children())

func _physics_process(delta):
	if active:
		MoveCode(delta)
	else:
		anim.play("Idle")

func MoveCode(delta : float):
		var direction = Vector3()
		
		#nav.target_position = get_global_mouse_position()
		nav.target_position = list[i].global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()
		moving.emit()
		if position.distance_squared_to(list[i].global_position) < 10:
			i +=1
		if i > list.size()-1:
			active = false
			return

func _on_moving() -> void:
	if velocity != Vector2.ZERO && anim.current_animation == "Walk":
		return
	anim.play("Walk")

func ReceivedItem():
	anim.play("ReceivedItem")

func FoundItem():
		anim.play("SendingItem")
