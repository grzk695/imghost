class Album < ActiveRecord::Base
	belongs_to :profile
	has_many :photos , :dependent => :nullify

	validates :profile, presence: true
	validates :name, presence: true, length: {maximum: 50}
	validates :description, length: {maximum: 300}
	validates_uniqueness_of :name , :scope => :profile_id

	self.per_page = 15

	def self.by_profile id
		Album.joins(:profile).where("profiles.id = ?",id).order("created_at DESC");
	end
end
