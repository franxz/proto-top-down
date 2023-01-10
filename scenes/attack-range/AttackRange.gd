extends Area2D

var enemies := []

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node):
	if body.is_in_group("enemies"):
		enemies.append(body)


func _on_body_exited(body: Node):
	if body.is_in_group("enemies"):
		enemies.erase(body)


func get_closest_enemy() -> Node:
	if enemies.size():
		var closest_enemy = enemies[0]
		if enemies.size() == 1:
			return closest_enemy
		var closest_distance = position.distance_squared_to(closest_enemy.position)
		for i in range(1, enemies.size()):
			var enemy = enemies[i]
			var distance = position.distance_squared_to(enemy.position)
			if distance < closest_distance:
				closest_enemy = enemy
				closest_distance = distance
		return closest_enemy
	else:
		return null
