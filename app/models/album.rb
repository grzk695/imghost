class Album < ActiveRecord::Base
	belongs_to :profile
	has_many :photos , :dependent => :nullify
	
	has_many :shared_items , as: :item , dependent: :destroy
	has_many :links , through: :shared_items 
	
	validates :profile, presence: true
	validates :name, presence: true, length: {maximum: 50}
	validates :description, length: {maximum: 300}
	validates_uniqueness_of :name , :scope => :profile_id

	self.per_page = 15

	def self.by_profile id
		Album.joins(:profile).where("profiles.id = ?",id).order("created_at DESC");
	end
end
