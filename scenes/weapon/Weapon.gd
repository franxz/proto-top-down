extends Node2D

var shot_scene := preload("res://scenes/shot/Shot.tscn")

var weapon_base = WeaponBase.new()
var cooldown := 0.5
var shot_count := 5
var dist_from_center := 48
var start_angle := 0.0

func _ready():
	weapon_base.init(self, shot_scene)
	Global.set_interval(self, "_shoot", cooldown)


func _process(delta):
	start_angle = start_angle + 0.5 * delta


func _shoot():
	var angle_diff := 2 * PI / shot_count
	for i in range(shot_count):
		var angle = start_angle + angle_diff * i
		weapon_base.create_shot(angle, weapon_base.get_shot_origin(angle, dist_from_center))
