extends Area2D

# just a simple implementation. Could be improved to:
# - allow regeneration
# - add player movement to the enemy impulse (push harder if moving towards it)

var dmg_impulse := 35
var max_hp := 25
var current_hp := max_hp

onready var sprite_container_node := get_node("SpriteContainer")
onready var alpha_step : float = sprite_container_node.modulate.a / max_hp
onready var red_step : float = (1 - sprite_container_node.modulate.r) / max_hp

func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node):
	if !current_hp:
		return
	if body.is_in_group("enemies"):
		body.take_damage((body.position - global_position) * dmg_impulse)
		_take_damage()


func _take_damage() -> void:
	current_hp -= 1
	sprite_container_node.modulate.a -= alpha_step
	sprite_container_node.modulate.r += red_step
	if !current_hp:
		queue_free()
