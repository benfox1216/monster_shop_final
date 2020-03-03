require 'rails_helper'

describe "As a merchant employee" do
  describe "when I visit the merchant dashboard" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @megan.discounts.create!(percent_discount: 20, minimum_items: 5)
      @discount_2 = @megan.discounts.create!(percent_discount: 25, minimum_items: 10)
      
      @ben = @megan.users.create(name: "Ben Fox", address: "2475 Field St", city: "Lakewood", state: "CO", zip: "80215", email: "benfox1216@gmail.com", password: "password")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ben)
      
      visit "/merchant/discounts"
    end
    
    it "beside each discount I see a link to edit the discount" do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link("edit")
      end
      
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_link("edit")
      end
    end
    
    it "I can edit a discount and see the new discount on the index page" do
      within "#discount-#{@discount_1.id}" do
        click_link "edit"
      end
      
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
      
      fill_in :percent_discount, with: 5
      fill_in :minimum_items, with: 10
      click_button "Update Discount"
      
      expect(current_path).to eq("/merchant/discounts")
      
      @discount_1.reload
      visit "/merchant/discounts"
      
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("5% discount on 10 or more items")
        expect(page).to_not have_content("20% discount on 5 or more items")
      end
    end
    
    it "my edit form is prefilled, and I cannot edit if I leave a field empty" do
      within "#discount-#{@discount_1.id}" do
        click_link "edit"
      end
      
      click_button "Update Discount"
      
      within "#discount-#{@discount_1.id}" do
        click_link "edit"
      end
      
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
      
      fill_in :percent_discount, with: ""
      fill_in :minimum_items, with: 10
      click_button "Update Discount"
      
      expect(page).to have_content("percent_discount: [\"can't be blank\"]")
      expect(page).to have_content("Edit Discount")
    end
  end
end