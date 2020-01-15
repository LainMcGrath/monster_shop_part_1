class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find_by(params[id: :merchant_id])
  end

  def new
    @merchant = Merchant.find(params["merchant_id"])
    @auto_popu = params_f
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    binding.pry
      if item.save
        redirect_to "/merchants/#{@merchant.id}/items"
      else
        flash[:error] = item.errors.full_messages.to_sentence
        redirect_to "/merchant/#{@merchant.id}/items/new"
        @auto_popu = params_f
      end
    end

    def edit
      @item = Item.find(params[:items_id])
      @merchant = Merchant.find(params[:merchant_id])
    end

    def update
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:items_id])
      @item.update(params_f)
      if @item.save
        redirect_to "/merchant/#{@merchant.id}/items"
        flash[:succses] = "#{@item} has been Updated."
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        redirect_to "/merchant/#{@merchant.id}/#{@item.id}/edit"
      end
    end

    def update
      merchant = Merchant.find(params[:merchant_id])
      item = merchant.items.find(params[:item_id])
      item.toggle(:active?).save
      if item.active?
        flash[:success] = "#{item.name} is active and available for sale."
      else
        flash[:success] = "#{item.name} is deactivated and no longer for sale."
      end
      redirect_to "/merchants/#{merchant.id}/items"
    end


  def destroy
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.find(params[:item_id])
    item.destroy
    flash[:notice] = "#{item.name} has been deleted."
    redirect_to "/merchants/#{merchant.id}/items"
  end

private

  def item_params
    if params["image"] == ""
      params["image"]= 'https://www.broadwayjiujitsu.com/wp-content/uploads/2017/04/default-image.jpg'
      params.permit(:name,:description,:price,:inventory,:image)
    else
      params.permit(:name,:description,:price,:inventory,:image)
    end
  end

  def params_f
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
