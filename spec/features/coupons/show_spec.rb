require 'rails_helper'

RSpec.describe "Coupon show page" do
  describe "Coupon" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @merchant_admin = @bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    end

    it "can view a coupon" do
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @bike_shop.id)
      visit "merchant/coupons/#{coupon_1.id}"

      expect(page).to have_content("Name: #{coupon_1.name}")
      expect(page).to have_content("Code: #{coupon_1.code}")
      expect(page).to have_content("Discount: 15%")
      click_on("Edit coupon")
      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}/edit")
    end
  end
end
