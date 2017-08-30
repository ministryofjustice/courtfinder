module Admin
  class ContactTypesController < Admin::ApplicationController
    before_action :authorised?
    before_action :contact_type, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @contact_types = ContactType.all
      respond_with @contact_types
    end

    def show
      respond_with @contact_type
    end

    def new
      @contact_type = ContactType.new
      respond_with @contact_type
    end

    def edit
      respond_with @contact_type
    end

    def create
      @contact_type = ContactType.new(params[:contact_type])

      respond_to do |format|
        if @contact_type.save
          message = 'Contact type was successfully created.'
          format.html { redirect_to admin_contact_type_path(@contact_type), notice: message }
          format.json { render json: @contact_type, status: :created, location: contact_type_link }
        else
          render_error_response(format, template: :new, model: @contact_type)
        end
      end
    end

    def update
      respond_to do |format|
        if @contact_type.update_attributes(params[:contact_type])
          message = 'Contact type was successfully updated.'
          format.html { redirect_to admin_contact_type_path(@contact_type), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @contact_type)
        end
      end
    end

    def destroy
      @contact_type.destroy

      respond_to do |format|
        format.html { redirect_to admin_contact_types_url }
        format.json { head :no_content }
      end
    end

    private

    def contact_type
      @contact_type ||= ContactType.find(params[:id])
    end

    def contact_type_link
      admin_contact_type_url(@contact_type)
    end
  end
end
