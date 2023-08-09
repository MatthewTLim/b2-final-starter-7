# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Customer.destroy_all
Item.destroy_all
Invoice.destroy_all
InvoiceItem.destroy_all
Merchant.destroy_all
Transaction.destroy_all

@merchant1 = Merchant.create!(name: "Galactic Salvage")
@merchant2 = Merchant.create!(name: "Cosmic Armaments")

@item_1 = Item.create!(name: "Fusion Core", description: "Power source for interstellar travel", unit_price: 1000, merchant_id: @merchant1.id, status: 1)
@item_2 = Item.create!(name: "Plasma Blaster", description: "Fires bolts of scorching plasma", unit_price: 800, merchant_id: @merchant1.id)
@item_3 = Item.create!(name: "Ion Thruster", description: "Propulsion system for maneuvering in space", unit_price: 500, merchant_id: @merchant1.id)
@item_4 = Item.create!(name: "Neutrino Shield", description: "Deflects cosmic radiation and enemy fire", unit_price: 100, merchant_id: @merchant1.id)
@item_5 = Item.create!(name: "Nova Grenade", description: "Explosive ordnance for maximum impact", unit_price: 200, merchant_id: @merchant2.id)
@item_6 = Item.create!(name: "Black Hole Launcher", description: "Generates miniature black holes to engulf foes", unit_price: 300, merchant_id: @merchant2.id)
@item_7 = Item.create!(name: "Quasar Cannon", description: "Unleashes the fury of a quasar in a weapon", unit_price: 300, merchant_id: @merchant1.id)
@item_8 = Item.create!(name: "Photon Saber", description: "Elegant energy blade for close combat", unit_price: 500, merchant_id: @merchant1.id)

@customer_1 = Customer.create!(first_name: "Captain", last_name: "Redbeard")
@customer_2 = Customer.create!(first_name: "Starlight", last_name: "Raider")
@customer_3 = Customer.create!(first_name: "Cosmic", last_name: "Corsair")
@customer_4 = Customer.create!(first_name: "Void", last_name: "Marauder")
@customer_5 = Customer.create!(first_name: "Nebula", last_name: "Renegade")
@customer_6 = Customer.create!(first_name: "Galaxy", last_name: "Wraith")

@invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2212-03-28 14:54:09")
@invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2212-03-27 14:54:09")
@invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2212-03-26 14:54:09")
@invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, created_at: "2212-03-25 14:54:09")
@invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, created_at: "2212-03-24 14:54:09")
@invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2, created_at: "2212-03-23 14:54:09")
@invoice_7 = Invoice.create!(customer_id: @customer_3.id, status: 2, created_at: "2212-03-22 14:54:09")

@invoice_items_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 1000, status: 2)
@invoice_items_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 300, status: 1)
@invoice_items_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_6.id, quantity: 100, unit_price: 1000, status: 2)
@invoice_items_4 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 6, unit_price: 800, status: 2)
@invoice_items_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 50, unit_price: 500, status: 1)
@invoice_items_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 23, unit_price: 100, status: 1)
@invoice_items_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 5, unit_price: 300, status: 1)
@invoice_items_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 20, unit_price: 500, status: 1)
@invoice_items_9 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_1.id, quantity: 20, unit_price: 160, status: 1)
@invoice_items_10 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_5.id, quantity: 18, unit_price: 200, status: 1)
@invoice_items_11 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_5.id, quantity: 13, unit_price: 200, status: 1)
@invoice_items_12 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_1.id, quantity: 13, unit_price: 200, status: 1)
@invoice_items_13 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_1.id, quantity: 10, unit_price: 200, status: 1)
@invoice_items_14 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_3.id, quantity: 9, unit_price: 200, status: 1)
@invoice_items_15 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_5.id, quantity: 60, unit_price: 160, status: 1)
@invoice_items_16 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_3.id, quantity: 20, unit_price: 160, status: 1)
@invoice_items_17 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_5.id, quantity: 12, unit_price: 160, status: 1)
@invoice_items_18 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_6.id, quantity: 100, unit_price: 160, status: 1)
@invoice_items_19 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 14, unit_price: 100, status: 1)

@transaction1 = Transaction.create!(credit_card_number: 4928534027003044, result: 1, invoice_id: @invoice_1.id)
@transaction2 = Transaction.create!(credit_card_number: 4539471083250459, result: 1, invoice_id: @invoice_2.id)
@transaction3 = Transaction.create!(credit_card_number: 6011801084194565, result: 1, invoice_id: @invoice_3.id)
@transaction4 = Transaction.create!(credit_card_number: 4929727696541858, result: 1, invoice_id: @invoice_4.id)
@transaction5 = Transaction.create!(credit_card_number: 4916431978797828, result: 1, invoice_id: @invoice_5.id)
@transaction6 = Transaction.create!(credit_card_number: 4024007150706908, result: 1, invoice_id: @invoice_6.id)
@transaction7 = Transaction.create!(credit_card_number: 4532802877411369, result: 1, invoice_id: @invoice_7.id)

@bulk_discounts1 = @merchant1.bulk_discounts.create!(merchant_id: @merchant1.id, name: "10% Off 5 for Space Scavengers", percentage: 10, quantity_threshold: 5)
@bulk_discounts2 = @merchant1.bulk_discounts.create!(merchant_id: @merchant1.id, name: "20% Off 10 for Galactic Raiders", percentage: 20, quantity_threshold: 10)
@bulk_discounts3 = @merchant1.bulk_discounts.create!(merchant_id: @merchant1.id, name: "25% Off 15 for Cosmic Conquerors", percentage: 25, quantity_threshold: 15)
@bulk_discounts4 = @merchant1.bulk_discounts.create!(merchant_id: @merchant1.id, name: "30% Off 20 for Nebula Nomads", percentage: 30, quantity_threshold: 20)

