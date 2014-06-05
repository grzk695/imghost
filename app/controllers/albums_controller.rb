class AlbumsController < ApplicationController
  load_and_authorize_resource only: [:edit , :update , :destroy , :show  ]

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @album.update_attributes album_params
        format.js 
      else
        format.js { render 'shared/errors', :locals => {:resource => @album } }
      end
    end
  end

  def destroy
    @album.destroy
    respond_to do |format|
      format.js { render js: "window.location='#{profile_albums_path(current_user.profile.name)}'" }
    end
  end
  
  def show
    @photos = @album.photos.order('created_at DESC').paginate(:page => params[:page])
    @type = "album"
    @album.increment!(:views)
    generate_refresh_token params[:id],params[:page]
    respond_to do |format|
      format.html
      format.js { render render 'shared/show_pagination' }
    end
  end

  def create
    @album = Album.new(album_params)
    @album.profile = current_user.profile
    authorize! :create , @album
    respond_to do |format|
      if @album.save
        @albums = @album.profile.albums.paginate( :page => 1)
        format.js
      else
        format.js { render "shared/errors" , :locals => {:resource => @album }}
      end
    end
  end
  
  def by_user
  	@profile = Profile.find_by_name params[:profile]
  	unless @profile
  		redirect_to root_path , :flash => { :warning => "Profile #{params[:profile]} not found"}
  		return
  	end
  	@albums = @profile.albums.accessible_by(current_ability,:read).order('name')
    @albums = @albums.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def add_photos
    album = Album.find(params[:id])
    authorize! :edit, album
    photos = Photo.where(:id => params[:ids]).accessible_by(current_ability,:edit)
    album.update_attributes(photos: photos)
    respond_to do |format|
      format.js 
    end
  end

  def album_photos
    @first = params[:first]
    @first||=false
    @album = Album.find(params[:id])
    authorize! :update , @album
    if params[:type] == 'in'
      @photos = Photo.by_album(params[:id])
    elsif params[:type] == 'out'
      @photos = Photo.by_profile_and_album(current_user.profile.id , nil)
    elsif params[:type] == 'all' 
      @photos = Photo.by_profile_name(current_user.profile.name)
    end
    @photos = @photos.accessible_by(current_ability,:edit)
    @photos = @photos.paginate(:page => params[:page] , :per_page => 15)  
    respond_to do |format|
      format.js 
    end
  end

  


  private
  	def album_params 
  		params.require(:album).permit(:name,:description,:public)
  	end

     def generate_refresh_token(id, page)
      if page
        @refresh_token = "/albums/#{id}?page=#{page}"
      else
        @refresh_token = "/albums/#{id}?page=1"
      end
    end
end
