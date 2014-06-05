class Link < ActiveRecord::Base
	has_many :items , class_name: "SharedItem" , dependent: :destroy
	has_many :albums , through: :items ,source: :item, source_type: "Album"
	has_many :photos , through: :items ,source: :item, source_type: "Photo"
	validates :url  , uniqueness: true
	belongs_to :profile
	after_create :generate_url

	def set_items items , type
		if type == 'photo'
			self.photos = items
		elsif type=='album'
			self.albums = items
		end
	end

	def next_photo  id
		all_photos.where("id < ?", id).order("id DESC").first
	end

	def prev_photo  id

	end

	def position_in id

	end

	def all_photos
		if albums.any?
			return Photo.where(album: albums)
		else
			return photos
		end
	end

	def what_shared
		if albums.any?
			"Album"
		else
			"Photo"
		end
	end

	def items_shared
		if albums.any?
			albums.count
		else
			photos.count
		end
	end

	def albums_photos_count
		Photo.where(album: albums).count
	end

	private
		def generate_url
			hash = Digest::SHA256.hexdigest("#{SecureRandom.urlsafe_base64}#{self.id}")
			update_attributes(url: hash) 
		end
end
