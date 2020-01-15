
class Order < ApplicationRecord
  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  enum status: ["pending", "packaged", "shipped", "cancelled"]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def order_discount_total(order_coupon_id)
    coupon = Coupon.find_by(id: order_coupon_id)
    self.grandtotal -  (self.grandtotal * (coupon.discount * 0.01))
  end

  def coupon_name(order_coupon_id)
    coupon = Coupon.find_by(id: order_coupon_id)
    coupon.name
  end

  def self.status(status_searching_for)
    # can take argument of "packaged", "pending", "shipped", or "cancelled"
    where(status: "#{status_searching_for}")
  end

  def self.fulfill(order_id)
    Order.where(id: order_id).update(status: 1)
  end
end
