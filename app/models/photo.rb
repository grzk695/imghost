class Photo < ActiveRecord::Base

	has_attached_file :photo, {
		:styles=>{:thumb => "200x150#",:ico=>"50x30#"},
		:url => "/system/:style/:hash.:extension",
		:hash_secret => "photo",
		:hash_data => ":class/:attachment/:id/:style/:created_at" # shoud be :updated_at, instead of :crated_at but there is a bug in paperclip
		#:storage => ((Rails.env.production? || Rails.env.staging?) ? :filesystem : :dropbox )
		#:storage => :dropbox,
    	#:dropbox_credentials => Rails.root.join("config/dropbox.yml"),
	}

  attr_accessor :token

	belongs_to :profile
  belongs_to :album
	
  has_many :shared_items , as: :item , dependent: :destroy
  has_many :links , through: :shared_items 

	validates :photo, presence: true
	validates :title, length: {maximum: 30}
	validates :description, length:{maximum: 200}
	validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

	self.per_page = 21

	include Rails.application.routes.url_helpers

  def rotate! direction
    if direction == "left"
      angle = -90;
    elsif direction == "right"
      angle = 90;
    end

    require 'RMagick'

    img = Magick::Image.read(self.photo.path).first()
    img2 = img.rotate(angle)
    img2.write(self.photo.path)
    img.destroy!
    img2.destroy!

    self.photo.reprocess!
  end

	def to_jq_upload
    {
      "name" => read_attribute(:photo_file_name),
      "size" => read_attribute(:photo_file_size),
      "url" => photo.url(:original),
      "delete_url" => photo_path(self),
      "delete_type" => "DELETE" ,
      "thumbnail_url"=> photo.url(:ico)
    }
  	end

  	def self.by_profile_name (name )
  		 photos = Photo.joins(:profile).where("profiles.name = ?",name)
       photos = photos.order('created_at DESC')
  	end

    def self.by_album (id)
      Photo.joins(:album).where("albums.id = ?",id).order('created_at DESC')
    end

    def self.by_profile_and_album (profile_id,album_id)
      Photo.joins(:profile)
        .where("profiles.id = ? ",profile_id).where(:album_id => album_id)
        .order("created_at DESC")
    end

    def self.by_link link , id
      l = Link.where(url: link).first
      if l
        l.all_photos.where("photos.id = ?",id).first
      else
        return nil
      end
    end

  	def next_for (owner_kind,link,loged)
  		if owner_kind == "profile"
  			p = profile.photos.where("id < ?", id)
        p = p.where( :public => true) unless loged==true
        return p.order("id DESC").first
  		elsif owner_kind == 'album'
        album.photos.where("id < ?", id).order("id DESC").first
      elsif owner_kind == 'gallery'
        Photo.where(:public => true).where("id < ?",id).order("id DESC").first
      elsif owner_kind == 'link'
        Link.where(url: link).first.all_photos.where("photos.id < ?", id).order("id DESC").first
  		end
  	end

  	def prev_for (owner_kind,link,loged)
  		if owner_kind == "profile"
  			p = profile.photos.where("id > ?", id)
        p = p.where( :public => true) unless loged==true
        return p.order("id ASC").first
  		elsif owner_kind == 'album'
        album.photos.where("id > ?", id).order("id ASC").first
      elsif owner_kind == 'gallery'
        Photo.where(:public => true).where("id > ?",id).order("id ASC").first
  		elsif owner_kind == 'link'
        Link.where(url: link).first.all_photos.where("photos.id > ?", id).order("photos.id ASC").first
      end
  	end

  	def position_in (owner_kind,link,loged)
  		if owner_kind=='profile'
  			p=profile.photos
        p=p.where( :public => true) unless loged==true
        p=p.order(created_at: :desc).index(self)+1
      elsif owner_kind=='album'
        album.photos.order(created_at: :desc).index(self)+1
      elsif owner_kind=='gallery'
        Photo.where(:public => true).order(id: :desc).index(self)+1
  		elsif owner_kind == 'link'
        Link.where(url: link).first.all_photos.order(created_at: :desc).index(self)+1
      end
  	end

  	def count_for (owner_kind,link,loged)
  		if owner_kind=='profile'
  			p=profile.photos
        p = p.where( :public => true) unless loged==true
        p.count
      elsif owner_kind=='album'
        album.photos.count
  		elsif owner_kind == 'link'
        Link.where(url: link).first.all_photos.count
      elsif owner_kind=='gallery'
        Photo.where(:public => true).count
      end
  	end

end
