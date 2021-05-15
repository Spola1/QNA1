class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :answer, only: %i[best destroy]
  after_action  :publish_answer, only: %i[create]
  helper_method :answer, :question

  authorize_resource

  def edit;  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    attach_files(@answer)
    @answer.save
  end

  def update
    attach_files(answer)
    answer.update(answer_params)
  end

  def best
    @answer.mark_as_best
  end

  def destroy
    @answer.unmark_as_best if @answer.best?
    @answer.destroy
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end

  def attach_files(answer)
    answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions/#{@answer.question_id}", answer: @answer, links: @answer.links)
  end
end
