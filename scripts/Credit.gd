extends Label

var credit : int

func set_credit(amount: int):
	credit = amount
	credit_change()
func add_credit(amount: int):
	credit += amount
	credit_change()
func remove_credit(amount: int):
	credit -= amount
	credit_change()
func credit_change():
	text = str("CREDIT: ",credit)
