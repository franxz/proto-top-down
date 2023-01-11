extends Node2D

var shot_scene := preload("res://scenes/shot/Shot.tscn")
var weapon_base_script := preload("res://scripts/WeaponBase.gd")

var weapon_base = weapon_base_script.new() 
var cooldown := 1 # Time between shot spreads in seconds
var shot_interval := 0.04 # Time between shots in seconds
var shot_spread := PI / 7 # Spread of the shots in radians
var shot_count := 5 # Number of shots in the spray
var dist_from_center := 48

onready var attack_range := get_node("AttackRange")

func _ready():
	var timer := Timer.new()
	timer.wait_time = cooldown
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()


func _on_timer_timeout():
	var closest_enemy : Node = attack_range.get_closest_enemy()
	if closest_enemy:
		closest_enemy.debug_highlight()
		var dir : Vector2 = (closest_enemy.position - global_position).normalized()
		var start_angle := dir.angle() - shot_spread / 2
		var angle_step := shot_spread / (shot_count - 1)
		for i in range(shot_count):
			var angle := start_angle + angle_step * i
			weapon_base.create_shot(shot_scene, weapon_base.get_shot_origin(global_position, angle, dist_from_center), angle) # you can also use same origin for all the shots
			# Add a slight delay before creating the next shot (MG effect)
			if i < shot_count - 1:
				yield(get_tree().create_timer(shot_interval), "timeout")
