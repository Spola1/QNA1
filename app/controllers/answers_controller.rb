class AnswersController < ApplicationController
  before_action :authenticate_user!
  helper_method :answer, :question

  def edit
    redirect_to answer.question, notice: "You can't edit someone else's answer" unless current_user.author?(answer)
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
  end

  def best
    answer.mark_as_best if current_user.author?(question)
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
    else
      flash.now[:notice] = "You cant't delete someone else's answer"
    end
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
