extends Node2D

var enemy_scene := preload("res://scenes/enemy/Enemy.tscn")

var wave_interval := 2
var wave_enemies := 5

func _ready():
	Global.root_node = self
	Global.set_interval(self, "_create_wave", wave_interval)


func _create_wave():
	for _i in range(wave_enemies):
		add_child(_gen_enemy_at_view_border())


func _gen_enemy_at_view_border() -> Node:
	var pos := get_viewport().get_visible_rect().size
	var horizontal := round(randf())
	if (horizontal):
		pos.x *= round(randf())
		pos.y *= randf()
	else:
		pos.x *= randf()
		pos.y *= round(randf())
	
	var enemy := enemy_scene.instance()
	enemy.init(pos)
	return enemy
