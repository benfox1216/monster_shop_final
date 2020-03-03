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
    
    it "beside each discount I see a link to delete the discount" do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link("delete")
      end
      
      within "#discount-#{@discount_2.id}" do
        expect(page).to have_link("delete")
      end
    end
    
    it "I can delete a discount, and see that the discount is gone from the index page" do
      expect(Discount.all.count).to eq(2)
      
      within "#discount-#{@discount_1.id}" do
        click_link "delete"
      end
      
      expect(Discount.all.count).to eq(1)
    end
  end
end