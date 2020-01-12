require 'rails_helper'

RSpec.describe 'Merchant can edit a coupon' do
  describe "New coupon" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @merchant_admin = @bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    end

    xit "can click a link to edit the coupon" do
      visit "/merchant"
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @bike_shop.id)
      within "#coupons" do
        within "#coupon-#{coupon_1.id}" do
          click_on("Edit #{coupon_1.name}")
          expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}/edit")
      end
    end
  end

    it "can edit a coupon" do
      coupon = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @bike_shop.id)

      visit "/merchant/coupons/#{coupon.id}/edit"

      fill_in 'Name', with: "10% off"
      fill_in 'Code', with: "Meow"
      fill_in 'Discount', with: 10.0

      click_on("Update Coupon")

      coupon.reload

      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Coupon was updated")
      expect(page).to have_content("Name: 10% off")
      expect(page).to have_content("Code: Meow")
      expect(page).to have_content("Discount: 10%")
    end
  end
end
