require 'rails_helper'

describe ItemDiscount do
  describe 'Relationships' do
    it {should belong_to :item}
    it {should belong_to :discount}
  end
  
  describe 'Validations' do
    it {should validate_presence_of :item_id}
    it {should validate_presence_of :discount_id}
    it {should validate_presence_of :amount}
    it {should validate_presence_of :num_items}
  end
end