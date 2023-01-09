extends Node

var player
var root_node

func Vector2_from_angle(angle_rad: float) -> Vector2:
	return Vector2(cos(angle_rad), sin(angle_rad))