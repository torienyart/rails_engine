require 'rails_helper'

describe 'can create an items response' do
  before :each do
    @m1 = create(:merchant)
    @i1 = create(:item, merchant_id: @m1.id)
    @i2 = create(:item, merchant_id: @m1.id)
    @i3 = create(:item, merchant_id: @m1.id)
    @i4 = create(:item, merchant_id: @m1.id)
    @i5 = create(:item, merchant_id: @m1.id)
    @i6 = attributes_for(:item, merchant_id: @m1.id)
    @i7 = attributes_for(:item, merchant_id: @m1.id, :chuck_norris => "Chuck Norris don't give a shit")
    @i8 = attributes_for(:item, merchant_id: @m1.id)
    
    @c1 = Customer.create!
    @iv1 = Invoice.create!(customer_id: @c1.id, merchant_id: @m1.id)
    @ivi1 = InvoiceItem.create!(invoice_id: @iv1.id, item_id: @i5.id)
  end

  it "GET /items" do
    get api_v1_items_path
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(json[:data]).to be_a(Array)
    expect(json[:data].first[:id]).to eq("#{@i1.id}")
    expect(json[:data].first[:type]).to eq('item')
    expect(json[:data].first[:attributes][:name]).to eq(@i1.name)
    expect(json[:data].first[:attributes][:description]).to eq(@i1.description)
    expect(json[:data].first[:attributes][:unit_price]).to eq(@i1.unit_price)

    expect(json[:data].size).to eq(5)
  end

  it "GET /items/:id" do
    get api_v1_item_path(@i1)
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(json[:data][:id]).to eq("#{@i1.id}")
    expect(json[:data][:type]).to eq('item')
    expect(json[:data][:attributes][:name]).to eq(@i1.name)
    expect(json[:data][:attributes][:description]).to eq(@i1.description)
    expect(json[:data][:attributes][:unit_price]).to eq(@i1.unit_price)
  end

  it "error message when id not found" do
    get '/api/v1/items/8938772'
    json = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(json[:errors]).to eq(["Couldn't find Item with 'id'=8938772"])
  end

  it "error message when id is not integer" do
    get "/api/v1/items/'3'"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(json[:errors]).to eq(["Couldn't find Item with 'id'='3'"])
  end
  
  describe 'create an item' do
    it "POST /items" do
      post "/api/v1/items", params: @i6
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(json[:data][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
      expect(json[:data][:attributes][:name]).to include(@i6[:name])
    end

    it "can return an error response when the item was not created" do
      post "/api/v1/items", params: { :name => @i6[:name], :description => @i6[:description] }
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(422)
      expect(json[:errors]).to eq(["Unit price can't be blank", "Merchant can't be blank", "Unit price is not a number", "Merchant must exist"])
    end

    it "can ignore attributes that are not allowed" do
      post "/api/v1/items", params: @i7
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(json[:data][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
      expect(json[:data][:attributes].keys).not_to include(:chuck_norris)
      expect(json[:data][:attributes][:name]).to include(@i7[:name])
    end
  end

  describe 'update an item' do
    it "PUT /items/:id" do
      patch "/api/v1/items/#{@i5.id}", params: @i8
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
      expect(json[:data][:attributes][:name]).to eq(@i8[:name])
      expect(json[:data][:attributes][:description]).to eq(@i8[:description])
      expect(json[:data][:attributes][:unit_price]).to eq(@i8[:unit_price])
    end

    it "can return an error response when the item was not updated" do
      patch "/api/v1/items/#{@i5.id}", params: { :unit_price => 'twenty'}
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(404)
      expect(json[:errors]).to eq(["Unit price is not a number"])
    end

    it "can return an error response when the item id doesn't exist" do
      patch "/api/v1/items/999999", params: @i8
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(json[:errors]).to eq(["Couldn't find Item with 'id'=999999"])
    end

    it "error message when id is not integer" do
      patch "/api/v1/items/'3'", params: @i8
      json = JSON.parse(response.body, symbolize_names: true)
  
      expect(response.status).to eq(404)
      expect(json[:errors]).to eq(["Couldn't find Item with 'id'='3'"])
    end

    it "can return an error response when the merchant id is bad" do
      patch "/api/v1/items/#{@i5.id}", params: { :merchant_id => 999999 }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(json[:errors]).to eq(["Merchant must exist"])
    end

    it "can ignore attributes that are not allowed" do
      patch "/api/v1/items/#{@i5.id}", params: @i7
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
      expect(json[:data][:attributes].keys).not_to include(:chuck_norris)
      expect(json[:data][:attributes][:name]).to include(@i7[:name])
    end
  end

  describe 'delete an item' do
    it 'DELETE /api/v1/items/:id' do
      delete "/api/v1/items/#{@i5.id}"

      expect(response.status).to eq(204)
      expect(response.body).to be_empty

      expect(@i5.invoices).to eq([])
    end
  end

  describe "can get an item's merchant" do
    it 'api/v1/items/:id/merchant' do
      get "/api/v1/items/#{@i5.id}/merchant"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data][:id]).to eq("#{@m1.id}")
      expect(json[:data][:type]).to eq('merchant')
      expect(json[:data][:attributes][:name]).to eq(@m1.name)
    end

    it "error message when id not found" do
      get "/api/v1/items/8903457/merchant"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(json[:errors]).to eq(["Couldn't find Item with 'id'=8903457"])
    end

    it "error message when id is not integer" do
      get "/api/v1/items/'3'/merchant"
      json = JSON.parse(response.body, symbolize_names: true)
  
      expect(response.status).to eq(404)
      expect(json[:errors]).to eq(["Couldn't find Item with 'id'='3'"])
    end
  end

  describe "it can find an item" do
    before :each do
      Item.destroy_all
      @m1 = create(:merchant)
      @i1 = create(:item, :name => 'Turing Shirt', unit_price: 55, merchant_id: @m1.id)
      @i2 = create(:item, :name => 'Cohort Ring', unit_price: 50, merchant_id: @m1.id)
      @i3 = create(:item, :name => 'Zoom Background', unit_price: 5, merchant_id: @m1.id)
    end

    it 'can find items by name' do
      get "/api/v1/items/find_all?name=ring"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data].count).to eq(2)
      expect(json[:data].first[:id]).to eq("#{@i2.id}")
      expect(json[:data].first[:type]).to eq('item')
      expect(json[:data].first[:attributes][:name]).to eq(@i2.name)
      expect(json[:data].first[:attributes][:description]).to eq(@i2.description)
      expect(json[:data].first[:attributes][:unit_price]).to eq(@i2.unit_price)
    end

    it "can return 200 status with undefined error if result doesn't exist" do
      get '/api/v1/items/find_all?name=beepboopbop'
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data]).to eq([])
    end

    it 'can find items by min price' do
      get "/api/v1/items/find_all?min_price=50.00"
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data].count).to eq(2)
      expect(json[:data].first[:id]).to eq("#{@i2.id}")
      expect(json[:data].first[:type]).to eq('item')
      expect(json[:data].first[:attributes][:name]).to eq(@i2.name)
      expect(json[:data].first[:attributes][:description]).to eq(@i2.description)
      expect(json[:data].first[:attributes][:unit_price]).to eq(@i2.unit_price)

    end
  end
end