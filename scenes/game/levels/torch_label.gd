extends Label

const FIRE_STRING = "\\%s/
I"

var is_flicker : bool = false

func _ready():
	while is_inside_tree():
		var random_time = randf()
		await get_tree().create_timer(random_time).timeout
		if is_flicker:
			is_flicker = false
			text = FIRE_STRING % "^"
		else:
			is_flicker = true
			text = FIRE_STRING % "'"
