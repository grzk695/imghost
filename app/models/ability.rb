class Ability
  include CanCan::Ability
  def initialize(user)
    can :read , Photo, :public => true
    can :index, Album, :public => true

    if user
        can [:update,:destroy,:read],  [Photo, Album] , :profile_id => user.profile.id
        can :index, Album, :profile_id => user.profile.id
        can :destroy_many, Array do |arr|
            arr.all? { |el| can?(:destroy,el) }
        end
    end
  end
end
