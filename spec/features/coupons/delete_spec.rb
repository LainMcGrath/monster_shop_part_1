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
  end
end
