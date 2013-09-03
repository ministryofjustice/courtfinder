class FeedbacksController < ApplicationController
  def index
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.valid?
      params["service"] = request.env['REMOTE_HOST']
      params["browser"] = request.env['HTTP_USER_AGENT']
      NotificationsMailer.new_message(params).deliver
      redirect_to feedback_path
    else
      render "new"
    end
  end

  def show
  end
end
