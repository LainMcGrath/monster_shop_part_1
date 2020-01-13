require 'rails_helper'
RSpec.describe Cart do
  describe "instance methods" do
  # it "creates methods" do
    before(:each) do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @meg.id)
    end

    xit "can calculate merchant_subtotal" do
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      visit '/cart'

      fill_in :coupon_code, with: "WOOF!"
      click_on("Apply coupon")
      expect(cart.merchant_subtotal(@coupon_1.id)).to eq(100)
    end
  end
end
