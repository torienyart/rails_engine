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

  it "POST /items" do
    post "/api/v1/items", params: @i6#{ :name => @i6.name, :description => @i6.description, :unit_price => @i6.unit_price }
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(json.keys).to include(:name, :description, :unit_price, :merchant_id)
    expect(json[:name]).to include(@i6[:name])
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

    expect(response.status).to eq(200)
    expect(json.keys).to include(:name, :description, :unit_price, :merchant_id)
    expect(json.keys).not_to include(:chuck_norris)
    expect(json[:name]).to include(@i7[:name])
  end
end