require 'rails_helper'

describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end
  
  describe 'Validations' do
    it {should validate_presence_of :percent_discount}
    it {should validate_presence_of :minimum_items}
  end
end