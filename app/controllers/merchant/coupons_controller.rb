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
    end
  end

 private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :discount)
  end

end
