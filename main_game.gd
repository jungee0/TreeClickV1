extends Control  # Ensure this matches your main node type

# Reference the UI nodes
@onready var points_label = $PointsLabel

# Game variables
var points = 0
@onready var tree_texture = preload("res://OakTree.jpg")  # Replace with your tree image path
var last_tree = null  # Variable to store the last created tree

# Function that runs when the scene is loaded
func _ready():
	points_label.text = "Trees Saved: 0"
	print("Script is running correctly")

# Function to increment points
func increment_points():
	points += 1
	points_label.text = "Trees Saved: " + str(points)

# Function connected to the button's pressed signal
func _on_AddPointsButton_pressed():
	increment_points()

# Detect mouse click and place a tree at the click position
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		place_tree(get_global_mouse_position())

# Function to place a tree sprite at the specified position and remove the previous tree
func place_tree(position):
	# Remove the last tree if it exists
	if last_tree != null:
		last_tree.queue_free()

	# Create a new tree sprite
	var tree_sprite = Sprite2D.new()
	tree_sprite.texture = tree_texture
	tree_sprite.position = position
	add_child(tree_sprite)

	# Store the reference to the last created tree
	last_tree = tree_sprite
