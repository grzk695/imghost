class ProfilesController < ApplicationController
  
  before_action :profiles_photos, only: :photos
  
  def show
  	@photos = [];
  end

  def photos
    respond_to do |format|
    	generate_refresh_token(params[:name],params[:page])
    	format.html
    	format.js 
    end
  end

  private

    def profiles_photos
      @photos = Photo.by_profile_name params[:name] 
      @photos = @photos.accessible_by(current_ability,:index)
      @photos = @photos.paginate page: params[:page], per_page: 24
      @profile_name = params[:name]
      @type = 'profile'
    end

    def generate_refresh_token(name, page)
      if page
        @refresh_token = "/profile/"+name+"/all?page="+page
      else
        @refresh_token = "/profile/"+name+"/all?page=1"
      end
    end
end
