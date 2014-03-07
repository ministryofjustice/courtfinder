class Admin::CouncilsController < Admin::ApplicationController
  respond_to :html, :json

  def complete
    @councils = Council.search(params[:term])
    respond_with @councils.map(&:name)
  end

end