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
end
