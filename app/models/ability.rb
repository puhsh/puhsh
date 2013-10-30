class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
      can :manage, :all
    else
      can :manage, user
      can :read, AppInvite.where(user_id: user.id)
    end
  end
end
