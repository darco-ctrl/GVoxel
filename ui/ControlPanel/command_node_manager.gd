## Command Text Edit
extends Control

@export var command_input_node: TextEdit
@export var command_output_node: TextEdit

func _ready() -> void:
	command_input_node.visible = false
	command_output_node.visible = false

func _process(delta: float) -> void:

	if Input.is_action_just_pressed("command_input") and !command_input_node.has_focus():
		command_input_node.grab_focus()
		GameManager.is_ui_open = true
		command_input_node.visible = true
		
	elif Input.is_action_just_pressed("enter_command") and command_input_node.has_focus():
		command_input_node.release_focus()
		command_input_node.visible = false
		GameManager.is_ui_open = false
		
		command_output_node.text += "\n" + command_input_node.text.strip_edges()
		
		#print("sending request to run comand -> " +  command_output_node.text)
		CommandManager.run_command(command_input_node.text)
		
		command_input_node.text = ""
	
	if Input.is_action_just_pressed("show_command_output"):
		if command_output_node.visible:
			command_output_node.visible = false
		
		else:
			command_output_node.visible = true
	
