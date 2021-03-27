extends RichTextLabel
class_name BotChat
onready var ai_selector : AISelector = $"../AISelector"

func _ready():
	clear()

func _on_AISelector_item_selected(index):
	var txt = ai_selector.get_item_text(ai_selector.get_selected_id())
	chat_message("Switching to AI method: %s" % txt)
	

func chat_message(m : String):
	add_text(">")
	add_text(m)
	newline()
