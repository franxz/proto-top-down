extends Area2D

var radius := 128
var color := Color.black

onready var shape_node = get_node("CollisionShape2D")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	shape_node.shape.radius = radius


func _on_body_entered(body: Node):
	if body.is_in_group("enemies"):
		body.queue_free()


func _draw():
	draw_circle(Vector2.ZERO, radius, color)
