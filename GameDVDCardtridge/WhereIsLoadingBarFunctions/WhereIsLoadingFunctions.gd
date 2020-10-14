extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func QuitNauYo():
	print("\n\nQuit Nau Yo\n\n")
	emit_signal("ChangeDVD_Exec")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GenLoad_ReallyQuit():
	print("\n\n Goodbye from Loading Bar")
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.
