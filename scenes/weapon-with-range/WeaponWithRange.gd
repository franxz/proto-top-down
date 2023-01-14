extends Node2D

var shot_scene := preload("res://scenes/shot/Shot.tscn")

var weapon_base = WeaponBase.new() 
var shot_color = Color.fuchsia
var on_cooldown := false
var cooldown := 2.5 # Time between shot spreads in seconds
var shot_interval := 0.04 # Time between shots in seconds
var shot_spread := PI / 7 # Spread of the shots in radians
var shot_count := 12 # Number of shots in the spray
var dist_from_center := 48

onready var attack_range := get_node("AttackRange")

func _ready():
	attack_range.connect("body_entered", self, "_on_enemy_in_range")
	weapon_base.init(self, shot_scene)


func _on_enemy_in_range(enemy: Node) -> void:
	if !on_cooldown:
		_shoot(enemy)
		_reset_cooldown()


func _cooldown_finished() -> void:
	on_cooldown = false
	var closest_enemy : Node = attack_range.get_closest_enemy()
	if closest_enemy:
		_shoot(closest_enemy)
		_reset_cooldown()


func _reset_cooldown():
	on_cooldown = true
	Global.set_timeout(self, "_cooldown_finished", cooldown)


func _shoot(enemy: Node) -> void:
	var dir : Vector2 = (enemy.position - global_position).normalized()
	var start_angle := dir.angle() - shot_spread / 2
	var angle_step := shot_spread / (shot_count - 1)
	for i in range(shot_count):
		var angle := start_angle + angle_step * i
		weapon_base.create_shot(angle, weapon_base.get_shot_origin(angle, dist_from_center)) # you can also use same origin for all the shots
		# Add a slight delay before creating the next shot (MG effect)
		if i < shot_count - 1:
			yield(get_tree().create_timer(shot_interval), "timeout")
