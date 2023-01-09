extends Area2D

var dir = Vector2()
var speed = 400
var lifetime = 5
var dmg_impulse = 1000

func init(position_: Vector2, angle_rad: float) -> void:
  position = position_
  rotation = angle_rad
  dir = Global.Vector2_from_angle(angle_rad)


func _ready():
	connect("body_entered", self, "_on_Area2D_body_entered")
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()


func _physics_process(delta):
  if dir:
	  position += dir * speed * delta


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(dir * dmg_impulse)
		queue_free()
