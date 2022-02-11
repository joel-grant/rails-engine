require 'rails_helper'

RSpec.describe Merchant do
  it { should have_many :items }

  describe '#search_merchant' do
    it 'returns any merchants that are found by partial search' do
      merchant1 = create(:merchant, name: "Testing")
      merchant2 = create(:merchant, name: "Other Name")
      merchant3 = create(:merchant, name: "Bagel Seller")

      expect(Merchant.search_merchant("Test")).to eq(merchant1)
    end
  end

  describe '#id_is_valid' do
    it 'returns true/false if the merchant id is valid' do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)

      expect(Merchant.id_is_valid(999999)).to eq(false)
      expect(Merchant.id_is_valid(merchant1.id)).to eq(true)
      expect(Merchant.id_is_valid(merchant2.id)).to eq(true)
    end
  end
end
