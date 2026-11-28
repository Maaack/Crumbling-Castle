extends Control
## Control node that captures the mouse for games that require it. 
##
## Used for games that use the mouse to move the camera (ex. FPS or third-person shooters).

var prior_mouse_mode : Input.MouseMode

func _gui_input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and event is InputEventMouse:
		prior_mouse_mode = Input.mouse_mode
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(prior_mouse_mode)
