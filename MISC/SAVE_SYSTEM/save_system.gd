extends Node

const default_save_path = "user://sauvegarde.data"
const SECURITY_CODE = "524dddbd-d5ba-4619-8366-93b56ce7ca37"
#Sauvegarde et chargement d'anciennes données

func load_values():
	if FileAccess.file_exists(default_save_path):
		var file = FileAccess.open_encrypted_with_pass(default_save_path,FileAccess.WRITE,SECURITY_CODE)
		if file == null:
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			return
		
		# Load the data into the corresponding fields below
		# Example :
		# player.health = data.player.health
	emit_signal("loaded")

func save_variables():
	var file = FileAccess.open_encrypted_with_pass(default_save_path,FileAccess.WRITE,SECURITY_CODE)
	if file == null:
		return
	
	# Vector2 are not compatible, break them up into 2 variables.
	var data : Dictionary
	
	var json_string = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()
