class Discount < ApplicationRecord
  belongs_to :merchant
  
  validates_presence_of :amount,
                        :num_items
  
end
