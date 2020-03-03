require 'rails_helper'

describe "As a visitor" do
  describe "when I add enough of one item to my cart" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @megan.discounts.create!(percent_discount: 10, minimum_items: 2)
      @megan.discounts.create!(percent_discount: 20, minimum_items: 4)
      
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
    end

    it "The item subtotal applies lowest discount available" do
      visit item_path(@giant)
      click_button 'Add to Cart'
      click_link 'Cart: 1'
      
      expect(current_path).to eq('/cart')
      
      within "#item-#{@giant.id}" do
        expect(page).to have_content("Subtotal: $50.00")
        
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $90.00")
        
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $135.00")
        
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $160.00")
        
        click_button "More of This!"
        expect(page).to have_content("Quantity: 5")
        expect(page).to have_content("Subtotal: $200.00")
      end
      
      expect(page).to have_content("Total: $200.00")
    end
    
    it "and item from a store without discounts doesn't have discount applied" do
      visit item_path(@giant)
      click_button 'Add to Cart'
      
      visit item_path(@hippo)
      click_button 'Add to Cart'
      click_link 'Cart: 2'
      
      within "#item-#{@giant.id}" do
        expect(page).to have_content("Subtotal: $50.00")
        
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $90.00")
      end
      
      within "#item-#{@hippo.id}" do
        expect(page).to have_content("Subtotal: $50.00")
        
        click_button "More of This!"
        expect(page).to have_content("Subtotal: $100.00")
      end
      
      expect(page).to have_content("Total: $190.00")
    end
  end
end