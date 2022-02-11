require 'rails_helper'

RSpec.describe Item do
  it { should belong_to :merchant }

  describe '#search_items' do
    it 'finds items by name' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id, name: "Just a test")
      expect(Item.search_items("Test").first).to eq(item)
    end
  end

  describe '#search_by_min_price' do
    it 'returns all items over a specific price' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, unit_price: 75)
      item2 = create(:item, merchant_id: merchant.id, unit_price: 101, name: "A")
      item3 = create(:item, merchant_id: merchant.id, unit_price: 200, name: "B")

      expect(Item.search_by_min_price(100)).to eq([item2, item3])
    end
  end

  describe '#search_by_max_price' do
    it 'returns all items under a specific price' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, unit_price: 75, name: "A")
      item2 = create(:item, merchant_id: merchant.id, unit_price: 101, name: "B")
      item3 = create(:item, merchant_id: merchant.id, unit_price: 200, name: "C")

      expect(Item.search_by_max_price(101)).to eq([item1, item2])
    end
  end

  describe '#search_by_min_and_max_price' do
    it 'returns the item within the min and max prices' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, unit_price: 75, name: "A")
      item2 = create(:item, merchant_id: merchant.id, unit_price: 101, name: "B")
      item3 = create(:item, merchant_id: merchant.id, unit_price: 200, name: "C")

      expect(Item.search_by_min_and_max_price(102, 201)).to eq([item3])
    end
  end

  describe '#id_is_valid' do
    it 'returns a true/false if the id exists in the database' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, unit_price: 75, name: "A")
      item2 = create(:item, merchant_id: merchant.id, unit_price: 101, name: "B")
      item3 = create(:item, merchant_id: merchant.id, unit_price: 200, name: "C")

      expect(Item.id_is_valid(9999999)).to eq(false)
      expect(Item.id_is_valid(item1.id)).to eq(true)
    end
  end
end
