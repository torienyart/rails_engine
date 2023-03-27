require 'rails_helper'

describe 'get all merchants response' do
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
end