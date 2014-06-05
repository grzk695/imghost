class LinksController < ApplicationController
  def show
    @link = Link.where(url: params[:url]).first();
    @photos = @link.all_photos.order('created_at DESC').paginate(page: params[:page], per_page:20)
    @type = "link"
    respond_to do |format|
      format.html
      format.js {render 'shared/show_pagination'}
    end
  end

  def create
    @link = Link.new
    @link.profile_id = current_user.profile.id if user_signed_in?
    items = SharedItem.get_items params[:ids] , params[:type]
    items = items.accessible_by(current_ability,:share)
    @link.set_items items, params[:type]
    respond_to do |format|
      if @link.save  
        format.html
        format.js
      else
        format.html
        format.js { render js: 'shared/errors' , locals: {resource: @link}}
      end
    end
  end

  def destroy
    @link = Link.find(params[:id])
    if @link.destroy
      flash[:notice] = "Link deleted!"
    else
      flash[:warning] = "Can not delete!"
    end
    redirect_to links_path    
  end

  def index
    if user_signed_in? 
      @links = current_user.profile.links
    else
      redirect_to login_path
    end
  end

  def show_photo
  end
end
