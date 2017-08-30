module Admin
  class FacilitiesController < Admin::ApplicationController
    before_action :authorised?
    before_action :facility, except: [:index, :new, :create]
    respond_to :html, :json

    def index
      @facilities = Facility.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @facilities }
      end
    end

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @facility }
      end
    end

    def new
      @facility = Facility.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @facility }
      end
    end

    def edit
      respond_with @facility
    end

    def create
      @facility = Facility.new(params[:facility])

      respond_to do |format|
        if @facility.save
          message = 'Facility type was successfully created.'
          format.html { redirect_to facility_link, notice: message }
          format.json { render json: @facility, status: :created, location: facility_link }
        else
          render_error_response(format, template: :new, model: @facility)
        end
      end
    end

    def update
      respond_to do |format|
        if @facility.update_attributes(params[:facility])
          message = 'Facility type was successfully updated.'
          format.html { redirect_to facility_link, notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @facility)
        end
      end
    end

    def destroy
      @facility.destroy

      respond_to do |format|
        format.html { redirect_to admin_facilities_url }
        format.json { head :no_content }
      end
    end

    private

    def facility
      @facility ||= Facility.find(params[:id])
    end

    def facility_link
      admin_facility_path(@facility)
    end
  end
end
