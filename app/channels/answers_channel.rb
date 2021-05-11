class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:question]}"
  end

  def unsubscribed; end
end
