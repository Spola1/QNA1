class AwardsController < ApplicationController
  # authorize_resource

  def index
    authorize! :index, Award
    @awards = current_user&.awards
  end

  def destroy
    @award = Award.find(params[:id])
    authorize! :destroy, @award.question
    @award&.destroy
  end
end
