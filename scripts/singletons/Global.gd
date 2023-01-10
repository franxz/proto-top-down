extends Node

var player: Player
var root_node: Node2D

# angle_rad: angle in radians from the right
func Vector2_from_angle(angle_rad: float) -> Vector2:
	return Vector2(cos(angle_rad), sin(angle_rad))

func call_after_timeout(target: Object, method: String, wait_time: float, binds := []) -> void:
	var timer = get_tree().create_timer(wait_time)
	timer.connect("timeout", target, method, binds)
