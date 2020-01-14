class CartController < ApplicationController
  before_action :not_admin?

  def add_item
    if request.referrer.include? "cart"
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    redirect_to '/cart'
    else
      item = Item.find(params[:item_id])
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
    end
  end

  def show
    @items = cart.items
    @coupon = session[:coupon]
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def remove_item_quantity
    if session[:cart][params[:item_id]] < 2
      session[:cart].delete(params[:item_id])
      redirect_to '/cart'
    else
      session[:cart][params[:item_id]] -= 1
      redirect_to '/cart'
    end
  end


  def update_coupon
    coupon = Coupon.find_by(code: params[:code])
    if coupon
      session[:coupon] = coupon
      flash[:notice] = "#{coupon.name} applied."
    else
      flash[:error] = "#{params[:code]} does not exist."
    end
    redirect_to '/cart'
  end

  private

    def not_admin?
      if current_user
        render file: '/public/404' unless !current_user.admin?
      end
    end
end
