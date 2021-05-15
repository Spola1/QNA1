module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:value)
  end

  def vote(user, vote_value)
    if user.voted?(self)
      votes.where(user_id: user.id).delete_all
    elsif user_id != user.id
      votes.create(user_id: user.id, value: vote_value)
    end
  end
end
