extends KinematicBody2D
class_name Player

var weapon_scene = preload("res://scenes/weapon/Weapon.tscn")
var weapon_with_range_scene = preload("res://scenes/weapon-with-range/WeaponWithRange.tscn")

var speed = 400
var equipped_weapons

export var debug_can_shoot := true

func _ready():
	Global.player = self
	equipped_weapons  = Node2D.new()
	add_child(equipped_weapons)
	if !debug_can_shoot:
		return
	add_weapon(weapon_scene.instance())
	add_weapon(weapon_with_range_scene.instance())


func _physics_process(delta):
	var horizontal_input = Input.get_axis("ui_left", "ui_right")
	var vertical_input = Input.get_axis("ui_up", "ui_down")

	var velocity = Vector2()
	if horizontal_input != 0 or vertical_input != 0:
		velocity = Vector2(horizontal_input, vertical_input).normalized() * speed

	move_and_slide(velocity)


func add_weapon(weapon):
	equipped_weapons.add_child(weapon)
