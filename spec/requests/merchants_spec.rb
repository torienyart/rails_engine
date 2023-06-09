require 'rails_helper'

describe 'can create a merchants response' do
  before :each do
    @m1 = create(:merchant)
    @m2 = create(:merchant)
    @m3 = create(:merchant)
    @m4 = create(:merchant)
    @m5 = create(:merchant)
    @i1 = create(:item, merchant_id: @m1.id)
    @i2 = create(:item, merchant_id: @m1.id)
    @i3 = create(:item, merchant_id: @m1.id)
    @i4 = create(:item, merchant_id: @m1.id)
    @i5 = create(:item, merchant_id: @m1.id)
    @i6 = create(:item, merchant_id: @m2.id)
    @i7 = create(:item, merchant_id: @m2.id)
  end

  it "GET /merchants" do
    get api_v1_merchants_path
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(json[:data]).to be_a(Array)
    expect(json[:data].first[:id]).to eq("#{@m1.id}")
    expect(json[:data].first[:type]).to eq('merchant')
    expect(json[:data].first[:attributes][:name]).to eq(@m1.name)
    expect(json[:data].size).to eq(5)
  end

  it "GET /merchants/:id" do
    get api_v1_merchant_path(@m1)
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(json[:data][:id]).to eq("#{@m1.id}")
    expect(json[:data][:type]).to eq('merchant')
    expect(json[:data][:attributes][:name]).to eq(@m1.name)
  end

  it "error message when id not found" do
    get '/api/v1/merchants/8938772'
    json = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(json[:errors]).to eq(["Couldn't find Merchant with 'id'=8938772"])
  end

  it "error message when id is not integer" do
    get "/api/v1/merchants/'3'"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(json[:errors]).to eq(["Couldn't find Merchant with 'id'='3'"])
  end

  it "GET /merchants/:id/items" do
    get api_v1_merchant_items_path(@m1)
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(json[:data]).to be_a(Array)
    expect(json[:data].first[:id]).to eq("#{@i1.id}")
    expect(json[:data].first[:type]).to eq('item')
    expect(json[:data].first[:attributes][:name]).to eq(@i1.name)
    expect(json[:data].first[:attributes][:description]).to eq(@i1.description)
    expect(json[:data].first[:attributes][:unit_price]).to eq(@i1.unit_price)
  end

  it "error message when id not found" do
    get '/api/v1/merchants/8938772/items'
    json = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(json[:errors]).to eq(["Couldn't find Merchant with 'id'=8938772"])
  end

  describe 'find a merchant based on criteria' do
    before :each do
      @m6 = create(:merchant, name: 'Bags Mart')
      @m7 = create(:merchant, name: 'Shoes Mart')
      @m8 = create(:merchant, name: 'Just a Store')
    end

    it 'can find a merchant based on just name criteria' do
      get '/api/v1/merchants/find?name=Mart'
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data][:id]).to eq("#{@m6.id}")
      expect(json[:data][:type]).to eq('merchant')
      expect(json[:data][:attributes][:name]).to eq(@m6.name)
    end

    it "can return 200 status with undefined error if result doesn't exist" do
      get '/api/v1/merchants/find?name=djdafdopciosl'
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(json[:data]).to eq({})
    end
  end
end