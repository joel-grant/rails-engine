class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.search_merchant(keyword)
    where("Name  ILIKE ?", "%#{keyword}%").order(:name).first
  end

  def self.id_is_valid(id)
    !where(id: id).empty?
  end

  def self.top_merchants_by_item(merchant_quantity = 5)
    test = Merchant.joins(invoices: [:invoice_items, :transactions]).group(:id).where(transactions: { result: 'success' }, invoices: { status: 'shipped'} ).select("SUM(invoice_items.quantity) as item_quantity, merchants.*, item_quantity").order(item_quantity: :desc).limit(merchant_quantity)
    require 'pry'; binding.pry
  end
end
