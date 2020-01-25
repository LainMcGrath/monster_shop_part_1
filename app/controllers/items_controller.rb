class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.where(active?: true)
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    merchant = Merchant.find(params[:merchant_id])
    @item = merchant.items.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    @item = merchant.items.create(item_params)
    if @item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find_by(params[id: :item_id])
  end

  def update
    merchant = Merchant.find_by(params[:merchant_id])
    @item = Item.find_by(params[:items_id])
    @item.update(params_f)
    if @item.save
      redirect_to "/items/#{@item.id}"
      flash[:succses] = "#{@item.name} has been Updated."
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
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
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end


end
