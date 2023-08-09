require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end

  describe "#bulk_discount_applied?"do
    it "checks if an item qualifies for a discount and returns the name if applicable" do
      @m1 = Merchant.create!(name: "Merchant 1")
      @discount1 = @m1.bulk_discounts.create!(name: "20 percent off", percentage: 20, quantity_threshold: 10 )
      @item1 = @m1.items.create(name: "Item 1", description: "Description for Item 1", unit_price: 10.0)
      @item2 = @m1.items.create(name: "Item 2", description: "Description for Item 2", unit_price: 15.0)
      @item3 = @m1.items.create(name: "Item 3", description: "Description for Item 3", unit_price: 20.0)

      @customer = Customer.create(first_name: "John", last_name: "Doe", address: "123 Main St", city: "Anytown", state: "CA", zip: 12345)
      @invoice = Invoice.create(customer: @customer, status: 1, created_at: "2012-03-27 14:54:09")

      @invoice.invoice_items.create(item: @item1, quantity: 10, unit_price: @item1.unit_price, status: 2)
      @invoice.invoice_items.create(item: @item2, quantity: 5, unit_price: @item2.unit_price, status: 2)
      @invoice.invoice_items.create(item: @item3, quantity: 20, unit_price: @item3.unit_price, status: 2)

      invoice_item = @invoice.invoice_items.first
      applied_discount = invoice_item.applied_bulk_discount

      expect(applied_discount).to eq(@discount1)
    end
  end
end
