extends HBoxContainer

@export var line_color: Color = Color(0.4, 0.4, 0.4, 1.0)
@export var line_width: float = 4.0

func _ready() -> void:
	sort_children.connect(queue_redraw)

func _draw() -> void:
	var valid_nodes: Array[Control] = []
	for child in get_children():
		if child is Control and child.visible:
			valid_nodes.append(child)
			
	if valid_nodes.size() < 2:
		return
		
	for i in range(valid_nodes.size() - 1):
		var node_a = valid_nodes[i]
		var node_b = valid_nodes[i + 1]
		
		var center_a = node_a.position + (node_a.size / 2.0)
		var center_b = node_b.position + (node_b.size / 2.0)
		
		var padding_a = (node_a.size.x / 2.0) + 2.0
		var padding_b = (node_b.size.x / 2.0) + 2.0
		
		var dir_vec = (center_b - center_a).normalized()
		
		var precise_start = center_a + (dir_vec * padding_a)
		var precise_end = center_b - (dir_vec * padding_b)
		
		draw_line(precise_start, precise_end, line_color, line_width)
