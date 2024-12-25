extends Control

@onready var table: TextEdit = %Table
@onready var original_text: TextEdit = %OriginalText
@onready var processed_text: TextEdit = %ProcessedText
@onready var option_button: OptionButton = %OptionButton

var russian_default_table := FileAccess.open("res://russian_default_table.txt", FileAccess.READ).get_as_text()
var english_default_table := FileAccess.open("res://english_default_table.txt", FileAccess.READ).get_as_text()

var substitutions: Dictionary

func _ready() -> void:
	_on_russian_default_pressed()


func _on_russian_default_pressed() -> void:
	table.text = russian_default_table


func _on_english_default_pressed() -> void:
	table.text = english_default_table


func _on_original_text_text_changed() -> void:
	var original = original_text.text
	
	var processed = ""
	
	for chr in original:
		if chr.to_upper() not in substitutions:
			processed += chr
			continue
		
		var is_lower_case = chr == chr.to_lower()
		
		if is_lower_case:
			chr = chr.to_upper()
			processed += substitutions[chr].to_lower()
		else:
			processed += substitutions[chr]
		
	processed_text.text = processed


func fill_substitutions_1():
	for line in table.text.split("\n"):
		if line.is_empty():
			continue
		
		if not line.contains("->"):
			continue
		
		var split = line.split("->")
		substitutions[split[0].strip_edges()] = split[1].strip_edges()

func fill_substitutions_2():
	for line in table.text.split("\n"):
		if line.is_empty():
			continue
		
		if not line.contains("->"):
			continue
		
		var split = line.split("->")
		substitutions[split[1].strip_edges()] = split[0].strip_edges()

func _on_table_text_changed() -> void:
	if option_button.selected == 0:
		fill_substitutions_1()
	else:
		fill_substitutions_2()
	_on_original_text_text_changed()


func _on_table_text_set() -> void:
	if option_button.selected == 0:
		fill_substitutions_1()
	else:
		fill_substitutions_2()
	_on_original_text_text_changed()


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		fill_substitutions_1()
	else:
		fill_substitutions_2()
	_on_original_text_text_changed()
