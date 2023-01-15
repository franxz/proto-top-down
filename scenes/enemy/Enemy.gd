extends RigidBody2D

var max_health := 3
var current_health := max_health
var steer_agent = SteeringBehaviorsAgent.new()

onready var sprite_node : Sprite = get_node("Sprite")
onready var animation_node : AnimationPlayer = get_node("AnimationPlayer")

func init(position_: Vector2) -> void:
  position = position_


func _ready():
  add_to_group('enemies')
  steer_agent.init(self, 800, 500, Global.player)


func _physics_process(delta):
  steer_agent.physics_process(delta)


func _integrate_forces(state):
  steer_agent.integrate_forces(state)
  

func take_damage(impulse: Vector2) -> void:
  animation_node.play("take_damage")
  apply_central_impulse(impulse)
  current_health -= 1
  if current_health <= 0:
	  queue_free()


func debug_highlight() -> void:
  sprite_node.modulate = Color.yellow
