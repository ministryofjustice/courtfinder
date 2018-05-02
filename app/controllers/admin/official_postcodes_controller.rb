module Admin
  class OfficialPostcodesController < Admin::ApplicationController
    before_action :authorised?
    respond_to :json

    def validate
      result = { valid: is_valid? }
      respond_with result
    end

    private

    def is_valid?
      postcode = params[:postcode]
      OfficialPostcode.is_valid_postcode?(postcode)
    end
  end
end
