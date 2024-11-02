extends Control  # Ensure this matches your main node type

# Reference the UI nodes
@onready var points_label = $PointsLabel

# Game variables
var points = 0
@onready var tree_texture_sapling = preload("res://sapling.png")
@onready var tree_texture_full = preload("res://adulttree.png")
@onready var tree_texture_fallen = preload("res://oldtree.png")
var last_tree = null  # Variable to store the last created tree
var growth_stage = 0  # Tracks growth stage

# Function that runs when the scene is loaded
func _ready():
	points_label.text = "Trees Saved: 0"
	print("Script is running correctly")

var click_counter = 0  # Counter to track clicks

# Function to increment the click counter and award points for every 3 clicks
func increment_points():
	click_counter += 1  # Increment the click counter
	if click_counter == 3:
		points += 1  # Award a point for every 3 clicks
		points_label.text = "Trees Saved: " + str(points)
		click_counter = 0  # Reset the click counter

# Function to increment points
#func increment_points():
	#points += 1
	#points_label.text = "Trees Saved: " + str(points)

# Function connected to the button's pressed signal
func _on_AddPointsButton_pressed():
	increment_points()

# Detect mouse click and place a tree at the click position
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if last_tree == null:
			place_tree(get_global_mouse_position())
		else:
			grow_tree()

# Function to place a tree sprite at the specified position
func place_tree(position):
	# Remove the last tree if it exists
	if last_tree != null:
		last_tree.queue_free()

	# Create a new tree sprite
	var tree_sprite = Sprite2D.new()
	tree_sprite.texture = tree_texture_sapling
	tree_sprite.position = position
	add_child(tree_sprite)

	# Store the reference to the last created tree and reset growth stage
	last_tree = tree_sprite
	growth_stage = 0

# Function to grow the tree by changing its texture
func grow_tree():
	if growth_stage == 0:
		last_tree.texture = tree_texture_full  # Change to full tree texture
	elif growth_stage == 1:
		fall_over_tree()  # Call the fall function when the tree is at its final stage
	growth_stage += 1  # Increment growth stage

# Function to make the tree fall over and change its texture
func fall_over_tree():
	if last_tree != null:
		last_tree.texture = tree_texture_fallen  # Change to fallen tree texture
		growth_stage = 0  # Reset the growth stage for a new tree
		last_tree = null  # Allow for placing a new tree
