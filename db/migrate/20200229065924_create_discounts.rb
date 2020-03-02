class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :amount
      t.integer :num_items
      t.references :merchant, foreign_key: true
      
      t.timestamps
    end
  end
end
