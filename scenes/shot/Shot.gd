extends Area2D

var dir := Vector2()
var speed := 400
var lifetime := 5
var dmg_impulse := 1000
var destroyed = false
var color: Color

onready var sprite_node = get_node("Sprite")

func init(position_: Vector2, angle_rad: float, color_: Color) -> void:
	position = position_
	rotation = angle_rad
	dir = Global.Vector2_from_angle(angle_rad)
	color = color_


func _ready():
	sprite_node.modulate = color
	connect("body_entered", self, "_on_Area2D_body_entered")
	Global.set_timeout(self, "_destroy", lifetime)


func _physics_process(delta):
  if dir:
	  position += dir * speed * delta


func _on_Area2D_body_entered(body):
	if !destroyed and body.is_in_group("enemies"):
		body.take_damage(dir * dmg_impulse)
		_destroy()


func _destroy() -> void:
	destroyed = true
	queue_free()
