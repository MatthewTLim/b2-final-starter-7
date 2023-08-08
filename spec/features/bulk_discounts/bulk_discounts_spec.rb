require "rails_helper"

describe "Bulk Discounts" do
  before :each do
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

          expect(page).to have_content("Total Revenue: 575.0")
          expect(page).to have_content("Total Discounted Revenue: 475.0")
        end
      end
    end
  end

  # 7: Merchant Invoice Show Page: Link to applied discounts

  describe "As a merchant" do
    describe "When I visit my merchant invoice show page" do
      it "Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)" do
        visit merchant_invoice_path(@m1, @invoice)

        expect(page).to have_link("20 percent off", count: 2)
      end
    end
  end

  #8: Admin Invoice Show Page: Total Revenue and Discounted Revenue

  describe "As an admin" do
    describe "When I visit an admin invoice show page" do
      describe "Then I see the total revenue from this invoice (not including discounts)" do
        it "And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
          visit admin_invoice_path(@invoice)

          expect(page).to have_content("Total Revenue: $575.00")
          expect(page).to have_content("Total Discounted Revenue: 475.0")
        end
      end
    end
  end

  #9: Holidays API

  describe "As a merchant" do
    describe "When I visit the discounts index page" do
      describe "I see a section with a header of Upcoming Holidays"do
        describe "In this section the name and date of the next 3 upcoming US holidays are listed." do
          it "Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)" do

            holidays_response = [
              { 'name' => 'Holiday 1', 'date' => '2023-08-10' },
              { 'name' => 'Holiday 2', 'date' => '2023-08-15' },
              { 'name' => 'Holiday 3', 'date' => '2023-08-20' }
            ]

            allow(HTTParty).to receive(:get).and_return(double(body: holidays_response.to_json))

            visit merchant_bulk_discounts_path(@m1)

            expect(page).to have_content('Upcoming Holidays')
            expect(page).to have_content('Holiday 1 - 2023-08-10')
            expect(page).to have_content('Holiday 2 - 2023-08-15')
            expect(page).to have_content('Holiday 3 - 2023-08-20')
          end
        end
      end
    end
  end
end
