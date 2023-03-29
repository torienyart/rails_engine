require 'rails_helper'

RSpec.describe Merchant, type: :model do
	
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
		it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    it "can find a merchant by its name" do
      @m6 = create(:merchant, name: 'Bags Mart')
      @m7 = create(:merchant, name: 'Shoes Mart')
      @m8 = create(:merchant, name: 'Just a store')

      expect(Merchant.name_search('mart')).to eq(@m6)
      expect(Merchant.name_search('Store')).to eq(@m8)
    end
  end
end