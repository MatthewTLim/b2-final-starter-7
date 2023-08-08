require "httparty"

class BulkDiscountsController < ApplicationController
  def index
    @upcoming_holidays = get_upcoming_holidays(3)
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])

    if @bulk_discount.update(update_bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount), notice: "#{@bulk_discount.name} was successfully updated."
    else
      render :edit
    end
  end

  private

  def update_bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percentage, :quantity_threshold)
  end

  def bulk_discount_params
    params.permit(:name, :percentage, :quantity_threshold)
  end

  def get_upcoming_holidays(count)
    response = HTTParty.get("https://date.nager.at/Api/v2/NextPublicHolidaysWorldwide?countryCode=US&n=#{count}")
    holidays_data = JSON.parse(response.body)

    upcoming_holidays = holidays_data[0...count].map do |holiday|
      { name: holiday['name'], date: holiday['date'] }
    end

    upcoming_holidays
  end
end