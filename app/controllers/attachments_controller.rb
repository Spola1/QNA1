class AttachmentsController < ApplicationController
  def destroy
    @attach = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @attach
    @attach&.purge
  end
end
