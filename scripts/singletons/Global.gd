extends Node

var player: Player
var root_node: Node2D

# angle_rad: angle in radians from the right
func Vector2_from_angle(angle_rad: float) -> Vector2:
	return Vector2(cos(angle_rad), sin(angle_rad))


func set_timeout(target: Object, method: String, wait_time: float, binds := []) -> void:
	var timer = get_tree().create_timer(wait_time)
	timer.connect("timeout", target, method, binds)


func set_interval(target: Object, method: String, wait_time: float, binds := []) -> void: 
	var timer := Timer.new()
	timer.wait_time = wait_time
	timer.connect("timeout", target, method, binds)
	target.add_child(timer)
	timer.start()
