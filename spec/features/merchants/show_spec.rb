require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @user = User.create!(name: "Polly Esther", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "veryoriginalemail@gmail.com", password: "polyester", password_confirmation: "polyester")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
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

    it "a user can see all coupons for that merchant" do
      coupon_1 = Coupon.create(name: "15% off!!", code: "15% off!!", discount: 15, merchant_id: @bike_shop.id)
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to_not have_content("This merchant does currently have any coupons")
      expect(page).to have_content("#{@bike_shop.name}")


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
