class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.find_all(name: '')
    return [] if Merchant.all.length == 0

    Merchant.where("name ILIKE ? ", "%#{name}%").order(name: :asc)

  end

  def self.with_most_revenue(quantity)
    if quantity.to_i != 0
      Merchant.joins(invoices: [:invoice_items, :transactions])
      .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
      .select('merchants.id, merchants.name, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue')
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity.to_i)
    else
      []
    end
  end
end
