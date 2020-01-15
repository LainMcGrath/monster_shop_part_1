require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      @order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 2)

      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#packaged' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      bike = meg.items.create(name: "Cool Bike", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pedal = meg.items.create(name: "Pedal", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      brake = meg.items.create(name: "Brake", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      handlebar = meg.items.create(name: "Handlebar", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      helmet = meg.items.create(name: "Helmet", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user2@user.com", password: "user", password_confirmation: "user")
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 1)
      order_2 = user.orders.create!(name: 'Mike', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_3 = user.orders.create!(name: 'Person', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 1)
      item_order_1 = order_1.item_orders.create!(item: bike, price: bike.price, quantity: 1)
      item_order_2 = order_2.item_orders.create!(item: bike, price: bike.price, quantity: 20)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)
      item_order_2 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 7)
      item_order_1 = order_1.item_orders.create!(item: pedal, price: pedal.price, quantity: 10)
      item_order_3 = order_3.item_orders.create!(item: handlebar, price: handlebar.price, quantity: 6)
      item_order_3 = order_3.item_orders.create!(item: helmet, price: handlebar.price, quantity: 4)
      item_order_3 = order_3.item_orders.create!(item: brake, price: brake.price, quantity: 2)

      expect(Order.status("packaged").first).to eq(order_1)
      expect(Order.status("packaged").last).to eq(order_3)
      expect(Order.status("pending")).to eq([order_2])
      expect(Order.status("shipped")).to eq([@order_1])
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    it "fulfill" do
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user2@user.com", password: "user", password_confirmation: "user")
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      expect(order_1.status).to eq('pending')
      expect(order_2.status).to eq('pending')

      Order.fulfill(order_1.id)
      order_1.reload
      order_2.reload

      expect(order_1.status).to eq('packaged')
      expect(order_2.status).to eq('pending')
    end

    it "can calculate grandtotal" do
      expect(@order_1.grandtotal).to eq(230.0)
    end

    it "can calculate order_discount_total" do
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @meg.id)
      expect(@order_1.order_discount_total(coupon_1.id)).to eq(195.5)
    end

    it "can find coupon name" do
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @meg.id)
      expect(@order_1.coupon_name(coupon_1.id)).to eq("15% off")
    end
  end
end
