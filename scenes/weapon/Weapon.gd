extends Node2D

var shot_scene := preload("res://scenes/shot/Shot.tscn")

var shot_interval := 0.75
var shot_count := 5
var dist_from_center := 48
var start_angle := 0

func _ready():
	var timer := Timer.new()
	timer.wait_time = shot_interval
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()


func _process(delta):
	start_angle += 0.5 * delta


func _on_timer_timeout():
	var angle_diff := 2 * PI / shot_count
	for i in range(shot_count):
		_create_shot_from_angle(start_angle + angle_diff * i)


func _create_shot_from_angle(angle: float) -> void:
	var dir : Vector2 = Global.Vector2_from_angle(angle)
	_create_shot(global_position + dir * dist_from_center, angle)

func _create_shot(position: Vector2, angle: float) -> void:
		var shot := shot_scene.instance()
		shot.init(position, angle)
		Global.root_node.add_child(shot)
