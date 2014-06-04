class AlbumsController < ApplicationController
  
  def by_user
  	@profile = Profile.find_by_name params[:profile]
  	unless @profile
  		redirect_to root_path , :flash => { :warning => "Profile #{params[:profile]} not found"}
  		return
  	end
  	@albums = Album.by_profile(@profile.id).paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @album = Album.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @album = Album.find(params[:id])
    respond_to do |format|
      if @album.update_attributes album_params
        format.js 
      else
        format.js { render 'shared/errors', :locals => {:resource => @album } }
      end
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.js { render js: "window.location='#{profile_albums_path(current_user.profile.name)}'" }
    end
  end

  def add_photos
    ids = params[:ids]
    Photo.where.not(:id => ids).where(:album_id => params[:id]).update_all(:album_id => nil)
    Photo.where(:id => ids).update_all(:album_id => params[:id])

    respond_to do |format|
      format.js 
    end
  end

  def album_photos
    @first = params[:first]
    @first||=false
    @album = Album.find(params[:id])
    if params[:type] == 'in'
      @photos = Photo.by_album(params[:id]).paginate(:page => params[:page] , :per_page => 15)
    elsif params[:type] == 'out'
      @photos = Photo.by_profile_and_album(current_user.profile.id , nil).paginate(:page => params[:page] , :per_page => 15)
    elsif params[:type] == 'all' 
      @photos = Photo.photos_by_profile_name(current_user.profile.name).paginate(:page => params[:page] , :per_page => 15)
    end
      
    respond_to do |format|
      format.js 
    end
  end

  def show
  	@photos = Photo.by_album(params[:id]).paginate(:page => params[:page])
    @type = "album"
    @album = Album.find(params[:id])
    @album.increment!(:views)
    generate_refresh_token params[:id],params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
  	@album = Album.new(album_params)
  	@album.profile = current_user.profile
    
  	respond_to do |format|
      if @album.save
        @albums = @album.profile.albums.paginate( :page => 1)
        format.js
      else
        format.js { render "shared/errors" , :locals => {:resource => @album }}
      end
    end
  end


  private
  	def album_params 
  		params.require(:album).permit(:name,:description)
  	end

     def generate_refresh_token(id, page)
      if page
        @refresh_token = "/albums/#{id}?page=#{page}"
      else
        @refresh_token = "/albums/#{id}?page=1"
      end
    end
end
