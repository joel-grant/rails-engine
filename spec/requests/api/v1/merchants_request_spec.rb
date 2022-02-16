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

    expect(merchant[:data]).to_not be nil
  end

  it "can return a quantity of merchants sorted by descending item quantity sold" do
    merchant1 = create(:merchant, name: "Testing1")
    merchant2 = create(:merchant, name: "Testing2")
    merchant3 = create(:merchant, name: "Testing3")
    merchant4 = create(:merchant, name: "Testing4")
    merchant5 = create(:merchant, name: "Testing5")

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant2.id)
    item3 = create(:item, merchant_id: merchant2.id)
    item4 = create(:item, merchant_id: merchant2.id)
    item5 = create(:item, merchant_id: merchant3.id)
    item6 = create(:item, merchant_id: merchant3.id)
    item7 = create(:item, merchant_id: merchant3.id)
    item8 = create(:item, merchant_id: merchant3.id)
    item9 = create(:item, merchant_id: merchant3.id)
    item10 = create(:item, merchant_id: merchant4.id)
    item11 = create(:item, merchant_id: merchant4.id)
    item12 = create(:item, merchant_id: merchant5.id)
    item13 = create(:item, merchant_id: merchant5.id)

    customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    customer2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    customer3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    customer4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    customer5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    customer6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    invoice1 = Invoice.create!(customer: customer1, merchant_id: merchant1.id, status: "shipped")
    invoice2 = Invoice.create!(customer: customer2, merchant_id: merchant2.id, status: "shipped")
    invoice3 = Invoice.create!(customer: customer3, merchant_id: merchant3.id, status: "shipped")
    invoice4 = Invoice.create!(customer: customer4, merchant_id: merchant4.id, status: "in progress")
    invoice5 = Invoice.create!(customer: customer5, merchant_id: merchant5.id, status: "shipped")

    ii1 = InvoiceItem.create!(invoice: invoice1, item: item1)
    ii2 = InvoiceItem.create!(invoice: invoice2, item: item2)
    ii3 = InvoiceItem.create!(invoice: invoice2, item: item3)
    ii4 = InvoiceItem.create!(invoice: invoice2, item: item4)
    ii5 = InvoiceItem.create!(invoice: invoice3, item: item5)
    ii6 = InvoiceItem.create!(invoice: invoice3, item: item6)
    ii7 = InvoiceItem.create!(invoice: invoice3, item: item7)
    ii8 = InvoiceItem.create!(invoice: invoice3, item: item8)
    ii9 = InvoiceItem.create!(invoice: invoice3, item: item9)
    ii10 = InvoiceItem.create!(invoice: invoice4, item: item10)
    ii11 = InvoiceItem.create!(invoice: invoice4, item: item11)
    ii12 = InvoiceItem.create!(invoice: invoice5, item: item12)
    ii13 = InvoiceItem.create!(invoice: invoice5, item: item13)

    t1 = Transaction.create!(invoice: invoice1, result: "success")
    t2 = Transaction.create!(invoice: invoice2, result: "success")
    t3 = Transaction.create!(invoice: invoice3, result: "success")
    t4 = Transaction.create!(invoice: invoice4, result: "success")
    t5 = Transaction.create!(invoice: invoice5, result: "success")

    test_quantity = 4

    get "/api/v1/merchants/most_items?quantity=#{test_quantity}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].first[:attributes][:name]).to eq("Testing3")
    require 'pry'; binding.pry
  end
end
