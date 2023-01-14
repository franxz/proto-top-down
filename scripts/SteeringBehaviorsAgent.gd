extends Reference
class_name SteeringBehaviorsAgent

# this could be improved to:
# - select different behaviors
# - combine them with weights

var agent_node : RigidBody2D = null
var seek_target : Node2D = null
var max_force: float
var max_speed: float

func init(agent_node_ : RigidBody2D, max_force_: float, max_speed_: float, seek_target_: Node2D) -> void:
	agent_node = agent_node_
	max_force = max_force_
	max_speed = max_speed_
	seek_target = seek_target_


func physics_process(_delta: float) -> void:
	var desired_velocity = (seek_target.global_position - agent_node.global_position).normalized() * max_speed
	var steering_force = (desired_velocity - agent_node.linear_velocity).limit_length(max_force)
	agent_node.applied_force = steering_force


func integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.linear_velocity = state.linear_velocity.limit_length(max_speed)
