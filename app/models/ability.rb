# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    end

    if user.has_role? :teacher
      can :manage, User, organization_id: user.organization_id
    end

    if user.has_role? :student
      can :read, User, id: user.id
    end
  end
end
