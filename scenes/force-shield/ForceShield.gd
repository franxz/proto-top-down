extends Area2D

# just a simple implementation. Could be improved to:
# - allow regeneration
# - add player movement to the enemy impulse (push harder if moving towards it)

var dmg_impulse := 35
var max_hp := 25
var current_hp := max_hp
var color := Color.whitesmoke
var radius := 90

onready var shape_node = get_node("CollisionShape2D")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	shape_node.shape.radius = radius


func _on_body_entered(body: Node):
	if !current_hp:
		return
	if body.is_in_group("enemies"):
		body.take_damage((body.position - global_position) * dmg_impulse)
		_take_damage()


func _take_damage() -> void:
	current_hp -= 1
	color = lerp(Color.red, Color.whitesmoke, 1.0 * current_hp / max_hp)
	update()
	if !current_hp:
		queue_free()


func _draw():
	draw_circle(Vector2.ZERO, radius, color)
