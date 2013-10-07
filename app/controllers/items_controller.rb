class ItemsController < ApplicationController
  before_action :signed_in_user,
                only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:create, :edit, :update, :destroy]

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Library.new
  end

  def create
    @item = Library.new(library_params)
    if @item.save
      flash[:success] = t :library_created
      redirect_to @item
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @item.update_attributes(item_params)
      flash[:success] = t :library_updated
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    Library.find(params[:id]).destroy
    flash[:success] = t :library_destroyed
    redirect_to libraries_url
  end

  private

    def item_params
      params.require(:item).permit(:title, :rating, :status, :lent, :notes)
    end

    # Before filters

    def correct_user
      @item = current_user.libraries.find_by(id: params[:id])
      redirect_to root_url if @item.nil?
    end
    
end
