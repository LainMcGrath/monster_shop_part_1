class CouponOrdersController < ApplicationController
  def new
    @coupon = Coupon.find(params[:coupon_id])
  end

  def create
    user = current_user
    coupon = Coupon.find_by(id: params[:coupon_id])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price,
          })
      end
      session.delete(:cart)
      session.delete(:coupon)
      Order.last.update(coupon_id: coupon.id)
      redirect_to "/profile/orders"
      flash[:notice] = "Your order was created!"
    else
      flash[:notice] = order.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def order_params
      params.permit(:name, :address, :city, :state, :zip)
    end
end
