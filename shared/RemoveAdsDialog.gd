extends CanvasLayer

# 🛒 REMOVE ADS DIALOG
# Shows purchase information and handles IAP flow

signal purchase_confirmed
signal purchase_cancelled

func _ready() -> void:
	# Pause the game when dialog appears
	get_tree().paused = true

func _on_purchase_pressed() -> void:
	# Start purchase flow
	if AdManager.is_ads_removed():
		show_already_purchased_message()
		return
	
	# Disable button during purchase
	$Overlay/DialogPanel/VBox/PurchaseButton.disabled = true
	$Overlay/DialogPanel/VBox/PurchaseButton.text = "Processing..."
	
	# Trigger purchase
	AdManager.purchase_remove_ads()
	await AdManager.purchase_completed
	
	# Show success message
	show_success_message()
	purchase_confirmed.emit()
	
	# Close dialog after short delay
	await get_tree().create_timer(1.5).timeout
	close_dialog()

func _on_cancel_pressed() -> void:
	purchase_cancelled.emit()
	close_dialog()

func show_success_message() -> void:
	$Overlay/DialogPanel/VBox/TitleLabel.text = "Purchase Successful!"
	$Overlay/DialogPanel/VBox/DescriptionLabel.text = "All ads have been removed from all games. Enjoy your uninterrupted gameplay!"
	$Overlay/DialogPanel/VBox/FeaturesLabel.visible = false
	$Overlay/DialogPanel/VBox/PurchaseButton.visible = false
	$Overlay/DialogPanel/VBox/CancelButton.text = "Close"

func show_already_purchased_message() -> void:
	$Overlay/DialogPanel/VBox/TitleLabel.text = "Already Purchased"
	$Overlay/DialogPanel/VBox/DescriptionLabel.text = "You have already removed ads! All games are ad-free."
	$Overlay/DialogPanel/VBox/FeaturesLabel.visible = false
	$Overlay/DialogPanel/VBox/PurchaseButton.visible = false
	$Overlay/DialogPanel/VBox/CancelButton.text = "Close"

func close_dialog() -> void:
	get_tree().paused = false
	queue_free()
