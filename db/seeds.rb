# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
User.destroy_all
ItemOrder.destroy_all
Order.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#users
user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
merchant_employee_1 = User.create!(name: "Merchant Employee 1", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee_1", password_confirmation: "merchant_employee_1", role: 1)
merchant_employee_2 = dog_shop.users.create!(name: "Merchant Employee 2", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee_2@merchant_employee_2.com", password: "merchant_employee_2", password_confirmation: "merchant_employee_2", role: 1)
merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)

#orders
order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
order_2 = user.orders.create!(name: 'Mike', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)
item_order_2 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 1)
item_order_3 = order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 10)
item_order_4 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 7)
item_order_5 = order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 20)

#coupons
coupon = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: bike_shop.id)
