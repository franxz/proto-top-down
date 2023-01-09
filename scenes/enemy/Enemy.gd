extends RigidBody2D

var max_force = 800
var max_speed = 400
var max_health = 3
var current_health = max_health


func _ready():
  add_to_group('enemies')


func _physics_process(delta):
  var player = Global.player
  var desired_velocity = (player.position - position).normalized() * max_speed
  var steering_force = (desired_velocity - linear_velocity).clamped(max_force)
  applied_force = steering_force


func _integrate_forces(state):
  state.linear_velocity = state.linear_velocity.clamped(max_speed)
  

func take_damage(impulse):
  apply_central_impulse(impulse)
  current_health -= 1
  if current_health <= 0:
	  queue_free()
