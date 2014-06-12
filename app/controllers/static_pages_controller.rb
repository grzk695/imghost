class StaticPagesController < ApplicationController
  def home
  	@photos = Photo.where(:public => true).accessible_by(current_ability,:read)
  	@photos = @photos.order("id DESC")
  	@photos = @photos.paginate(page: params[:page], per_page:30)
  	@type = "gallery"
  	respond_to do |format|
    	format.html
    	format.js { render 'shared/show_pagination' }
    end
  end

  def about
  end

  def help
  end

  def contact
  end

end
