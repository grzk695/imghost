class PhotosController < ApplicationController
  
  before_action :get_photo, only: [:show]
  before_action :check_signin, only: [:new_camera]

  helper :headshot



  def new_camera
  end

  def new
  	@photo = Photo.new()
  end

  def index
    @photos = Photo.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos.map{|upload| upload.to_jq_upload } }
    end
  end

   def show
      respond_to do |format|
        format.html # show.html.erb
        format.js
      end
   end

  def to_private
    @photo = Photo.find(params[:id])
    respond_to do |format|
      if @photo.update_attributes(:public => false)
        format.js { render 'admin_panel' }
      else
        format.js { render 'shared/errors', :locals => {:resource => @photo } }
      end
    end
  end

  def delete_from_album
    @photo = Photo.find(params[:id])
    @photo.update_attributes(:album_id => nil)
    respond_to do |format|
      format.js {render 'admin_panel'}
    end
  end

  def to_public
    @photo = Photo.find(params[:id])
    respond_to do |format|
      if @photo.update_attributes(:public => true)
        format.js { render 'admin_panel' }
      else
        format.js { render 'shared/errors', :locals => {:resource => @photo } }
      end
    end
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @photo = Photo.new(photo_params)
    @photo.profile = current_user.profile if user_signed_in?
    respond_to do |format|
      if @photo.save
        format.html {
          render :json => [@photo.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@photo.to_jq_upload]}, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @photo = Photo.find(params[:id])
    respond_to do |format|
      if @photo.update_attributes(photo_params)
        format.js
      else
        format.js { render 'shared/errors' , :locals => {:resource => @photo }}
      end
    end 
  end

  def destroy_many
    how = Photo.where(:id => params[:ids] , :profile_id => current_user.profile.id ).destroy_all()

    respond_to do |format|
      flash[:notice] = "#{how.count} photos has been deleted"
      format.js { render :js => "window.location='#{profile_photos_path(current_user.profile.name)}'" }
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    respond_to do |format|
      if @photo.destroy
        format.js { }
      else
        format.js { render 'shared/errors' , :locals => {:resouce => @photo }}
      end
    end
  end

  def edit
    @photo = Photo.find(params[:id])
    respond_to do |format|
      format.js 
    end
  end


  private
  	def photo_params
  		params.require(:photo).permit(:photo,:title,:description)
  	end

    def get_photo
      @photo = Photo.find(params[:id])
      @photo.increment!(:views)
      if params[:type]
        @type = params[:type]
        @next = @photo.next_for(@type)
        @prev = @photo.prev_for(@type)
        @position = @photo.position_in(@type)
        @total = @photo.count_for(@type)
      end
    end
end
