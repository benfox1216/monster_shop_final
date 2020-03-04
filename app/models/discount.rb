class Discount < ApplicationRecord
  belongs_to :merchant
  
  validates_presence_of :percent_discount,
                        :minimum_items
  
  def self.best_discount(item_count)
    select(:percent_discount).where("minimum_items <= ?", item_count).pluck(:percent_discount).max
  end
end
