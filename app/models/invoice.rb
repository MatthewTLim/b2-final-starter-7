class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def best_discounts_per_invoice_item
    best_bulk_discounts = InvoiceItem.joins(item: { merchant: :bulk_discounts })
                               .where("bulk_discounts.quantity_threshold <= invoice_items.quantity")
                               .select("invoice_items.id,
                                        MAX(bulk_discounts.percentage / 100.0 * invoice_items.unit_price * invoice_items.quantity) AS total_discount")
                               .group("invoice_items.id")

    best_bulk_discounts
  end

  def total_discount
    best_bulk_discounts = best_discounts_per_invoice_item

    best_bulk_discounts.sum(&:total_discount)
  end

  def total_discounted_revenue
    total_revenue - total_discount
  end
end
