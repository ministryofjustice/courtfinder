module Admin
  class AddressesController < Admin::ApplicationController
    before_action :authorised?
    before_action :address, only: [:show, :edit, :update, :destroy]
    respond_to :html, :json

    def index
      @addresses = Address.all
      respond_with @addresses
    end

    def show
      respond_with @address
    end

    def new
      @address = Address.new
      respond_with @address
    end

    def edit
      respond_with @address
    end

    def create
      @address = Address.new(params[:address])

      respond_to do |format|
        if @address.save
          format.html { redirect_to adress_link, notice: success_message('created') }
          format.json { render json: @address, status: :created, location: adress_link }
        else
          render_error_response(format, template: :new, model: @address,
                                        message: 'Address could not be created.')
        end
      end
    end

    def update
      respond_to do |format|
        if @address.update_attributes(params[:address])
          format.html { redirect_to adress_link, notice: success_message('updated') }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @address,
                                        message: 'Address could not be updated.')
        end
      end
    end

    def destroy
      @address.destroy

      respond_to do |format|
        format.html { redirect_to admin_addresses_url }
        format.json { head :no_content }
      end
    end

    private

    def address
      @address ||= Address.find(params[:id])
    end

    def success_message(event)
      "Address was successfully #{event}."
    end

    def adress_link
      admin_address_url(@address)
    end
  end
end
