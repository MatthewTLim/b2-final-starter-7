require "rails_helper"

describe "Bulk Discounts" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
    @discount1 = @m1.bulk_discounts.create!(name: "20 percent off", percentage: 20, quantity_threshold: 10 )
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
end