module Admin
  class CountiesController < Admin::ApplicationController
    before_action :authorised?
    before_action :county, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @counties = County.all
      respond_with @counties
    end

    def show
      respond_with @county
    end

    def new
      @county = County.new
      respond_with @county
    end

    def edit
      respond_with @county
    end

    def create
      @county = County.new(params[:county])

      respond_to do |format|
        if @county.save
          message = 'County was successfully created.'
          format.html { redirect_to edit_admin_county_path(@county), notice: message }
          format.json { render json: @county, status: :created, location: count_link }
        else
          render_error_response(format, template: :new, model: @county)
        end
      end
    end

    def update
      respond_to do |format|
        if @county.update_attributes(params[:county])
          message = 'County was successfully updated.'
          format.html { redirect_to edit_admin_county_path(@county), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @county)
        end
      end
    end

    def destroy
      @county.destroy

      respond_to do |format|
        format.html { redirect_to admin_counties_url }
        format.json { head :no_content }
      end
    end

    private

    def county
      @county ||= County.find(params[:id])
    end

    def count_link
      admin_county_url(@county)
    end
  end
end
