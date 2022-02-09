class Merchant < ApplicationRecord
  has_many :items

  def self.search_merchant(keyword)
    where("Name  ILIKE ?", "%#{keyword}%").first
  end
end
