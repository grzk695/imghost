class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
  	profile_photos_path(current_user.profile.name)
  end

  def check_signin
    unless user_signed_in?
      flash[:danger] = "You must be sign in."
      redirect_to login_path
    end
  end

  def headshot_post_save(file_path)
    @headshot_photo = Photo.new
    @headshot_photo.photo = File.new(file_path)
    @headshot_photo.profile = current_user.profile
    @headshot_photo.save
    File.delete(Rails.root+file_path)
  end
end
