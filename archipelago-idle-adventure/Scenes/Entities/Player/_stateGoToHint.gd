extends _State

@export var stateExplore : _State
@export var stateGoToClosest : _State

func StateFunctionality():
	print("reached hint state.")
	print("going to closest hinted location.")
	# functionality not implemented.
	character.set_physics_process(false)

#After reaching hinted location :
#	if at least one path, switch to explore.
#	if no paths, check if any paths left.
#		if paths > 1 : go to closest unexplored.
#		else: go to idle.
