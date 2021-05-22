class LinksController < ApplicationController
  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link
    @link&.destroy
  end
end
