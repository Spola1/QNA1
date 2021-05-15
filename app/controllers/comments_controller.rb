class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create]
  after_action  :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments/#{question_id}", comment: @comment)
  end

  def commentable_id
    param_name = (params[:commentable] + '_id').to_sym
    params[param_name]
  end

  def set_commentable
    @commentable = params[:commentable].classify.constantize.find(commentable_id)
  end

  def question_id
    if @commentable.is_a? Question
      @commentable.id
    else
      @commentable.question.id
    end
  end
end
