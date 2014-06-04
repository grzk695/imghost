class PhotosController < ApplicationController
  before_action :get_photo_next_prev, only: [:show]
  before_action :check_signin, only: [:new_camera]
  before_action :get_photo_for_edit, only: [:delete_from_album, :to_private, :to_public]

  helper :headshot

  load_and_authorize_resource :only => [:edit , :update , :destroy]

  def edit
    respond_to do |format|
      format.js 
    end
  end

  def destroy
    respond_to do |format|
      if @photo.destroy
        format.js { }
      else
        format.js { render 'shared/errors' , :locals => {:resouce => @photo }}
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update_attributes(photo_params)
        format.js
      else
        format.js { render 'shared/errors' , :locals => {:resource => @photo }}
      end
    end 
  end

  def new
    @photo = Photo.new()
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.profile = current_user.profile if user_signed_in?
    respond_to do |format|
      if @photo.save
        format.json { render json: {files: [@photo.to_jq_upload]}, status: :created, location: @photo }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end 

  def index
    @photos = Photo.where(:public => true)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos.map{|upload| upload.to_jq_upload } }
    end
  end
  
  def show
    respond_to do |format|
      format.html 
      format.js
    end
    authorize! :read , @photo 
  end

  def delete_from_album
    @photo.update_attributes(:album_id => nil)
    respond_to do |format|
      format.js {render 'admin_panel'}
    end
  end

  def new_camera
  end

  def to_private
    respond_to do |format|
      if @photo.update_attributes(:public => false)
        format.js { render 'admin_panel' }
      else
        format.js { render 'shared/errors', :locals => {:resource => @photo } }
      end
    end
  end

  def to_public
    respond_to do |format|
      if @photo.update_attributes(:public => true)
        format.js { render 'admin_panel' }
      else
        format.js { render 'shared/errors', :locals => {:resource => @photo } }
      end
    end
  end

  def destroy_many
    @photos = Photo.where(:id => params[:ids]).accessible_by(current_ability,:destroy)
    how = @photos.destroy_all()
    respond_to do |format|
      flash[:notice] = "#{how.count} photos has been deleted"
      format.js { render :js => "window.location='#{profile_photos_path(current_user.profile.name)}'" }
    end
  end

  private

    def get_photo_for_edit
      @photo = Photo.find(params[:id])
      authorize! :update , @photo
    end

  	def photo_params
  		params.require(:photo).permit(:photo,:title,:description)
  	end

    def get_photo_next_prev
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
