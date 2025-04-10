extends Control

@export var player : Player
@export var upgrade1 : BaseUpgradeStrategy
@export var upgrade2 : BaseUpgradeStrategy
@export var upgrade3 : BaseUpgradeStrategy

@onready var button1tex : TextureRect = $"UpgradeMenuBackground/UpgradeContainer/Upgrade1/Upgrade1 Texture"
@onready var button2tex : TextureRect = $"UpgradeMenuBackground/UpgradeContainer/Upgrade2/Upgrade2 Texture"
@onready var button3tex : TextureRect = $"UpgradeMenuBackground/UpgradeContainer/Upgrade3/Upgrade3 Texture"

func _ready():
	button1tex.texture = upgrade1.texture
	button2tex.texture = upgrade2.texture
	button3tex.texture = upgrade3.texture

func level_up():
	button1tex.texture = upgrade1.texture
	button2tex.texture = upgrade2.texture
	button3tex.texture = upgrade3.texture
	self.visible = true
	

func _on_upgrade_1_pressed() -> void:
	player.player_upgrades.append(upgrade1)
	upgrade1.apply_player_upgrade(player)
	player.update_sanity()
	self.visible = false

func _on_upgrade_2_pressed() -> void:
	player.player_upgrades.append(upgrade2)
	upgrade2.apply_player_upgrade(player)
	player.update_sanity()
	self.visible = false

func _on_upgrade_3_pressed() -> void:
	player.player_upgrades.append(upgrade3)
	upgrade3.apply_player_upgrade(player)
	player.update_sanity()
	self.visible = false
