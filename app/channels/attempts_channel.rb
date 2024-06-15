class AttemptsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "attempts_#{params[:problem_id]}_#{params[:user_id]}"
  end

  def unsubscribed
    stop_all_streams
  end
end
