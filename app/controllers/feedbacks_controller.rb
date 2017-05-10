class FeedbacksController < ApplicationController
  def index; end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.valid?
      params["service"] = request.env['SERVER_NAME']
      params["browser"] = request.env['HTTP_USER_AGENT']
      params["ip"] = request.env['HTTP_X_FORWARDED_FOR']
      NotificationsMailer.new_message(params).deliver_now
      redirect_to feedback_path
    else
      render "new"
    end
  end

  def show; end
end
