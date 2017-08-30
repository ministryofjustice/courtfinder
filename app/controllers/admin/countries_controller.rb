module Admin
  class CountriesController < Admin::ApplicationController
    before_action :authorised?
    before_action :country, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @countries = Country.all
      respond_with @countries
    end

    def show
      respond_with @country
    end

    def new
      @country = Country.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @country }
      end
    end

    def edit
      respond_with @country
    end

    def create
      @country = Country.new(params[:country])

      respond_to do |format|
        if @country.save
          message = 'Country was successfully created.'
          format.html { redirect_to edit_admin_country_path(@country), notice: message }
          format.json { render json: @country, status: :created, location: countries_link }
        else
          render_error_response(format, template: :new, model: @country)
        end
      end
    end

    def update
      respond_to do |format|
        if @country.update_attributes(params[:country])
          message = 'Country was successfully updated.'
          format.html { redirect_to edit_admin_country_path(@country), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @country)
        end
      end
    end

    def destroy
      @country.destroy

      respond_to do |format|
        format.html { redirect_to admin_countries_url }
        format.json { head :no_content }
      end
    end

    private

    def country
      @country ||= Country.find(params[:id])
    end

    def countries_link
      admin_country_url(@country)
    end
  end
end
