class Profile < ActiveRecord::Base 
	belongs_to :user
	has_many :photos, :inverse_of => :profile , :dependent => :destroy
	has_many :albums, :inverse_of => :profile , :dependent => :destroy
	validates :user, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true, length: {maximum: 30}

end
