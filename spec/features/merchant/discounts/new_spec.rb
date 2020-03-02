require 'rails_helper'

describe "As a merchant employee" do
  describe "when I visit the merchant dashboard" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ben = @megan.users.create(name: "Ben Fox", address: "2475 Field St", city: "Lakewood", state: "CO", zip: "80215", email: "benfox1216@gmail.com", password: "password")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ben)
      
      visit "/merchant/discounts"
    end
    
    it "I can create multiple discounts" do
      click_link "New Discount"
      expect(current_path).to eq("/merchant/discounts/new")

      fill_in :amount, with: 5
      fill_in :num_items, with: 10
      click_button "Create Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("5% discount on 10 or more items")
      
      click_link "New Discount"

      fill_in :amount, with: 10
      fill_in :num_items, with: 30
      click_button "Create Discount"
      
      expect(page).to have_content("5% discount on 10 or more items")
      expect(page).to have_content("10% discount on 30 or more items")
    end

    it "I cannot create a discount with an incomplete form" do
      click_link "New Discount"
      fill_in :amount, with: 5
      click_button "Create Discount"
      save_and_open_page
      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("description: [\"can't be blank\"]")
    end
  end
end
