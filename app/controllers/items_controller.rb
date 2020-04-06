class ItemsController < ApplicationController

  before_action :set_item, only:[:show, :destroy]

  def index
    @items = Item.all
  end

  def get_category_children
    @category_children = Category.find_by(id: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def new
    @item = Item.new
    @item.images.new
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << [parent.name]
    
    end
  end

  def create
    @item = Item.new(item_params)
    @item.update(seller_id: current_user.id)
    binding.pry
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end


  def show
    @images = @item.images
  end

  def destroy
    if @item.destroy
      redirect_to user_path
    else
      render :show
    end
  end


  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :brand,:content, :price, :seller_id, :prefecture_id, :status_id, :cost_id, :delivery_day_id, :category_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end
end
