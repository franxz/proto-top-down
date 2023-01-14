extends Reference
class_name WeaponBase

var weapon_node : Node2D = null
var shot_scene : PackedScene = null

func init(weapon_node_: Node2D, shot_scene_: PackedScene):
	weapon_node = weapon_node_
	shot_scene = shot_scene_


func get_shot_origin(angle: float, dist_from_center := 0) -> Vector2:
  var dir : Vector2 = Global.Vector2_from_angle(angle)
  return weapon_node.global_position + dir * dist_from_center


func create_shot(angle: float, position: Vector2) -> void:
	var shot := shot_scene.instance()
	shot.init(position, angle)
	Global.root_node.add_child(shot)