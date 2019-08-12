extends Node

# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html Loading Thread, resource_queue.gd
# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position Spawn new child into a node out of instanced resource
# https://www.youtube.com/watch?v=YMj2qPq9CP8 (Not Godot, Unity instead, Inspiration) How to make Loading Bar with Loading Scene Coroutine in Unity
# https://www.youtube.com/watch?v=9sHKaQBcgO8 (Unhelpful, No loading bar) Splash Screen Loadinger without bar
# https://www.youtube.com/watch?v=-x0M17IwG0s (Unhelpful, crude box spawn method) Load some boxes into a scene

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
		ReadyToShow = false
		LoadingValue = queue.get_progress("res://manies.tscn") * 100
		#print("Unready")
		pass
	
	if ReadyToShow:
		$Control/Panel/ReadyToShowCheck.pressed = true
		pass
	else:
		$Control/Panel/ReadyToShowCheck.pressed = false
		pass
	
	if LoadSet:
		$Control/Panel/LoadSetCheck.pressed = true
		pass
	else:
		$Control/Panel/LoadSetCheck.pressed = false
		pass
	
	$Control/ProgressBar.value = LoadingValue
	pass

func ShowLevel():
	#LoadSet = queue.get_resource("res://manies.tscn").instance()
	# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position
	$Spatial.add_child(LoadSet)
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		SpawnResource()
#		if ReadyToShow:
#			call_deferred("ShowLevel")
#			pass
		pass
	
	if event.is_action_pressed("ui_down"):
		CancelResource()
		pass
	
	if event.is_action_pressed("ui_up"):
		QueueResource()
		pass
	
	if event.is_action_pressed("ui_left"):
		InstanceResource()
		pass
	pass

func QueueResource():
	queue.queue_resource("res://manies.tscn",true)
	pass
func InstanceResource():
	LoadSet = queue.get_resource("res://manies.tscn").instance()
	pass
func SpawnResource():
	call_deferred("ShowLevel")
	pass
func CancelResource():
	queue.cancel_resource("res://manies.tscn")
	pass


func _on_ButtonA_pressed():
	QueueResource()
	pass # Replace with function body.

func _on_ButtonB_pressed():
	InstanceResource()
	pass # Replace with function body.

func _on_ButtonC_pressed():
	SpawnResource()
	pass # Replace with function body.

func _on_ButtonD_pressed():
	CancelResource()
	pass # Replace with function body.

func _notification(what):
	# https://docs.godotengine.org/en/3.1/tutorials/misc/handling_quit_requests.html
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$Control/QuitConfirmationDialog.popup()
		pass
	pass
	

func _on_ConfirmationDialog_confirmed():
	get_tree().quit()
	pass # Replace with function body.


func _on_QUITButton_pressed():
	$Control/QuitConfirmationDialog.popup()
	pass # Replace with function body.
