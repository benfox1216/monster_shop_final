require 'rails_helper'

describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end
  
  describe 'Validations' do
    it {should validate_presence_of :percent_discount}
    it {should validate_presence_of :minimum_items}
  end
  
  describe 'Methods' do
    it ".best_discount()" do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5)
      megan.discounts.create!(percent_discount: 10, minimum_items: 3)
      megan.discounts.create!(percent_discount: 20, minimum_items: 6)
      
      cart = Cart.new({
        ogre.id.to_s => 1
        })
      
    expect(megan.discounts.best_discount(cart.contents[ogre.id.to_s])).to eq(nil)
    
    cart.contents[ogre.id.to_s] = 3
    expect(megan.discounts.best_discount(cart.contents[ogre.id.to_s])).to eq(10.0)
    
    cart.contents[ogre.id.to_s] = 6
    expect(megan.discounts.best_discount(cart.contents[ogre.id.to_s])).to eq(20.0)
    end
  end
end