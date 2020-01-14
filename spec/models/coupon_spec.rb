require 'rails_helper'

RSpec.describe Coupon do
  describe "relationship" do
    it { should belong_to :merchant }
    it { should have_many :orders }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name}
    it { should validate_presence_of :code }
    it {should validate_uniqueness_of :code}
    it { should validate_presence_of :discount }
    it { validate_numericality_of(:discount).is_less_than(100) }
  end

  describe "instance methods" do
    it "can return if a coupon has been applied to an order" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: bike_shop.id)

      expect(coupon_1.no_orders).to eq(true)

      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, coupon_id: coupon_1.id)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)

      expect(coupon_1.no_orders).to eq(false)
    end
  end
end
