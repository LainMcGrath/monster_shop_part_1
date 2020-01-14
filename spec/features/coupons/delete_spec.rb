require 'rails_helper'

RSpec.describe "Merchant can delete a coupon" do
  describe "Delete a coupon" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @merchant_admin = @bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    end

    it "can delete a coupon from a coupon show page" do
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @bike_shop.id)

      visit "/merchant/coupons/#{coupon_1.id}"
      click_on("Delete coupon")
      expect(current_path).to eq("/merchant")
      expect(page).to have_content("#{coupon_1.name} has been deleted")
      expect(page).to_not have_content("Code: #{coupon_1.code}")
    end

    it "cannot delete a coupon if it has been used in an order" do
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @bike_shop.id)
      item_1 = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, coupon_id: coupon_1.id)
      item_order_1 = order_1.item_orders.create!(item: item_1, price: item_1.price, quantity: 5)

      visit "/merchant/coupons/#{coupon_1.id}"

      expect(page).to have_link("Edit coupon")
      expect(page).to_not have_link("Delete coupon")
      expect(page).to have_content("Coupon has been applied to an existing order and cannot be deleted")
    end
  end
end
