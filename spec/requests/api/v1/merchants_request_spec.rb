require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq("#{id}")

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]). to be_a(String)
  end

  it "can find one merchant by a search term" do
    merchant1 = create(:merchant, name: "Test Subject")
    merchant2 = create(:merchant)

    search_term = "Test"

    get "/api/v1/merchants/find?name=#{search_term}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it "will still return an object with data" do
    merchant1 = create(:merchant, name: "no-name")
    merchant2 = create(:merchant, name: "no-name2")

    search_term = "Test"

    get "/api/v1/merchants/find?name=#{search_term}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to eq(nil)
  end
end
