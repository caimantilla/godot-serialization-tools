@tool
class_name SerializableInternalObject
extends RefCounted
## Base type useful for internal classes which should be serialized as dictionaries rather than resources.




signal changed()




func emit_changed() -> void:
	changed.emit()



func set_state(p_state: Dictionary) -> void:
	for key in p_state:
		if typeof(key) == TYPE_STRING:
			var property := StringName(key)
			if property in self:
				var value: Variant = p_state[key]
				
				var value_type: Variant.Type = typeof(value)
				var property_type: Variant.Type = typeof(get(property))
				
				print('"%s"\nValue type: %d\nProperty type: %d\n' % [ key, value_type, property_type ])
				
				# Null should mean that it can be object...?
				if property_type == TYPE_NIL and value_type == TYPE_OBJECT:
					set(property, value)
				elif property_type == value_type:
					set(property, value)


func get_state() -> Dictionary:
	var state: Dictionary = {}
	
	for p_info: Dictionary in get_property_list():
		if p_info.usage & PROPERTY_USAGE_SCRIPT_VARIABLE \
		and p_info.usage & PROPERTY_USAGE_STORAGE:
			state[p_info.name] = get(p_info.name)
	
	return state
