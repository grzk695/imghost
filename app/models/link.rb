class Link < ActiveRecord::Base
	has_many :items , class_name: "SharedItem" , dependent: :destroy
	has_many :albums , through: :items ,source: :item, source_type: "Album"
	has_many :photos , through: :items ,source: :item, source_type: "Photo"
	validates :url , presence: true , uniqueness: true
end
