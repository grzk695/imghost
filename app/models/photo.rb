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

	belongs_to :profile
  belongs_to :album
	
	validates :photo, presence: true
	validates :title, length: {maximum: 30}
	validates :description, length:{maximum: 200}
	validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

	self.per_page = 21

	include Rails.application.routes.url_helpers

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

  	def self.by_profile_name (name, all = false )
  		 photos = Photo.joins(:profile).where("profiles.name = ?",name)
       photos = photos.where(public: true) unless all
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

  	def next_for (owner_kind)
  		if owner_kind == "profile"
  			profile.photos.where("id < ?", id).order("id DESC").first
  		elsif owner_kind == 'album'
        album.photos.where("id < ?", id).order("id DESC").first
  		end
  	end

  	def prev_for (owner_kind)
  		if owner_kind == "profile"
  			profile.photos.where("id > ?", id).order("id ASC").first
  		elsif owner_kind == 'album'
        album.photos.where("id > ?", id).order("id ASC").first
  		end
  	end

  	def position_in (owner_kind)
  		if owner_kind=='profile'
  			profile.photos.order(created_at: :desc).index(self)+1
      elsif owner_kind=='album'
        album.photos.order(created_at: :desc).index(self)+1
  		end
  	end

  	def count_for (owner_kind)
  		if owner_kind=='profile'
  			profile.photos.count
      elsif owner_kind=='album'
        album.photos.count
  		end
  	end

end
