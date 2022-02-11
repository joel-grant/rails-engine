require 'rails_helper'

RSpec.describe 'Items API' do
  it "sends a list of all items" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant2.id)
    item4 = create(:item, merchant_id: merchant2.id)
    item5 = create(:item, merchant_id: merchant3.id)
    item6 = create(:item, merchant_id: merchant3.id)

    get "/api/v1/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(6)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a (String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a (Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a (Integer)
    end
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a (String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a (Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a (Integer)
  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_params = ({
      name: "#{item.name}",
      description: "#{item.description}",
      unit_price: item.unit_price,
      merchant_id: item.merchant_id
      })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update an existing item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    previous_name = item.name
    previous_description = item.description
    item_params = ({name: "Pencils", description: "They write things"})
    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    new_item = Item.find_by(id: item.id)

    expect(response).to be_successful

    expect(new_item.name).to_not eq(previous_name)
    expect(new_item.description).to_not eq(previous_description)

    expect(new_item.name).to eq("Pencils")
    expect(new_item.description).to eq("They write things")
  end

  it 'can prevent the user from updating an id that doesnt exist' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    previous_name = item.name
    previous_description = item.description
    item_params = ({name: "Pencils", description: "They write things"})
    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/items/293847", headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq(404)
  end

  it 'can validate whether or not the merchant id that is being provided is correct' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    previous_name = item.name
    previous_description = item.description

    item_params = ({name: "Pencils", description: "They write things", merchant_id: 99999})
    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq(404)
  end

  it 'can delete an item from the database' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, name: "Last One Standing", merchant_id: merchant.id)

    expect(Item.count).to eq(2)

    delete "/api/v1/items/#{item1.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(1)
    expect(Item.where(id: item1.id)).to eq([])
    # expect(Item.find(item1.id)).to raise_error(ActiveRecord::RecordNotFound)
    expect(Item.find(item2.id).name).to eq("Last One Standing")
  end

  it 'can retrieve a merchant based on the item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:data][:attributes][:name]).to eq(merchant.name)
  end

  it "can retrieve all items that are found in a search by name" do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, name: "Test Item")
    item2 = create(:item, merchant_id: merchant.id, name: "Case sensitivity test Item")
    item3 = create(:item, merchant_id: merchant.id, name: "Partial search testing Item")
    item4 = create(:item, merchant_id: merchant.id, name: "Shouldn't see this in results Item")

    search_term = "Test"

    get "/api/v1/items/find_all?name=#{search_term}"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data][0][:attributes][:name]).to include(item2.name)
    expect(items[:data][1][:attributes][:name]).to include(item3.name)
    expect(items[:data][2][:attributes][:name]).to include(item1.name)
  end

  it "can retrieve all items that match a min price search" do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, unit_price: 98.98)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 50)
    item3 = create(:item, merchant_id: merchant.id, name: "Al", unit_price: 100.00)
    item4 = create(:item, merchant_id: merchant.id, name: "Bert", unit_price: 200.00)

    search_price = 100

    get "/api/v1/items/find_all?min_price=#{search_price}"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].count).to eq(2)

    expect(items[:data][0][:id]).to eq(item3.id.to_s)
    expect(items[:data][1][:id]).to eq(item4.id.to_s)
  end

  it "can retrieve all items that match a max price search" do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, name: "Andrea", unit_price: 98.98)
    item2 = create(:item, merchant_id: merchant.id, name: "Betty", unit_price: 50)
    item3 = create(:item, merchant_id: merchant.id, name: "Al", unit_price: 100.00)
    item4 = create(:item, merchant_id: merchant.id, name: "Bert", unit_price: 200.00)

    search_price = 100

    get "/api/v1/items/find_all?max_price=#{search_price}"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].count).to eq(3)

    expect(items[:data][0][:id]).to eq(item3.id.to_s)
    expect(items[:data][1][:id]).to eq(item1.id.to_s)
    expect(items[:data][2][:id]).to eq(item2.id.to_s)
  end

  it "can retrieve all items that match a max and min price search" do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id, name: "Andrea", unit_price: 98.98)
    item2 = create(:item, merchant_id: merchant.id, name: "Betty", unit_price: 50)
    item3 = create(:item, merchant_id: merchant.id, name: "Al", unit_price: 100.00)
    item4 = create(:item, merchant_id: merchant.id, name: "Bert", unit_price: 200.00)

    min_search_price = 75
    max_search_price = 125

    get "/api/v1/items/find_all?max_price=#{max_search_price}&min_price=#{min_search_price}"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].count).to eq(2)

    expect(items[:data][0][:id]).to eq(item3.id.to_s)
    expect(items[:data][1][:id]).to eq(item1.id.to_s)
  end
end
