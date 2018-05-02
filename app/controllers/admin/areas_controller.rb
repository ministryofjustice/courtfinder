module Admin
  class AreasController < Admin::ApplicationController
    before_action :authorised?
    before_action :area, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @areas = Area.all
      respond_with @areas
    end

    def show
      respond_with @area
    end

    def new
      @area = Area.new
      respond_with @area
    end

    def edit
      respond_with @area
    end

    def create
      @area = Area.new(params[:area])

      respond_to do |format|
        if @area.save
          format.html { redirect_to edit_path, notice: success_message('created') }
          format.json { render json: @area, status: :created, location: admin_area_url(@area) }
        else
          render_error_response(format, template: :new, model: @area,
                                        message: 'Area could not be created.')
        end
      end
    end

    def update
      respond_to do |format|
        if @area.update_attributes(params[:area])
          format.html { redirect_to edit_path, notice: success_message('updated') }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @area,
                                        message: 'Area could not be updated.')
        end
      end
    end

    def destroy
      @area.destroy

      respond_to do |format|
        format.html { redirect_to admin_areas_url }
        format.json { head :no_content }
      end
    end

    private

    def area
      @area ||= Area.find(params[:id])
    end

    def success_message(event)
      "Area was successfully #{event}."
    end

    def edit_path
      edit_admin_area_path(@area)
    end
  end
end
