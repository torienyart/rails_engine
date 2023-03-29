require 'rails_helper'

describe Item do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :unit_price}
  end

  describe 'relationships' do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  it 'can destroy invoices where it is the only item present' do
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

    @iv3 = Invoice.create!(customer_id: @c1.id, merchant_id: @m1.id)
    @ivi4 = InvoiceItem.create!(invoice_id: @iv3.id, item_id: @i5.id)


    @iv2 = Invoice.create!(customer_id: @c1.id, merchant_id: @m1.id)
    @ivi2 = InvoiceItem.create!(invoice_id: @iv2.id, item_id: @i5.id)
    @ivi3 = InvoiceItem.create!(invoice_id: @iv2.id, item_id: @i2.id)

    expect(@i5.invoices).to include(@iv1, @iv2, @iv3)

    @i5.destroy_invoices
  
    expect(@i5.invoices).to include(@iv2)
  end

  describe 'class methods' do

    before :each do
      @m1 = create(:merchant)
      @i1 = create(:item, :name => 'Turing Shirt', unit_price: 55, merchant_id: @m1.id)
      @i2 = create(:item, :name => 'Cohort Ring', unit_price: 50, merchant_id: @m1.id)
      @i3 = create(:item, :name => 'Zoom Background', unit_price: 5, merchant_id: @m1.id)
    end

    it "can find items by their name" do
      expect(Item.name_search('ring')).to include(@i1, @i2)
      expect(Item.name_search('ring')).to_not include(@i3)

      expect(Item.name_search('background')).to include(@i3)
      expect(Item.name_search('background')).to_not include(@i1, @i2)
    end

    it "can find items by minimum price" do
      expect(Item.price_search(50.00, nil)).to include(@i1, @i2)
      expect(Item.price_search(50.00, nil)).to_not include(@i3)
    end

    xit "can find items by maximum price" do
      expect(Item.price_search(nil, 50.00)).to include(@i2, @i3)
      expect(Item.price_search(nil, 50.00)).to_not include(@i1)
    end
  end
end