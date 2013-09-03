require 'spec_helper'

describe FeedbacksController do
  it "displays feedback form" do
    get :new
    response.should render_template('feedbacks/new')
    response.should be_success
  end

  before :each do
    @feedback_params = FactoryGirl.attributes_for(:feedback, {"rating" => 5, "text" => "what a beautiful site"})
  end

  it "redirects to show page on successful feedback submission" do
    post :create, :feedback => @feedback_params 
    response.should redirect_to feedback_path
  end

  it "sends notification email on successful feedback submission" do
    ActionMailer::Base.deliveries = []
    post :create, :feedback => @feedback_params 
    ActionMailer::Base.deliveries.last.should_not be_nil
  end
end
