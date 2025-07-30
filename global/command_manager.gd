extends Node

var output_string: String = ""
var current_command: String = ""

var player_inventory: Player_Inventory

var commands: Dictionary[String, Callable] = {
	"give" = give_command
}

func set_player_inventory(plr_inv: Player_Inventory):
	player_inventory = plr_inv

func run_command(input_command: String)-> bool:
	current_command = input_command
	
	var command_arguements: PackedStringArray = commands_to_arguement(input_command)
	
	#print("printing current args ->" + str(command_arguements))
	
	if command_arguements:
		if commands.has(command_arguements[0]):
			
			commands[command_arguements[0]].call(command_arguements)
			
			return true
		else:
			return false
			print("the command deos not exists")
			
	else:
		return false
		print("command is empty")

func commands_to_arguement(in_command: String)-> PackedStringArray:
	var striped_command: String = in_command.strip_edges()
	var arg_array: PackedStringArray = striped_command.split(" ", true).duplicate()
	return arg_array
	


func give_command(input_commands: PackedStringArray)-> void: ## Give command got 3 arguement including "give" "give, item_type, item_count"
#	print("executing give command")
	
	if input_commands[0] == "give" and input_commands.size() >= 2 and input_commands.size() < 4:
		var item: Item = ItemManger.load_item(input_commands[1])
		var item_count: int = 1
		
		if item == null:
			output_string = "--\n--" + "--'" + current_command +  "'\n--" + ">> item does not exists <<"
			return
		
		if input_commands.size() == 3:
			item_count = int(input_commands[2])
			if item_count == 0:
				output_string = "--\n--" + "--'" + current_command +  "'\n--" + ">> item does not exists <<"
				return
		
		current_command = ""
		player_inventory.add_item(item, item_count)
		#print(output_string)
	else:
		print("did not meet give command format -->\n ---" + str(input_commands) + "---")
		
				
