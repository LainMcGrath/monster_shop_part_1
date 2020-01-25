class OrdersController < ApplicationController

  def new
    if session[:coupon]
      @coupon = Coupon.find_by(params[coupon_id: :coupon_id])
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    user = current_user
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
      if session[:coupon]
          coupon = Coupon.find_by(params[coupon_id: :coupon_id])
          Order.last.update(coupon_id: coupon.id)
          session.delete(:coupon)
        end
      redirect_to "/profile/orders"
      flash[:notice] = "Your order was created!"
    else
      flash[:notice] = order.errors.full_messages.to_sentence
      render :new
    end
  end

  def index
    @orders = current_user.orders
  end

  def cancel
    order = Order.find(params[:id])
    if order.status == "pending"
      order.update("status" => "cancelled")
      redirect_to '/profile'
      flash[:notice] = 'Your order has been cancelled'
    else
      redirect_to "/orders/#{order.id}"
      flash[:error] = "Your order can't be cancelled because the seller has shipped"
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
