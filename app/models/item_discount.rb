class ItemDiscount < ApplicationRecord
  belongs_to :item
  belongs_to :discount
  
  validates_presence_of :item_id,
                        :discount_id,
                        :amount,
                        :num_items
end
