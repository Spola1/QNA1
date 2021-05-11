class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  helper_method :question

  def index
    @questions = Question.all
    @award = Award.new
  end

  def show
    @new_answer = Answer.new
    @link = @new_answer.links.new
    question
  end

  def new
    @link = question.links.new
    @award = question.build_award
  end

  def edit
    render :show, notice: "You can't edit someone else's question" unless current_user.author?(question)
  end

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
    if current_user.author?(question)
      question.update(question_params)
      attach_files(question)
    end
  end

  def destroy
    if current_user.author?(question)
      question.best_answer&.unmark_as_best
      question.destroy
      flash[:notice] = 'Your question was successfully deleted.'
    else
      flash[:notice] = "You cant't delete someone else's question"
    end
    redirect_to questions_path
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
end
