module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[vote_up vote_down vote_cancel]
    before_action :set_votable, only: %i[vote_up vote_down vote_cancel]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def vote_cancel
    vote(0)
  end

  private

  def vote(vote_value)
    if current_user
      @votable.vote(current_user, vote_value)
      render_json_with_rating(@votable)
    end
  end

  def render_json_with_rating(object)
    render json: { id: object.id, rating: object.rating, voted: current_user&.voted?(object), klass: object.class.to_s.downcase }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
