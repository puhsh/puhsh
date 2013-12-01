class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
      can :manage, :all
    else
      can :manage, User, id: user.id
      can :manage, Device, user_id: user.id
      can :read, Star, user_id: user.id
      can :manage, Invite, user_id: user.id
      can :read, Category
      can :read, Subcategory
      can :manage, Post, user_id: user.id
      can :manage, Item, post: { user_id: user.id }
      can :manage, PostImage, post: { user_id: user.id }
      can :manage, FollowedCity, user_id: user.id
      can :read, City
    end
  end
end
