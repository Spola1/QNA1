class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many   :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  after_commit :send_subscriptions, on: :create

  def mark_as_best
    transaction do
      question.update!(best_answer_id: id)
      question.award&.update!(user: user)
    end
  end

  def best?
    question.best_answer_id == id
  end

  def unmark_as_best
    transaction do
      question.update!(best_answer_id: nil)
      question.award&.update!(user: nil)
    end
  end

  private

  def send_subscriptions
    SubscriptionsJob.perform_later(self)
  end
end
