class Merchant::CouponsController < Merchant::BaseController

  def new
    merchant = Merchant.find_by(params[id: :merchant_id])
    @coupon = merchant.coupons.new
  end

  def create
    merchant = Merchant.find_by(params[id: :merchant_id])
    @coupon = merchant.coupons.create(coupon_params)
    if @coupon.save
      redirect_to "/merchant"
      flash[:notice] = "Coupon was successfully created"
    else
      flash[:notice] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    # merchant = Merchant.find_by(params[id: :merchant_id])
    @coupon = Coupon.find_by(params[id: :coupon_id])
  end

  def update
    @coupon = Coupon.find_by(params[id: :coupon_id])
    @coupon.update(coupon_params)
    if @coupon.save
      redirect_to "/merchant"
      flash[:notice] = "Coupon was updated"
    end
  end

  def show
    @coupon = Coupon.find_by(params[id: :coupon_id])
  end

  def destroy
    coupon = Coupon.find_by(params[id: :coupon_id])
    coupon.destroy
    redirect_to "/merchant"
    flash[:notice] = "#{coupon.name} has been deleted"
  end

 private

  def coupon_params
    params.require(:coupon).permit(:name,:code,:discount)
  end
end
