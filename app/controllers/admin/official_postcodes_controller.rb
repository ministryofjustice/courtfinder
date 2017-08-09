module Admin
  class OfficialPostcodesController < Admin::ApplicationController
    before_action :authorised?
    respond_to :json

    def validate
      result = { valid: false }
      respond_with result
    end
  end
end