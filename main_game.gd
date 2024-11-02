extends Control  # Ensure this matches your main node type

# Reference the UI nodes
@onready var points_label = $PointsLabel

# Game variables
var points = 0
@onready var tree_texture_sapling = preload("res://Resources/sapling.png")
@onready var tree_texture_adult = preload("res://Resources/adulttree.png")
@onready var tree_texture_old = preload("res://Resources/oldtree.png")
var last_tree = null  # Variable to store the last created tree
var click_counter = 0 # Tracks clicks for tree growth
var growth_stage = 0  # Tracks current growth stage of the tree
var grid_size = 64  # Size of each grid cell for placement
var occupied_slots = {}  # Dictionary to keep track of occupied grid slots

# Function that runs when the scene is loaded
func _ready():
	points_label.text = "Trees Saved: 0"
	print("Script is running correctly")

#var click_counter = 0  # Counter to track clicks

# Function to increment the click counter and award points for every 3 clicks
func increment_points():
	click_counter += 1  # Increment the click counter
	if click_counter == 3:
		points += 1  # Award a point for every 3 clicks
		points_label.text = "Trees Saved: " + str(points)
		click_counter = 0  # Reset the click counter

## Function to increment points
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

## Function to place a tree sprite at the specified position
#func place_tree(position):

# Function to place a tree sprite at the specified position (snapped to a grid)
func place_tree(position):
	# Snap the position to the nearest grid point
	var snapped_position = Vector2(
		round(position.x / grid_size) * grid_size,
		round(position.y / grid_size) * grid_size
	)

  # Check if the snapped position is already occupied
	if occupied_slots.has(snapped_position):
		print("Grid slot already occupied.")
		return  # Do not place a tree if the slot is occupied

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

	# Mark the grid slot as occupied
	occupied_slots[snapped_position] = true

## Function to grow the tree by changing its texture
#func grow_tree():
	#if growth_stage == 0:
		#last_tree.texture = tree_texture_adult  # Change to full tree texture
	#elif growth_stage == 1:
		#old_tree()  # Call the fall function when the tree is at its final stage
	#growth_stage += 1  # Increment growth stage
#
## Function to make the tree fall over and change its texture
#func old_tree():
	#if last_tree != null:
		#last_tree.texture = tree_texture_old  # Change to fallen tree texture
		#growth_stage = 0  # Reset the growth stage for a new tree
		#last_tree = null  # Allow for placing a new tree

# Function to grow the tree based on the number of clicks
func grow_tree():
	click_counter += 1  # Increment the click counter
	
	# Check growth stages based on the click counter
	if growth_stage == 0 and click_counter >= 10:
		last_tree.texture = tree_texture_adult  # Change to adult tree texture
		growth_stage = 1  # Move to the next stage
		click_counter = 0  # Reset the click counter
	elif growth_stage == 1 and click_counter >= 10:
		last_tree.texture = tree_texture_old  # Change to old tree texture
		growth_stage = 2  # Move to the final stage
		click_counter = 0  # Reset the click counter
	elif growth_stage == 2 and click_counter >= 0:
		old_tree()  # Call the fall function when fully grown
		click_counter = 1  # Reset the click counter

# Function to make the tree grow to final stage
func old_tree():
	if last_tree != null:
		last_tree.texture = tree_texture_old  # Change to fallen tree texture
		growth_stage = 0  # Reset the growth stage for a new tree
		last_tree = null  # Allow for placing a new tree
