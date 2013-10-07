class LibrariesController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:create, :edit, :update, :destroy]

  def index
    @libraries = current_user.libraries.paginate(page: params[:page], 
                                                 per_page: 10)
  end

  def show
    @library = Library.find(params[:id])
    @items = @library.items.paginate(page: params[:page], per_page: 10)
  end

  def new
    @library = Library.new
  end

  def create
    @library = Library.new(library_params)
    if @library.save
      flash[:success] = t :library_created
      redirect_to @library
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @library.update_attributes(library_params)
      flash[:success] = t :library_updated
      redirect_to @library
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

    def library_params
      params.require(:library).permit(:title, :description, :content, :privacy)
    end

    # Before filters

    def correct_user
      @library = current_user.libraries.find_by(id: params[:id])
      redirect_to root_url if @library.nil?
    end
    
end
