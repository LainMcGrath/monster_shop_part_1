class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :coupons

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def orders_info
    item_orders.select('order_id, SUM(item_orders.quantity) AS total_quantity').group(:order_id)
    # can't get join to work...it defaults to INNER JOIN items due to the relationship I believe.

    # SELECT orders.created_at, SUM(item_orders.quantity) AS total_quantity, SUM(item_orders.price) AS total_price FROM item_orders JOIN orders ON item_orders.order_id = orders.id GROUP BY orders.id;
  end

  def order_price(order_id)
    orders = item_orders.where(order_id: order_id)

    orders.sum do |order|
      order.subtotal
    end
  end

  def item_orders_on_order(orderid)
    item_orders.where(order_id: orderid)
  end

end
