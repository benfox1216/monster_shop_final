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
    count_of(item.id) * item.price * (100 - discount(item))/100
  end
  
  def discount(item)
    item.merchant.discounts.best_discount(count_of(item.id)) || 0
  end
  
  def discounted_price(item)
    subtotal_of(item.id) / count_of(item.id)
  end
end
