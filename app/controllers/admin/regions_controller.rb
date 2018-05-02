module Admin
  class RegionsController < Admin::ApplicationController
    before_action :authorised?
    before_action :region, except: [:index, :new, :create]
    respond_to :html, :json

    def index
      @regions = Region.all
      respond_with @regions
    end

    def show
      respond_with @region
    end

    def new
      @region = Region.new
      respond_with @region
    end

    def edit
      respond_with @region
    end

    def create
      @region = Region.new(params[:region])

      respond_to do |format|
        if @region.save
          message = 'Region was successfully created.'
          format.html { redirect_to admin_region_path(@region), notice: message }
          format.json { render json: @region, status: :created, location: @region }
        else
          render_error_response(format, template: :new, model: @region)
        end
      end
    end

    def update
      @region = Region.find(params[:id])

      respond_to do |format|
        if @region.update_attributes(params[:region])
          message = 'Region was successfully updated.'
          format.html { redirect_to admin_region_path(@region), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @region)
        end
      end
    end

    def destroy
      @region = Region.find(params[:id])
      @region.destroy

      respond_to do |format|
        format.html { redirect_to admin_regions_url }
        format.json { head :no_content }
      end
    end

    private

    def region
      @region ||= Region.find(params[:id])
    end
  end
end
