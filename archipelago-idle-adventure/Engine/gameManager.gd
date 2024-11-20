class_name GameManager extends Node2D

# the player will send info about all nodes he encounters. They will be stored in these arrays :
var nodesThatCanBeExplored : Array[MovementNodes] # Log of all nodes found currently
var nodesThatHaveBeenExplored : Array[MovementNodes] # Nodes that have been explored
var nodesUnexplored : Array[MovementNodes] # Remainder of what to explore
var aStar2D : AStar2D 

func RefreshLists(arrivedToNode : MovementNodes):
	nodesThatHaveBeenExplored.append(arrivedToNode)
	# just arrived at node, it has now been explored.
	var possibleNewNodes : Array[MovementNodes] = arrivedToNode.connectedNodes
	# Get all connections of the node
	for i in possibleNewNodes.size():
		# For all the connections it has...
		if nodesThatCanBeExplored.has(possibleNewNodes[i]) == false:
			# If it's not one that's already known of :
			nodesThatCanBeExplored.append(possibleNewNodes[i])
			# Add to the list of nodes to be potentially visited
			AddtoAStar(ReturnEntryFromList(arrivedToNode),ReturnEntryFromList(possibleNewNodes[i]),possibleNewNodes[i].position)
			#Add to the AStar path finding the new node, and its position, as well as connect it
			# Give the arrivedToNode to say what it is connected to

	nodesUnexplored.clear()
	for i in nodesThatCanBeExplored.size():
		#for o in nodesThatHaveBeenExplored:
		if nodesThatHaveBeenExplored.has(nodesThatCanBeExplored[i]) == false:
			nodesUnexplored.append(nodesThatCanBeExplored[i])

func ReturnEntryFromList(what : MovementNodes,list : Array = nodesThatCanBeExplored)-> int:
	if list.find(what) != -1:
		return list.find(what)
	else:
		printerr("Entry was not in list !")
		return -1

func AddtoAStar(id_arrivedAt : int, id_foundNode:int, pos_foundNode: Vector2):
	 #feed IDs from nodesThatCanBeExplored, so that the ID stays consistent.
	aStar2D.add_point(id_foundNode, pos_foundNode)
	aStar2D.connect_points(id_arrivedAt, id_foundNode)

func RequestPath(startNode: MovementNodes, endNode: MovementNodes) -> Array[MovementNodes]:
	var idStartNode : int = nodesThatCanBeExplored.find(startNode)
	var idEndNode : int = nodesThatCanBeExplored.find(endNode)
	return aStar2D.get_point_path(idStartNode, idEndNode)
