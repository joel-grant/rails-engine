class Merchant < ApplicationRecord
  has_many :items

  def self.search_merchant(keyword)
    where("Name  ILIKE ?", "%#{keyword}%").order(:name).first
  end

  def self.id_is_valid(id)
    !where(id: id).empty?
  end
end
