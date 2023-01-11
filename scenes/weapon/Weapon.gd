extends Node2D

var shot_scene := preload("res://scenes/shot/Shot.tscn")
var weapon_base_script := preload("res://scripts/WeaponBase.gd")

var weapon_base = weapon_base_script.new()
var cooldown := 0.75
var shot_count := 5
var dist_from_center := 48
var start_angle := 0.0

func _ready():
	Global.set_interval(self, "_shoot", cooldown)


func _process(delta):
	start_angle = start_angle + 0.5 * delta


func _shoot():
	var angle_diff := 2 * PI / shot_count
	for i in range(shot_count):
		var angle = start_angle + angle_diff * i
		weapon_base.create_shot(shot_scene, weapon_base.get_shot_origin(global_position, angle, dist_from_center), angle)
