require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    xit "a user can see all coupons for that merchant" do
      visit "/merchants/#{@bike_shop.id}"

      coupon_1 = Coupon.create(name: "15% off", code: "15%", discount: 15, merchant_id: @bike_shop.id)
      coupon_2 = Coupon.create(name: "20% off", code: "20%", discount: 20, merchant_id: @bike_shop.id)
      coupon_3 = Coupon.create(name: "25% off", code: "25%", discount: 25, merchant_id: @bike_shop.id)

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_content("Name: #{coupon_1.name}")
        expect(page).to have_content("Code: #{coupon_1.code}")
        expect(page).to have_content("Discount: 15%")
      end
    end

    it "a user sees a notification if the merchant does not have any coupons" do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("This merchant does currently have any coupons")
    end
  end
end
