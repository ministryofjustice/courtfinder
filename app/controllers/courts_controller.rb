class CourtsController < ApplicationController
  
  respond_to :html, :json
  
  def index

    @search = params[:search]
    page = params[:page]
    per_page = params[:per_page]
    
    if @search

      # Remove whitespace either side of the string
      @search.strip

      # Postcode pattern
      postcode = /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1}))\d[abd-hjlnp-uw-z]{2})$/i
    
      # When postcode...
      if postcode =~ @search
        service_available = Rails.application.config.postcode_lookup_service_url rescue false
        
        if service_available
          @distance = params[:distance] || 10 # in miles

          # Turn postcode into latitude & longitude using MoJ postcode finder service
          # beginning = Time.now
          json = RestClient.post Rails.application.config.postcode_lookup_service_url, { :searchtext => params[:search], :searchbtn => 'Submit' }
          latlon = JSON.parse json
          # puts "*** Time elapsed #{Time.now - beginning} seconds ***"
          # latlon = [{'lat' => 51.768305511577, 'long' => -0.57250059493886}]

          # mile_in_meters = 32187
          # @courts = Court.within_radius(mile_in_meters, latlon[0]['lat'], latlon[0]['long']).all # activerecord-postgres-earthdistance method
          @courts = Court.near([latlon[0]['lat'], latlon[0]['long']], @distance, :order => :distance).paginate(:page => page, :per_page => per_page)
        else
          flash[:notice] = "Post code search unavailable"
        end

      else
        @courts = Court.search(@search, page, per_page)
      end

    else
      @courts = Court.order(:name).paginate(:page => page, :per_page => per_page)
    end
  
    respond_with @courts
  end
  
  def show
    @court = Court.find(params[:id])

    if request.path != court_path(@court, :format => params[:format])
      redirect_to court_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
end
