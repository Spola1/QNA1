class AwardsController < ApplicationController
  def index
    @awards = current_user&.awards
  end

  def destroy
    @award = Award.find(params[:id])
    @award&.destroy if current_user&.author?(@award.question)
  end
end
