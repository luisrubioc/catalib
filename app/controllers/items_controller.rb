class ItemsController < ApplicationController
  before_action :signed_in_user,
                only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:create, :edit, :update, :destroy]

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:success] = t :item_created
      redirect_to @item
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      flash[:success] = t :item_updated
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    flash[:success] = t :item_destroyed
    redirect_to libraries_url
  end

  private

    def item_params
      params.require(:item).permit(:title, :rating, :status, :lent, :notes)
    end

    # Before filters

    def correct_user
      @item = Item.find_by(id: params[:id])
      redirect_to root_url if @item.library.user != current_user
    end
    
end
