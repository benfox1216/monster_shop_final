require 'rails_helper'

describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :item_discounts}
    it {should have_many(:items).through(:item_discounts)}
  end
  
  describe 'Validations' do
    it {should validate_presence_of :amount}
    it {should validate_presence_of :num_items}
  end
  
  describe 'Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    
      @discount_1 = @megan.discounts.create!(amount: 20, num_items: 5)
    end
    
    it "#create_item_discounts" do
      item_ids = ["", "#{@ogre.id}", "#{@giant.id}"]
      
      @discount_1.create_item_discounts(item_ids, @discount_1.amount, @discount_1.num_items)
      
      expect(@megan.item_discounts.count).to eq(2)
    end
  end
end