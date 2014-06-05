class SharedItem < ActiveRecord::Base
	belongs_to :item, polymorphic: true
	belongs_to :link

	validates :link , presence: true , uniqueness: true
	validates :item , presence: true
end
