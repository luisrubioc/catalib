class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @libraries = Library.paginate(page: params[:page], :per_page => 10)
    end
  end
  
  def help
  end

  def about
  end

  def contact
  end
end
