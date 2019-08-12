extends Node

# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var queue = preload("res://Scripts/resource_queue.gd").new()
var LoadSet
export var LoadingValue = 0 
export var ReadyToShow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	queue.start()
	#queue.queue_resource("res://manies.tscn",true)
	# Step
	#1 Press UP, Queue Loading Resource. wait 100
	#2 Press Left, Instance Loaded Resource. Loading bar goes 0 as the resource is instanced
	#3 Press Enter, Spawn the loaded Resource
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if queue.is_ready("res://manies.tscn"):
		ReadyToShow = true
		LoadingValue = queue.get_progress("res://manies.tscn") * 100
		# It will no longer ready when the resource gets instanced!
		#LoadSet = queue.get_resource("res://manies.tscn").instance()
		#print("ready")
		pass
	else:
		LoadingValue = queue.get_progress("res://manies.tscn") * 100
		#print("Unready")
		pass
	
	$Control/ProgressBar.value = LoadingValue
	pass

func ShowLevel():
	#LoadSet = queue.get_resource("res://manies.tscn").instance()
	$Spatial.add_child(LoadSet)
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if ReadyToShow:
			call_deferred("ShowLevel")
			pass
		pass
	
	if event.is_action_pressed("ui_down"):
		queue.cancel_resource("res://manies.tscn")
		pass
	
	if event.is_action_pressed("ui_up"):
		queue.queue_resource("res://manies.tscn",true)
		pass
	
	if event.is_action_pressed("ui_left"):
		LoadSet = queue.get_resource("res://manies.tscn").instance()
		pass
	pass
