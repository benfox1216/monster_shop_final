require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'As a user' do
  describe 'when I create an order with a discount' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @megan.discounts.create!(percent_discount: 10, minimum_items: 2)
      
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    
    it "the order is created with the discounts applied, and order total displays correctly in the user orders index" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      click_link 'Cart: 1'
      
      expect(current_path).to eq('/cart')
      
      within "#item-#{@ogre.id}" do
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $90.00")
      end
      
      expect(page).to have_content("Total: $90.00")
      
      click_button "Check Out"
      expect(current_path).to eq('/profile/orders')
      
      order = Order.last
      
      within "#order-#{order.id}" do
        expect(page).to have_content("Total: $90.00")
      end
    end
    
    it "order total displays correctly on the user orders order show page" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      click_link 'Cart: 1'
      
      expect(current_path).to eq('/cart')
      
      within "#item-#{@ogre.id}" do
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $90.00")
      end
      
      expect(page).to have_content("Total: $90.00")
      
      click_button "Check Out"
      
      order = Order.last
      
      click_link "#{order.id}"
      expect(current_path).to eq("/profile/orders/#{order.id}")
      
      order_item = OrderItem.last
      
      expect(page).to have_content("Total: $90.00")
      
      within "#order-item-#{order_item.id}" do
        expect(page).to have_content("Price: $45.00")
        expect(page).to have_content("Subtotal: $90.00")
      end
    end
  end
end