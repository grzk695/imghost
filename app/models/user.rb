class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, :autosave => true, :inverse_of => :user , :dependent => :destroy
  accepts_nested_attributes_for :profile

  validates :profile, presence: true
end
