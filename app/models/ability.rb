class Ability
  include CanCan::Ability
  def initialize(user)
    can :read , [Photo,Album], :public => true
    if user
        can [:update,:destroy,:read],  [Photo, Album] , :profile_id => user.profile.id
        can :create , [Album,Photo,Link] , :profile_id => user.profile.id
        can :share , [Album,Photo] , :profile_id => user.profile.id
    end
  end
end
