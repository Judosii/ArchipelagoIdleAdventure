extends _State

# Wait until an item is received.
func ActivateState():
	super.ActivateState()
	GAMEMANAGER.connect("ItemReceived", CheckIfPathIsUnlocked)

func DeactivateState():
	GAMEMANAGER.disconnect("ItemReceived", CheckIfPathIsUnlocked)

func CheckIfPathIsUnlocked():
	print("has, obtained item !\n")
	if GAMEMANAGER.IsGoMode():
		print("-> character is go mode !")
		set_physics_process(false)
	elif GAMEMANAGER.CheckPreviouslyUnavailablePaths():
		print("-> not go mode yet, checking a new path")
		set_physics_process(false)
	else:
		print("-> need to wait for an item.")
		set_physics_process(false)
		#Needs to wait for an item.
