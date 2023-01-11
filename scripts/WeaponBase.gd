extends Reference

func get_shot_origin(global_position: Vector2, angle: float, dist_from_center := 0) -> Vector2:
  var dir : Vector2 = Global.Vector2_from_angle(angle)
  return global_position + dir * dist_from_center


func create_shot(shot_scene: PackedScene, position: Vector2, angle: float) -> void:
	var shot := shot_scene.instance()
	shot.init(position, angle)
	Global.root_node.add_child(shot)