class Api::CourtsController < ApplicationController
  respond_to :html
  layout "iframe"

  def show
    @court = Court.find(params[:id])
  end
end