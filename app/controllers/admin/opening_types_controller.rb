module Admin
  class OpeningTypesController < Admin::ApplicationController
    before_action :authorised?
    before_action :opening_type, except: [:index, :new, :create]
    respond_to :html, :json

    def index
      @opening_types = OpeningType.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @opening_types }
      end
    end

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @opening_type }
      end
    end

    def new
      @opening_type = OpeningType.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @opening_type }
      end
    end

    def edit
      respond_with @opening_type
    end

    def create
      @opening_type = OpeningType.new(params[:opening_type])

      respond_to do |format|
        if @opening_type.save
          message = 'Opening type was successfully created.'
          format.html { redirect_to admin_opening_type_path(@opening_type), notice: message }
          format.json { render json: @opening_type, status: :created, location: opening_type_link }
        else
          render_error_response(format, template: :new, model: @opening_type)
        end
      end
    end

    def update
      respond_to do |format|
        if @opening_type.update_attributes(params[:opening_type])
          message = 'Opening type was successfully updated.'
          format.html { redirect_to admin_opening_type_path(@opening_type), notice: message }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @opening_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @opening_type.destroy

      respond_to do |format|
        format.html { redirect_to admin_opening_types_url }
        format.json { head :no_content }
      end
    end

    private

    def opening_type
      @opening_type ||= OpeningType.find(params[:id])
    end

    def opening_type_link
      admin_opening_type_url(@opening_type)
    end
  end
end
