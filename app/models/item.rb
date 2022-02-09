class Item < ApplicationRecord
  belongs_to :merchant

  def self.search_items(keyword)
    where("Name  ILIKE ?", "%#{keyword}%").order(:name)
  end

  def self.search_by_min_price(price)
    where('unit_price >= ?', price).order(:name)
  end

  def self.search_by_max_price(price)
    where('unit_price <= ?', price).order(:name)
  end

  def self.search_by_min_and_max_price(min_price, max_price)
    where(unit_price: min_price..max_price).order(:name)
  end
end
