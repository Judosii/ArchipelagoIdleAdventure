extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var nodesThatCanBeExplored : Array[Node2D]
var nodesThatHaveBeenExplored : Array[Node2D]
var nodesUnexplored : Array[Node2D]
@export var chosenUnexploredNode : Node2D
var travellingToNode : Node2D

func _physics_process(delta):
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	if position.distance_to(travellingToNode.position) < 1 :
		# arrived at node
		HasReachedNode(travellingToNode)
	move_and_slide()

func DecideNextNode():
	get_node("Label").text = str("final next node is :",chosenUnexploredNode,"\n immediate next node is : ", travellingToNode )
	var immediateNodes : Array[Node2D]
	

func HasReachedNode(arrivedAtNode: Node2D):
	var newNodes : Array[Node2D]
	for node in newNodes.size():
		print("this node is connected to ", newNodes.size())
		if node not in nodesThatCanBeExplored:
			nodesThatCanBeExplored.append(node)
		else:
			print(node, "already is list of can be explored")
	
	nodesUnexplored.clear()
	for node in nodesThatCanBeExplored.size():
		if node not in nodesThatCanBeExplored:
			nodesUnexplored.append(node)
	
