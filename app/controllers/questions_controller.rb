class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[destroy edit]
  before_action :set_subscription, only: %i[show update]
  helper_method :question
  after_action  :publish_question, only: %i[create]

  authorize_resource

  def index
    @questions = Question.all
    @award = Award.new
  end

  def show
    @new_answer = Answer.new
    @link = @new_answer.links.new
    question
    gon.current_user_id = current_user&.id
  end

  def new
    @link = question.links.new
    @award = question.build_award
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    attach_files(@question)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @questions = Question.all
    question.update(question_params)
    attach_files(question)
  end

  def destroy
    @question.best_answer&.unmark_as_best
    @question.destroy
    flash[:notice] = 'Your question was successfully deleted.'
    redirect_to root_path
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url _destroy],
                                                    award_attributes: %i[id title image _destroy])
  end

  def attach_files(question)
    question.files.attach(params[:question][:files]) if params[:question][:files].present?
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', { question: @question })
  end

  def set_subscription
    @subscription ||= current_user&.subscriptions&.find_by(question: question)
  end
end
