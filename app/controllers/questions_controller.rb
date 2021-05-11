class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer ||= question.answers.new
  end

  def new; end

  def edit
    render :show, notice: "You can't edit someone else's question" unless current_user.author?(question)
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author?(question)
      if question.update(question_params)
        redirect_to question
      else
        render :edit
      end
    else
      render :show
    end
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      flash[:notice] = 'Your question was successfully deleted.'
    else
      flash[:notice] = "You cant't delete someone else's question"
    end
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
