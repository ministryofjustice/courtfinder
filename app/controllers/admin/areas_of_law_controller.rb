module Admin
  class AreasOfLawController < Admin::ApplicationController
    before_action :authorised?
    before_action :area_of_law, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @areas_of_law = AreaOfLaw.all
      respond_with @areas_of_law
    end

    def show
      respond_with @areas_of_law
    end

    def new
      @area_of_law = AreaOfLaw.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: admin_areas_of_law_path(@area_of_law) }
      end
    end

    def edit
      respond_with @areas_of_law
    end

    def create
      @area_of_law = AreaOfLaw.new(params[:area_of_law])

      respond_to do |format|
        if @area_of_law.save
          format.html { redirect_to admin_areas_of_law_path, notice: success_message('created') }
          format.json { render json: @area_of_law, status: :created, location: @area_of_law }
        else
          render_error_response(format, template: :new, model: @area_of_law,
                                        message: 'Could not create the Area of Law')
        end
      end
    end

    def update
      respond_to do |format|
        if @area_of_law.update_attributes(params[:area_of_law])
          format.html { redirect_to admin_areas_of_law_path, notice: success_message('updated') }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @area_of_law,
                                        message: 'Could not update the Area of Law')
        end
      end
    end

    def destroy
      @area_of_law.destroy

      respond_to do |format|
        format.html { redirect_to admin_areas_of_law_url }
        format.json { head :no_content }
      end
    end

    private

    def area_of_law
      @area_of_law ||= AreaOfLaw.find(params[:id])
    end

    def success_message(event)
      "Area of law was successfully #{event}."
    end
  end
end
