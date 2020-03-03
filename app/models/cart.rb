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

  def subtotal_of(item_id)
    item = Item.find(item_id)
    price = item.price
    quantity = @contents[item.id.to_s]
    discounted_price = largest_discount(item.merchant.discounts, price, quantity)
    
    quantity * discounted_price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
  
  def largest_discount(merchant_discounts, price, quantity)
    discounted_price = merchant_discounts.map do |discount|
      if quantity >= discount.minimum_items
        price - (price * discount.percent_discount / 100.0)
      end
    end.compact
    
    if discounted_price != []
      discounted_price.min
    else
      price
    end
  end
end
