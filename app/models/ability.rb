class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer],  user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :destroy, Link,  linkable: { user_id: user.id }
    can :destroy, Award, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can %i[vote_up vote_down vote_cancel], [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :best, Answer, question: { user_id: user.id }
  end
end
