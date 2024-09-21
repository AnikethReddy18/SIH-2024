extends Control


#External Objects Refereces
@onready var in_game = $"../InGameUI"

#Internal Object References
@onready var fertilizer_amount_label = $CenterContainer/ShopPanel/BuyCenterContainer/UtilVBoxContainer/FertilizerHBoxContainer/FertilizerAmountLabel
@onready var buy_fertilizer_button = $CenterContainer/ShopPanel/BuyCenterContainer/UtilVBoxContainer/FertilizerHBoxContainer/BuyFertilizerButton
@onready var drip_pipes_amount_label = $CenterContainer/ShopPanel/BuyCenterContainer/UtilVBoxContainer/DripPipesHBoxContainer/DripPipesAmountLabel
@onready var buy_drip_pipes_button: Button = $CenterContainer/ShopPanel/BuyCenterContainer/UtilVBoxContainer/DripPipesHBoxContainer/BuyDripPipesButton
@onready var recovery_well_amount_label: Label = $CenterContainer/ShopPanel/BuyCenterContainer/UtilVBoxContainer/RecoveryWellHboxContainer/RecoveryWellAmountLabel
@onready var buy_recovery_well_button: Button = $CenterContainer/ShopPanel/BuyCenterContainer/UtilVBoxContainer/RecoveryWellHboxContainer/BuyRecoveryWellButton
@onready var wheat_select: Button = $CenterContainer/ShopPanel/CropsHBoxContainer/wheat/wheat_select
@onready var wheat_count: Label = $CenterContainer/ShopPanel/CropsHBoxContainer/wheat/wheat_count
@onready var pumpkin_select: Button = $CenterContainer/ShopPanel/CropsHBoxContainer/pumpkin/pumpkin_select
@onready var pumpkin_amount: Label = $CenterContainer/ShopPanel/CropsHBoxContainer/pumpkin/pumpkin_amount
@onready var coins_amount_label: Label = $CenterContainer/ShopPanel/coins/CoinsAmountLabel

func _ready():
	Globals.coins_change.connect(_on_coins_amount_change)
	Globals.util_count_changed.connect(_on_util_count_change)
	Globals.wheat_count_change.connect(_on_wheat_count_changed)
	Globals.pumpkin_count_change.connect(_on_pumpkin_count_changed)
	
	#Buttons
	buy_fertilizer_button.pressed.connect(_on_buy_fertilizer_button_pressed)
	buy_drip_pipes_button.pressed.connect(_on_buy_pipes_button_pressed)
	buy_recovery_well_button.pressed.connect(_on_buy_wells_button_pressed)
	wheat_select.pressed.connect(_on_buy_wheat_button_pressed)
	pumpkin_select.pressed.connect(_on_buy_pumpkin_button_pressed)
	
func _process(_delta):
	if Input.is_action_just_pressed("shop"):
		toggle_shop()

func toggle_shop():
	if visible:
		visible = false
		in_game.visible = true
		
	else:
		visible = true
		in_game.visible = false


func _on_coins_amount_change():
	coins_amount_label.text = str(Globals.coins)
	
func _on_util_count_change():
	fertilizer_amount_label.text = str(Globals.util_count[0])
	drip_pipes_amount_label.text = str(Globals.util_count[1])
	recovery_well_amount_label.text = str(Globals.util_count[2])
	
func _on_buy_fertilizer_button_pressed():
	if Globals.coins > 20:
		var x = Globals.util_count
		Globals.util_count = [x[0]+1, x[1], x[2]]	
		Globals.coins -= 20
		
func _on_buy_pipes_button_pressed():
	if Globals.coins > 20:
		var x = Globals.util_count
		Globals.util_count = [x[0], x[1]+1, x[2]]	
		Globals.coins -= 20
		
func _on_buy_wells_button_pressed():
	if Globals.coins > 20:
		var x = Globals.util_count
		Globals.util_count = [x[0], x[1], x[2]+1]	
		Globals.coins -= 20				

func _on_buy_wheat_button_pressed():
	if Globals.coins> 1:
		Globals.coins -= 1
		Globals.wheat_count += 1

func _on_wheat_count_changed():
	wheat_count.text = str(Globals.wheat_count)
	
func _on_buy_pumpkin_button_pressed():
	if Globals.coins> 1:
		Globals.coins -= 1
		Globals.pumpkin_count += 1
		
func _on_pumpkin_count_changed():
	pumpkin_amount.text	 = str(Globals.pumpkin_count)	
