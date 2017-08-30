module Admin
  class CourtTypesController < Admin::ApplicationController
    before_action :authorised?
    before_action :court_type, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @court_types = CourtType.order(:name)

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @court_types }
      end
    end

    def show
      respond_with @court_type
    end

    def new
      @court_type = CourtType.new

      respond_to do |format|
        format.html # new.html.erb
      end
    end

    def edit
      respond_with @court_type
    end

    def create
      @court_type = CourtType.new(params[:court_type])

      respond_to do |format|
        if @court_type.save
          message = 'Court type was successfully created.'
          format.html { redirect_to edit_admin_court_type_path(@court_type), notice: message }
          format.json { render json: @court_type, status: :created, location: court_type_link }
        else
          render_error_response(format, template: :new, model: @court_type)
        end
      end
    end

    def update
      respond_to do |format|
        if @court_type.update_attributes(params[:court_type])
          message = 'Court type was successfully updated.'
          format.html { redirect_to edit_admin_court_type_path(@court_type), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @court_type)
        end
      end
    end

    def destroy
      @court_type.destroy

      respond_to do |format|
        format.html { redirect_to admin_court_types_url }
        format.json { head :no_content }
      end
    end

    private

    def court_type_link
      admin_court_type_url(@court_type)
    end

    def court_type
      @court_type ||= CourtType.find(params[:id])
    end
  end
end
