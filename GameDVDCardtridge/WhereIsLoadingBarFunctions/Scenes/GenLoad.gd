extends Node

# https://docs.godotengine.org/en/3.1/tutorials/io/background_loading.html Loading Thread, resource_queue.gd
# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position Spawn new child into a node out of instanced resource
# https://www.youtube.com/watch?v=YMj2qPq9CP8 (Not Godot, Unity instead, Inspiration) How to make Loading Bar with Loading Scene Coroutine in Unity
# https://www.youtube.com/watch?v=9sHKaQBcgO8 (Unhelpful, No loading bar) Splash Screen Loadinger without bar
# https://www.youtube.com/watch?v=-x0M17IwG0s (Unhelpful, crude box spawn method) Load some boxes into a scene

# https://godotengine.org/qa/41325/how-to-create-a-loading-screen
# https://godotengine.org/qa/30565/a-loading-bar-demo

# GLES2 if you wish it compatible for HTML5 unfortunately.
# enable ETC VRAM compression in Project setting, rendering, vram comrpession.

# a plugin just to do that now here https://github.com/NovemberDev/GodotAsyncSceneLoader
# This plugin adds SceneLoader Singleton. you just have to tell it to load this scene and then spawn the loaded resource from it to your node yay!
# it does that by sending a signal with a Dictionary containing, the path of your scene, loaded resource, INCLUDING THE INSTANCE TOO, and some props variable when you pass it this to the loader. usefull for special level parameter wow!
# it's there on Godot AssetLib too! it's `Scene Loader` `Asynchronous Scene Loader` something!

# Error on HTML5 if you redownload and run index.html
# this is due to security measure on some browser that disallow fetching external resource from URL that isn't HTTP or HTTPS.
# https://stackoverflow.com/questions/58128248/how-can-i-resolve-the-error-url-scheme-must-be-http-or-https-for-cors-reque
# https://stackoverflow.com/questions/58128248/how-can-i-resolve-the-error-url-scheme-must-be-http-or-https-for-cors-reque
# https://stackoverflow.com/questions/49971575/chrome-fetch-api-cannot-load-file-how-to-workaround/59925724#59925724
# https://godotforums.org/discussion/25208/failed-loading-index-pck-file
# https://docs.godotengine.org/en/latest/development/compiling/compiling_for_web.html
# use Live Server extension of VS code. https://github.com/ritwickdey/vscode-live-server
# open the folder containing index.html along with other files with VScode and then while in that tab, press that Go Live in bottom right
# now this will run mini server at designated port, broadcasting that index.html yay. and it works!
# after done, turn off mini server by click No symbol with Port number at bottom right.

# font used is Ubuntu & Twenty Four 16 segment display font yay! https://scruss.com/blog/2016/05/21/twentyfoursixteen-a-17-segment-alpha-lcd-font/

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ReallyQuit()

onready var queue = preload("res://Scripts/resource_queue.gd").new()
var LoadSet
export var LoadingValue = 0 
export var ReadyToShow = false
export var IReallyWantToQuit = false
export(String) var loadThisNamePls = "res://GameDVDCardtridge/WhereIsLoadingBarFunctions/Scenes/Fews.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_method("QuitNauYo"):
		$CanvasLayer/Control/QuitConfirmationDialog.dialog_text = "Are you sure to Change DVD?"
		pass
	else:
		$CanvasLayer/Control/QuitConfirmationDialog.dialog_text = "Are you sure to quit?"
		pass
	queue.start()
	#queue.queue_resource("res://manies.tscn",true)
	# Step
	#1 Press UP, Queue Loading Resource. wait 100
	#2 Press Left, Instance Loaded Resource. Loading bar goes 0 as the resource is instanced
	#3 Press Enter, Spawn the loaded Resource
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if queue.is_ready(loadThisNamePls):
		ReadyToShow = true
		LoadingValue = queue.get_progress(loadThisNamePls) * 100
		# It will no longer ready when the resource gets instanced!
		#LoadSet = queue.get_resource("res://manies.tscn").instance()
		#print("ready")
		pass
	else:
		ReadyToShow = false
		LoadingValue = queue.get_progress(loadThisNamePls) * 100
		#print("Unready")
		pass
	
	if ReadyToShow:
		$CanvasLayer/Control/VBoxContainer/StepContains/Panel/VBoxContainer/ReadyToShowCheck.pressed = true
		pass
	else:
		$CanvasLayer/Control/VBoxContainer/StepContains/Panel/VBoxContainer/ReadyToShowCheck.pressed = false
		pass
	
	if LoadSet:
		$CanvasLayer/Control/VBoxContainer/StepContains/Panel/VBoxContainer/LoadSetCheck.pressed = true
		pass
	else:
		$CanvasLayer/Control/VBoxContainer/StepContains/Panel/VBoxContainer/LoadSetCheck.pressed = false
		pass
	
	$CanvasLayer/Control/VBoxContainer/ProgressBar.value = LoadingValue
	pass

func ShowLevel():
	#LoadSet = queue.get_resource("res://manies.tscn").instance()
	# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position
	$Spatial/Spawns.add_child(LoadSet)
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		#SpawnResource()
#		if ReadyToShow:
#			call_deferred("ShowLevel")
#			pass
		pass
	
	if event.is_action_pressed("ui_down"):
		#CancelResource()
		pass
	
	if event.is_action_pressed("ui_up"):
		#QueueResource()
		pass
	
	if event.is_action_pressed("ui_left"):
		#InstanceResource()
		pass
	pass

func QueueResource():
	queue.queue_resource(loadThisNamePls,true)
	pass
func InstanceResource():
	LoadSet = queue.get_resource(loadThisNamePls).instance()
	pass
func SpawnResource():
	call_deferred("ShowLevel")
	pass
func CancelResource():
	queue.cancel_resource(loadThisNamePls)
	pass
func DeleteSpawns():
	for things in $Spatial/Spawns.get_children():
		things.free()
		pass
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
		if get_parent().has_method("QuitNauYo"):
			$CanvasLayer/Control/QuitConfirmationDialog.dialog_text = "Are you sure to shutdown Hexagon Engine?"
			pass
		$CanvasLayer/Control/QuitConfirmationDialog.popup()
		IReallyWantToQuit = true
		pass
	pass
	

func _on_ConfirmationDialog_confirmed():
	if get_parent().has_method("QuitNauYo"):
		get_parent().QuitNauYo()
		pass
	elif IReallyWantToQuit:
		#get_tree().quit()
		emit_signal("ReallyQuit")
	else:
		get_tree().quit()
	pass # Replace with function body.


func _on_QUITButton_pressed():
	$CanvasLayer/Control/QuitConfirmationDialog.popup()
	pass # Replace with function body.


func _on_ButtonD2_pressed():
	DeleteSpawns()
	pass # Replace with function body.


func _on_QuitConfirmationDialog_popup_hide():
	IReallyWantToQuit = false
	if get_parent().has_method("QuitNauYo"):
		$CanvasLayer/Control/QuitConfirmationDialog.dialog_text = "Are you sure to Change DVD?"
		pass
	else:
		$CanvasLayer/Control/QuitConfirmationDialog.dialog_text = "Are you sure to quit?"
	pass # Replace with function body.
