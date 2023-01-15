extends Node2D

var enemy_scene := preload("res://scenes/enemy/Enemy.tscn")

var wave_interval := 2
var wave_enemies := 5

onready var camera_node = get_node("Camera2D")

func _ready():
	Global.root_node = self
	Global.set_interval(self, "_create_wave", wave_interval)


func _create_wave():
	for _i in range(wave_enemies):
		add_child(_gen_enemy_at_view_border())


func _gen_enemy_at_view_border() -> Node:
	var visible_rect_size := get_viewport().get_visible_rect().size
	visible_rect_size.x *= camera_node.zoom.x
	visible_rect_size.y *= camera_node.zoom.y
	
	var pos := visible_rect_size
	var horizontal := round(randf())
	if (horizontal):
		pos.x *= round(randf())
		pos.y *= randf()
	else:
		pos.x *= randf()
		pos.y *= round(randf())
	
	var enemy := enemy_scene.instance()
	enemy.init(pos - visible_rect_size / 2)
	return enemy
