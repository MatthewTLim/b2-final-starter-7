require "rails_helper"

describe "Bulk Discounts" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
    @discount1 = @m1.bulk_discounts.create!(name: "20 percent off", percentage: 20, quantity_threshold: 10 )
    @item1 = @m1.items.create(name: "Item 1", description: "Description for Item 1", unit_price: 10.0)
    @item2 = @m1.items.create(name: "Item 2", description: "Description for Item 2", unit_price: 15.0)
    @item3 = @m1.items.create(name: "Item 3", description: "Description for Item 3", unit_price: 20.0)

    @customer = Customer.create(first_name: "John", last_name: "Doe", address: "123 Main St", city: "Anytown", state: "CA", zip: 12345)
    @invoice = Invoice.create(customer: @customer, status: 1) # Assuming status 1 is for "completed" invoices

    @invoice.invoice_items.create(item: @item1, quantity: 10, unit_price: @item1.unit_price)
    @invoice.invoice_items.create(item: @item2, quantity: 5, unit_price: @item2.unit_price)
    @invoice.invoice_items.create(item: @item3, quantity: 20, unit_price: @item3.unit_price)

    @transaction1 = Transaction.create(credit_card_number: 1234567812345678, credit_card_expiration_date: "08/25", result: 1, invoice: @invoice)
    @transaction2 = Transaction.create(credit_card_number: 8765432187654321, credit_card_expiration_date: "12/24", result: 1, invoice: @invoice)
    @transaction3 = Transaction.create(credit_card_number: 5678123456781234, credit_card_expiration_date: "06/23", result: 1, invoice: @invoice)
  end

  #1: Merchant Bulk Discounts Index
  describe "As a merchant" do
    describe "When I visit my merchant dashboard" do
      describe "Then I see a link to view all my discounts" do
        describe "When I click this link" do
          describe "Then I am taken to my bulk discounts index page" do
            describe "Where I see all of my bulk discounts including their" do
              describe "percentage discount and quantity thresholds" do
                it "And each bulk discount listed includes a link to its show page" do

                  visit merchant_dashboard_index_path(@m1)

                  click_link "View My Discounts"

                  expect(current_path).to eq(merchant_bulk_discounts_path(@m1))

                  bulk_discounts = [@discount1]

                  bulk_discounts.each do |discount|
                    expect(page).to have_link(discount.name)
                    expect(page).to have_content(discount.percentage)
                    expect(page).to have_content(discount.quantity_threshold)
                  end
                end
              end
            end
          end
        end
      end
    end
  end


  #2: Merchant Bulk Discount Create
  describe "As a merchant" do
    describe "When I visit my bulk discounts index" do
      describe "Then I see a link to create a new discount" do
        describe "When I click this link" do
          describe "Then I am taken to a new page where I see a form to add a new bulk discount" do
            describe "When I fill in the form with valid data" do
              describe "Then I am redirected back to the bulk discount index" do
                it "And I see my new bulk discount listed" do

                  visit merchant_bulk_discounts_path(@m1)

                  click_link "Create a New Discount"

                  expect(current_path).to eq(new_merchant_bulk_discount_path(@m1))

                  fill_in "Name", with: "50 percent off"
                  fill_in "Percentage", with: 50
                  fill_in "Quantity threshold", with: 100

                  click_button "Submit"

                  expect(current_path).to eq(merchant_bulk_discounts_path(@m1))
                  expect(page).to have_content("50 percent off")
                  expect(page).to have_content("50")
                  expect(page).to have_content("100")
                end
              end
            end
          end
        end
      end
    end
  end

  #3: Merchant Bulk Discount Delete

  describe "As a merchant" do
    describe "When I visit my bulk discounts index" do
      describe "Then next to each bulk discount I see a button to delete it" do
        describe "When I click this button" do
          describe "Then I am redirected back to the bulk discounts index page" do
            it "And I no longer see the discount listed" do

              visit merchant_bulk_discounts_path(@m1)

              click_button "Delete"

              expect(page).to_not have_content(@discount1.name)
              expect(page).to_not have_content(@discount1.percentage)
              expect(page).to_not have_content(@discount1.quantity_threshold)

              expect(current_path).to eq(merchant_bulk_discounts_path(@m1))
            end
          end
        end
      end
    end
  end

  #4: Merchant Bulk Discount Show
  describe "As a merchant" do
    describe "When I visit my bulk discount show page" do
      it "Then I see the bulk discount's quantity threshold and percentage discount" do

        visit merchant_bulk_discount_path(@m1, @discount1)
        save_and_open_page
        expect(page).to have_content(@discount1.name)
        expect(page).to have_content(@discount1.percentage)
        expect(page).to have_content(@discount1.quantity_threshold)
      end
    end
  end

  #5: Merchant Bulk Discount Edit

  describe "As a merchant" do
    describe "When I visit my bulk discount show page" do
      describe "Then I see a link to edit the bulk discount" do
        describe "When I click this link" do
          describe "Then I am taken to a new page with a form to edit the discount" do
            describe "And I see that the discounts current attributes are pre-poluated in the form" do
              describe "When I change any/all of the information and click submit" do
                describe "Then I am redirected to the bulk discount's show page" do
                  it "And I see that the discount's attributes have been updated" do

                    visit merchant_bulk_discount_path(@m1, @discount1)

                    click_link "Edit Discount"
                    expect(current_path).to eq(edit_merchant_bulk_discount_path(@m1, @discount1))
                    expect(page).to have_field("Name", with: @discount1.name)
                    expect(page).to have_field("Percentage", with: @discount1.percentage)
                    expect(page).to have_field("Quantity threshold", with: @discount1.quantity_threshold)

                    fill_in "Name", with: "25 Percent off christmas special"
                    fill_in "Percentage", with: 25
                    fill_in "Quantity threshold", with: 6

                    click_button "Submit"

                    expect(current_path).to eq(merchant_bulk_discount_path(@m1, @discount1))

                    expect(page).to have_content("25 Percent off christmas special")
                    expect(page).to have_content(25)
                    expect(page).to have_content(6)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  #6: Merchant Invoice Show Page: Total Revenue and Discounted Revenue

  describe "As a merchant" do
    describe "When I visit my merchant invoice show page" do
      describe "Then I see the total revenue for my merchant from this invoice (not including discounts)" do
        it "And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation" do
          visit merchant_invoice_path(@m1, @invoice)
          save_and_open_page
          # expect(page).to have_content()
        end
      end
    end
  end
end
