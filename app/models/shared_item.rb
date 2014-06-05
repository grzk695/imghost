class SharedItem < ActiveRecord::Base
	belongs_to :item, polymorphic: true
	belongs_to :link

	validates :link , presence: true 
	validates :item , presence: true

	def self.get_items ids , type
		if type == 'photo'
      		Photo.where(id: ids)
    	elsif type == 'album'
      		Album.where(id: ids)
    	end
	end
end
