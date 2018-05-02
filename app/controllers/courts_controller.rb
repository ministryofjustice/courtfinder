class CourtsController < ApplicationController

  respond_to :html, :json, :csv

  before_action :find_court, except: [:index]
  before_action :set_vary_header, only: [:index, :show]

  def index
    render root_url
  end

  def information
    if request.path != information_path(@court, format: params[:format])
      redirect_to information_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def defence
    if request.path != defence_path(@court, format: params[:format])
      redirect_to defence_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def prosecution
    if request.path != prosecution_path(@court, format: params[:format])
      redirect_to prosecution_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def juror
    if request.path != juror_path(@court, format: params[:format])
      redirect_to juror_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def show
    if request.path != court_path(@court, format: params[:format])
      redirect_to court_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_to do |format|
        format.html
        format.json do
          render content_type: 'application/ld+json'
        end
      end
    end
  end

  private

  def find_court
    @court ||= Court.friendly.find(params[:id])
  end
end
