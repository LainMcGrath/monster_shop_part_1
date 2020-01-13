require 'rails_helper'

RSpec.describe "Create coupon" do
  describe "New coupon" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @merchant_admin = @bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    end

    it 'A merchant can create a new coupon' do
      visit "/merchant"

      click_on("Create new coupon")
      expect(current_path).to eq("/merchant/coupons/new")

      name = "25% off all items!"
      code = "WOOF"
      discount = 25

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Discount', with: discount

      click_on "Create Coupon"

      new_coupon = Coupon.last

      expect(current_path).to eq("/merchant")
      expect(page).to have_content("Coupon was successfully created")

      # cannot find css - come back to this
      within "#coupons" do
        within ".grid-container" do
          # within ".grid-item" do
            within "#coupon-#{new_coupon.id}" do
              expect(page).to have_content("Name: #{new_coupon.name}")
              expect(page).to have_content("Code: #{new_coupon.code}")
              expect(page).to have_content("Discount: 25%")
            # end
          end
        end
      end
    end

    it 'A merchant cannot create a new coupon without filling out all fields' do
      visit "/merchant"

      click_on("Create new coupon")
      expect(current_path).to eq("/merchant/coupons/new")

      name = "25% off all items!"
      discount = 25

      fill_in 'Name', with: name
      fill_in 'Discount', with: discount

      click_on "Create Coupon"

      expect(page).to have_content("Code can't be blank")
    end

    it 'A merchant cannot create a new coupon with more than a 100% discount' do
      visit "/merchant"

      click_on("Create new coupon")
      expect(current_path).to eq("/merchant/coupons/new")

      name = "25% off all items!"
      code = "WOOF"
      discount = 112

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Discount', with: discount

      click_on "Create Coupon"

      expect(page).to have_content("Discount must be less than or equal to 100")
    end

    xit 'A merchant can only create coupon with integer discount' do
      visit "/merchant"

      click_on("Create new coupon")
      expect(current_path).to eq("/merchant/coupons/new")

      name = "25% off all items!"
      code = "WOOF"
      discount = 11.2

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Discount', with: discount

      click_on "Create Coupon"

      expect(page).to have_content("Discount must be an integer")
    end
  end
end
