extends CharacterBody2D

@export var active : bool

var speed = 300
var accel = 7

@export var dest : Array[Node2D]
var index : int
@onready var nav : NavigationAgent2D = $NavigationAgent2D


func _physics_process(delta):
	if active:
		DoThing(delta)

func DoThing(delta : float):
	var direction = Vector3()
	nav.target_position = dest[index].global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func _on_navigation_agent_2d_navigation_finished():
	index+=1

func SetActive():
	active = true

func _on_button_pressed():
	SetActive()
