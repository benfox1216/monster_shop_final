class Discount < ApplicationRecord
  belongs_to :merchant
  
  validates_presence_of :percent_discount,
                        :minimum_items
  
end
