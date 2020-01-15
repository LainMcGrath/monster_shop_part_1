require 'rails_helper'

RSpec.describe "Order show page", type: :feature do
  it "can show a specific order" do
    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user1@user.com", password: "user", password_confirmation: "user")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    item_order_1 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 1)
    item_order_2 = order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 10)

    items_array = [ item_order_1, item_order_2]
    visit "/profile/orders"

    click_on("Order Number: #{order_1.id}")
    expect(current_path).to eq("/profile/orders/#{order_1.id}")

    expect(page).to have_content("Order ID: #{order_1.id}")
    expect(page).to have_content("Order creation date: #{order_1.created_at.strftime('%m/%d/%Y')}")
    expect(page).to have_content("Order updated on: #{order_1.updated_at.strftime('%m/%d/%Y')}")
    expect(page).to have_content("Order status: #{order_1.status}")
    expect(page).to have_content("Total items ordered: 11")
    expect(page).to have_content("Order total: $220.00")

    within "#item-#{item_order_1.item_id}" do
      expect(page).to have_content(item_order_1.item.name)
      expect(page).to have_content(item_order_1.item.description)
      expect(page).to have_content(item_order_1.quantity)
      expect(page).to have_content(item_order_1.item.price)
      click_on "#{item_order_1.item.id}-photo"
      expect(current_path).to eq("/items/#{item_order_1.item_id}")
    end

  visit "/profile/orders/#{order_1.id}"
    within "#item-#{item_order_2.item_id}" do
      expect(page).to have_content(item_order_2.item.name)
      expect(page).to have_content(item_order_2.item.description)
      expect(page).to have_content(item_order_2.quantity)
      expect(page).to have_content(item_order_2.item.price)
      click_on "#{item_order_2.item.id}-photo"
      expect(current_path).to eq("/items/#{item_order_2.item_id}")
    end
  end

  it "can show coupons used on order show page" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    coupon = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, coupon_id: coupon.id)
    item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 1)

    visit "/orders/#{order_1.id}"

    expect(page).to have_content("Coupon used: #{coupon.name}")
    expect(page).to have_content("Order total with discount: $85.00")
  end

  it "does not show coupons section on order show page if no coupon was used" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 1)

    visit "/orders/#{order_1.id}"

    expect(page).to_not have_content("Coupon used: ")
    expect(page).to_not have_content("Order total with discount: $85.00")
  end
end
