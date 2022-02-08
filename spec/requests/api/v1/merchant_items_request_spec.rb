require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  it "sends a list of items that belong to a merchant" do
    merchant = create(:merchant)

    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    item3 = create(:item, merchant_id: merchant.id)
    item4 = create(:item, merchant_id: merchant.id)
    item5 = create(:item, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_items[:data].count).to eq(5)

    merchant_items[:data].each do |merchant_item|
      expect(merchant_item[:attributes]).to have_key(:name)
      expect(merchant_item[:attributes][:name]).to be_a (String)

      expect(merchant_item[:attributes]).to have_key(:description)
      expect(merchant_item[:attributes][:description]).to be_a (String)

      expect(merchant_item[:attributes]).to have_key(:unit_price)
      expect(merchant_item[:attributes][:unit_price]).to be_a (Float)

      expect(merchant_item[:attributes]).to have_key(:merchant_id)
      expect(merchant_item[:attributes][:merchant_id]).to be_a (Integer)
    end
  end
end
