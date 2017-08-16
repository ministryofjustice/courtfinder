require 'spec_helper'

describe Admin::OfficialPostcodesController do

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#validate" do
    let(:postcode) { create(:official_postcode).postcode }

    it "is valid" do
      get :validate, postcode: postcode, format: :json
      validation = JSON.parse(response.body)
      expect(validation['valid']).to be_truthy
    end

    it "is not valid" do
      get :validate, postcode: 'N10 2LZ', format: :json
      validation = JSON.parse(response.body)
      expect(validation['valid']).to be_falsey
    end
  end
end
