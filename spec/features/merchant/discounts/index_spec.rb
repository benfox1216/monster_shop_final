require 'rails_helper'

describe "As a merchant employee" do
  describe "when I visit the merchant dashboard" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ben = @megan.users.create(name: "Ben Fox", address: "2475 Field St", city: "Lakewood", state: "CO", zip: "80215", email: "benfox1216@gmail.com", password: "password")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ben)
      
      visit "/merchant"
    end

    it "I can click a link to view my discounts on the merchant discount index page" do
      click_link "Bulk Discounts"
      expect(page).to have_content("My Bulk Discounts")
      expect(page).to have_content("No discounts have been created")
      
      discount_1 = @megan.discounts.create!(percent_discount: 20, minimum_items: 5)
      discount_2 = @megan.discounts.create!(percent_discount: 25, minimum_items: 10)
      
      visit "/merchant/discounts"
      
      expect(page).to_not have_content("No discounts have been created")
      expect(page).to have_content("5% discount on 10 or more items")
      expect(page).to have_content("5% discount on 10 or more items")
    end
  end
end