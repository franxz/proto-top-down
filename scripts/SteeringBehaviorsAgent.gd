extends Reference
class_name SteeringBehaviorsAgent

# TODO: use delta in the steering force calc?
# TODO: add remove_behavior

enum BEHAVIORS { SEEK, OBSTACLE_AVOIDANCE }

var behaviors = []
var behaviors_data = []
var behaviors_weights = []

var agent_node : RigidBody2D = null
var max_force : float
var max_speed : float

func init(agent_node_ : RigidBody2D, max_force_: float, max_speed_: float) -> void:
	agent_node = agent_node_
	max_force = max_force_
	max_speed = max_speed_

func physics_process(_delta: float) -> void:
	var steering_force := Vector2.ZERO
	for i in range(behaviors.size()):
		steering_force += _call_behavior(behaviors[i], behaviors_data[i]) * behaviors_weights[i]
	agent_node.applied_force = steering_force.limit_length(max_force)


func integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.linear_velocity = state.linear_velocity.limit_length(max_speed)


func _add_behavior(behavior: int, data: Object, weight: float) -> int:
	behaviors.append(behavior)
	behaviors_data.append(data)
	behaviors_weights.append(weight)
	return behaviors.size() - 1


func _call_behavior(behavior: int, data) -> Vector2:
	match behavior:
		BEHAVIORS.SEEK:
			return _seek(data as SeekData)
		BEHAVIORS.OBSTACLE_AVOIDANCE:
			return _obstacle_avoidance(data as ObstacleAvoidanceData)
	return Vector2.ZERO


##############################
# STEERING BEHAVIORS (DATA)
##############################
class SeekData:
	var seek_target : Node2D

class ObstacleAvoidanceData:
	var agent_area : Area2D
	var obstacles_layer : int


##############################
# STEERING BEHAVIORS (INIT)
##############################
func seek(target: Node2D, weight := 1.0) -> int:
	var data = SeekData.new()
	data.seek_target = target
	return _add_behavior(BEHAVIORS.SEEK, data, weight)


 # obstacles_layer -> collision layer of the obstacles
func obstacle_avoidance(agent_radius: float, obstacles_layer: int, weight := 1.0) -> int:
	var shape = RectangleShape2D.new() # TODO: use circle shape
	shape.extents = Vector2(agent_radius, agent_radius)
	
	var collision_shape = CollisionShape2D.new()
	collision_shape.position = Vector2.ZERO # TODO: check if this is necessary
	collision_shape.shape = shape

	var agent_area = Area2D.new()
	agent_area.position = Vector2.ZERO # TODO: check if this is necessary
	agent_area.collision_layer = 0 # TODO: check if this is necessary
	agent_area.collision_mask = 4
	
	agent_node.add_child(agent_area)
	agent_area.add_child(collision_shape)
	
	var data = ObstacleAvoidanceData.new()
	data.agent_area = agent_area
	data.obstacles_layer = obstacles_layer
	return _add_behavior(BEHAVIORS.OBSTACLE_AVOIDANCE, data, weight)


##############################
# STEERING BEHAVIORS (PROCESS)
##############################
func _seek(data: SeekData) -> Vector2:
	var desired_velocity = (data.seek_target.global_position - agent_node.global_position).normalized() * max_speed
	return desired_velocity - agent_node.linear_velocity


func _obstacle_avoidance(data: ObstacleAvoidanceData) -> Vector2:
	var collider_position = null

	if data.agent_area.get_overlapping_areas().size() > 0:
		collider_position = data.agent_area.get_overlapping_areas()[0].global_position
	else:
		var space_state = agent_node.get_world_2d().direct_space_state
		var raycast_result = space_state.intersect_ray(agent_node.global_position, agent_node.global_position + agent_node.linear_velocity, [], data.obstacles_layer, false, true) # TODO: add option to check bodies?
		if raycast_result:
			collider_position = raycast_result.collider.global_position

	if !collider_position:
		return Vector2.ZERO
	
	var right_vector = agent_node.linear_velocity.rotated(PI / 2)
	var steering_force = (collider_position - agent_node.global_position).project(right_vector)
	return steering_force.normalized() * max_force * (-1) # TODO: improve this calc?
