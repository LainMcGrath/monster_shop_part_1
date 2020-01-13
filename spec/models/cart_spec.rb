require 'rails_helper'
RSpec.describe Cart do
  describe "instance methods" do
  # it "creates methods" do
    before(:each) do
      @user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @meg.id)
      # @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      # @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 5)
      # @item_order_3 = @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 10)
      @cart = Cart.new({@dog_bone.id.to_s => 1,
                        @tire.id.to_s => 1})
    end

    it "can calculate merchant_subtotal" do
      expect(@cart.merchant_subtotal(@coupon_1.code)).to eq(100)
    end

    it "can calculate discounted_total" do
      expect(@cart.discounted_total(@coupon_1)).to eq(106)
    end

    it "can calculate merchant_discounted_subtotal" do
      expect(@cart.merchant_discounted_subtotal(@coupon_1.code)).to eq(85)
    end

    it "can calculate total" do
      expect(@cart.total).to eq(121)
    end

    it "can calculate subtotal" do
      expect(@cart.subtotal(@dog_bone)).to eq(21)
    end

    it "can find cart items" do
      expect(@cart.items).to eq({@dog_bone => 1, @tire => 1})
    end

    it "can find total_items" do
      expect(@cart.total_items).to eq(2)
    end

    it "can increase quantity of item in cart" do
      @cart.add_item(@dog_bone)
      expect(@cart.total_items).to eq(3)
    end
  end
end
