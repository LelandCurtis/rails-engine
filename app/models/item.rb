class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of  :unit_price

  def self.search(name: '', min_price: 0.0, max_price: nil)
    max_price = Item.maximum(:unit_price) if max_price == nil
    
    Item.where('name ILIKE ?', "%#{name}%")
    .where("unit_price >= #{min_price} AND unit_price <= #{max_price}")
    .order(name: :asc).limit(1)[0]
  end

end
