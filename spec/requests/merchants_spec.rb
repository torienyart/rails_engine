require 'rails_helper'

describe 'can create a merchants response' do
  before :each do
    @m1 = create(:merchant)
    @m2 = create(:merchant)
    @m3 = create(:merchant)
    @m4 = create(:merchant)
    @m5 = create(:merchant)

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
end