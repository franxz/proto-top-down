extends Node2D

var shot_scene := preload("res://scenes/shot/Shot.tscn")

onready var attack_range := get_node("AttackRange")

var cooldown := 1 # Time between shot spreads in seconds
var shot_interval := 0.04 # Time between shots in seconds
var shot_spread := PI / 7 # Spread of the shots in radians
var shot_count := 5 # Number of shots in the spray
var dist_from_center := 48

func _ready():
	var timer := Timer.new()
	timer.wait_time = cooldown
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()


func _on_timer_timeout():
	var closest_enemy : Node = attack_range.get_closest_enemy()
	if closest_enemy:
		var dir : Vector2 = (closest_enemy.position - global_position).normalized()
		var start_angle := dir.angle() - shot_spread / 2
		var angle_step := shot_spread / (shot_count - 1)
		for i in range(shot_count):
			var angle := start_angle + angle_step * i
			_create_shot_from_angle(angle) # you can also use _create_shot and use the same origin for all the shots
			# Add a slight delay before creating the next shot (MG effect)
			if i < shot_count - 1:
				yield(get_tree().create_timer(shot_interval), "timeout")


# TODO: extract this to a common component 👇
func _create_shot_from_angle(angle: float) -> void:
	var dir : Vector2 = Global.Vector2_from_angle(angle)
	_create_shot(global_position + dir * dist_from_center, angle)


func _create_shot(position: Vector2, angle: float) -> void:
	var shot := shot_scene.instance()
	shot.init(position, angle)
	Global.root_node.add_child(shot)
# TODO: extract this to a common component 👆
