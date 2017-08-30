module Admin
  class AddressTypesController < Admin::ApplicationController
    before_action :authorised?
    before_action :address_type, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @address_types = AddressType.all
      respond_with @address_types
    end

    def show
      respond_with @address_type
    end

    def new
      @address_type = AddressType.new
      respond_with @address_type
    end

    def edit
      respond_with @address_type
    end

    def create
      @address_type = AddressType.new(params[:address_type])

      respond_to do |format|
        if @address_type.save
          message = 'Address type was successfully created.'
          format.html { redirect_to edit_admin_address_type_path(@address_type), notice: message }
          format.json { render json: @address_type, status: :created, location: address_type_link }
        else
          render_error_response(format, template: :new, model: @address_type)
        end
      end
    end

    def update
      respond_to do |format|
        if @address_type.update_attributes(params[:address_type])
          message = 'Address type was successfully updated.'
          format.html { redirect_to edit_admin_address_type_path(@address_type), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @address_type)
        end
      end
    end

    def destroy
      @address_type.destroy

      respond_to do |format|
        format.html { redirect_to admin_address_types_url }
        format.json { head :no_content }
      end
    end

    private

    def address_type
      @address_type ||= AddressType.find(params[:id])
    end

    def address_type_link
      admin_address_types_url(@address_type)
    end
  end
end
