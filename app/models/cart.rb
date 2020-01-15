class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def merchant_subtotal(coupon_code)
    coupon = Coupon.find_by(code: coupon_code)
    item_ids = []
    @contents.each do |item_id, quantity|
      item_ids << Item.find(item_id)
    end
    prices = 0
    item_ids.each do |item|
      if item.merchant_id == coupon.merchant_id
        prices += item.price
      end
    end
    prices
  end

  def merchant_discounted_subtotal(coupon_code)
    coupon = Coupon.find_by(code: coupon_code)
    self.merchant_subtotal(coupon_code) - ( self.merchant_subtotal(coupon_code) * (coupon.discount * 0.01))

  end


  def discounted_total(coupon)
    total_with_discount = 0
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      if item.merchant_id == coupon['merchant_id']
        total_with_discount += (item.price - (item.price * (coupon['discount']*0.01))) * quantity
      else
        total_with_discount += item.price * quantity
      end
    end
    total_with_discount.round(2)
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end
end
