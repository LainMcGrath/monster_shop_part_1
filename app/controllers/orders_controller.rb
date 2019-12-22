class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/profile/orders"
      flash[:notice] = "Your order was created!"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    @orders = Order.all
  end

  def cancele
    order = Order.find(params[:id])
    packaged(order)
    if order.status == "pending"
      order.update("status" => "cancelled")
      redirect_to '/profile'
      flash[:notice] = 'Your order has been cancelled'
    else
      redirect_to "/orders/#{order.id}"
      flash[:error] = 'Your cant be cancelled because the seller has shipped'
    end
  end

  def packaged(orders)
    stats = 0
    orders.item_orders.each do |order|
    if order.status == "fulfilled"
      stat += 1
      end
    end

  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
