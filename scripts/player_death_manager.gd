extends DeathManager

func die():
	print(get_parent().get_parent().name, " died. ")
