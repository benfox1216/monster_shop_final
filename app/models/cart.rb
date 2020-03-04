class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end
  
  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    count_of(item.id) * price(item)
  end
  
  def price(item)
    if available_discounts(item) != []
      available_discounts(item).min
    else
      item.price
    end
  end
  
  def available_discounts(item)
    item.merchant.discounts.map do |discount|
      if count_of(item.id) >= discount.minimum_items
        item.price - (item.price * discount.percent_discount / 100.0)
      end
    end.compact
  end
end
