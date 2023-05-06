extends Node


func append(label: String) -> void:
	print("Log append: %s" % [label])
	Pocketbase.create({
		"time": "2022-01-01 10:00:00.123Z",
		"label": label
	})
