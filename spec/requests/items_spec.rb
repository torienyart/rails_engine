require 'rails_helper'

describe 'can create an items response' do
  before :each do
    @i1 = create(:item)
    @i2 = create(:item)
    @i3 = create(:item)
    @i4 = create(:item)
    @i5 = create(:item)
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
end