extends Label3D

var state : bool = false

func pull():
	if state:
		state = false
		text = "0\n" + text.substr(0, text.length()-2)
	else:
		state = true
		text = "|\n" + text.substr(0, text.length()-2)
	
