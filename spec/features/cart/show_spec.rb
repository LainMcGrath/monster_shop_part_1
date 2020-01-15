require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        @coupon = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: @meg.id)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it "visitors see instructions that they must log in or register to checkout" do

        visit '/cart'

        expect(page).to have_content("You must register or log in before you checkout.")

        click_link "register"
        expect(current_path).to eq("/register")

        visit '/cart'

        click_link "log in"
        expect(current_path).to eq('/login')
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do not see the link to empty my cart or add a discount" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
        expect(page).to_not have_content("Discount code:")
        expect(page).to_not have_field(:code)
      end
    end
  end

  describe "I see the option to add a discount code if there is an item in my cart" do
    it "can see the discount code fields" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)

      visit "/items/#{tire.id}"
      click_on "Add To Cart"

      visit '/cart'

      expect(page).to have_content("Discount code")
      expect(page).to have_field(:code)
      fill_in :code, with: "WOOF!"
      click_on("Apply coupon")
      expect(current_path).to eq("/cart")
    end
  end

  describe "I see the amount discounted as well as the new total after entering a discount code" do
    it "can see the amount discounted and new total" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)

      visit "/items/#{tire.id}"
      click_on "Add To Cart"

      visit '/cart'

      fill_in :code, with: "WOOF!"
      click_on("Apply coupon")

      expect(current_path).to eq("/cart")
      expect(page).to have_content("#{coupon_1.name} applied")
      expect(page).to have_content("Merchant subtotal: $100")
      expect(page).to have_content("Discount amount: 15.0%")
      expect(page).to have_content("Merchant total with discount: $85")
      expect(page).to have_content("Total amount owed: $85")
    end
  end

  describe "I can enter multiple discount codes and the totals are updated when I do" do
    it "can enter a new discount code" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)
      coupon_2 = Coupon.create(name: "25% off", code: "MEOW!", discount: 25, merchant_id: meg.id)

      visit "/items/#{tire.id}"
      click_on "Add To Cart"

      visit '/cart'

      fill_in :code, with: "WOOF!"
      click_on("Apply coupon")

      fill_in :code, with: "MEOW!"
      click_on("Apply coupon")

      expect(current_path).to eq("/cart")
      expect(page).to have_content("#{coupon_2.name} applied")
      expect(page).to have_content("Merchant subtotal: $100")
      expect(page).to have_content("Discount amount: 25.0%")
      expect(page).to have_content("Merchant total with discount: $75")
      expect(page).to have_content("Total amount owed: $75")
    end

    describe "Discount only applies to coupon merchant items" do
      it "cart has many items from many merchants" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

        coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)

        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit "/items/#{paper.id}"
        click_on "Add To Cart"

        visit '/cart'

        fill_in :code, with: "WOOF!"
        click_on("Apply coupon")

        expect(current_path).to eq("/cart")
        expect(page).to have_content("#{coupon_1.name} applied")
        expect(page).to have_content("Merchant subtotal: $100")
        expect(page).to have_content("Discount amount: 15.0%")
        expect(page).to have_content("Merchant total with discount: $85")
        expect(page).to have_content("Total amount owed: $105")
      end
    end

    describe "the coupon code is valid" do
      it "cart has many items from many merchants" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

        coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)

        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit "/items/#{paper.id}"
        click_on "Add To Cart"

        visit '/cart'

        fill_in :code, with: "MEOW"
        click_on("Apply coupon")

        expect(current_path).to eq("/cart")
        expect(page).to have_content("MEOW does not exist")
        expect(page).to_not have_content("Merchant subtotal")
        expect(page).to_not have_content("Discount amount")
        expect(page).to_not have_content("Merchant total with discount")
        expect(page).to_not have_content("Total amount owed")
      end
    end

    describe "the coupon is saved in the cart if the user navigates away" do
      it "can apply a coupon and continue shopping" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

        coupon_1 = Coupon.create(name: "15% off", code: "WOOF!", discount: 15, merchant_id: meg.id)

        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit '/cart'

        fill_in :code, with: "WOOF!"
        click_on("Apply coupon")

        expect(page).to have_content("#{coupon_1.name} applied")
        expect(page).to have_content("Merchant subtotal: $100")
        expect(page).to have_content("Discount amount: 15.0%")
        expect(page).to have_content("Merchant total with discount: $85")
        expect(page).to have_content("Total amount owed: $85")

        visit "/items/#{paper.id}"
        click_on "Add To Cart"

        visit '/cart'
        expect(page).to_not have_content("#{coupon_1.name} applied")
        expect(page).to have_content("Merchant subtotal: $100")
        expect(page).to have_content("Discount amount: 15.0%")
        expect(page).to have_content("Merchant total with discount: $85")
        expect(page).to have_content("Total amount owed: $105")
      end
    end
  end
end
