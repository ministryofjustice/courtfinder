require 'spec_helper'

describe Admin::CourtsController do
  render_views

  after :each do
    response.headers['Cache-Control'].should be_nil
  end

  it "displays a list of courts" do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')

    get :index
    response.should render_template('admin/courts/index')
    response.should be_success
  end
end
