module Admin
  class EmergencyMessagesController < Admin::ApplicationController
    before_action :authorised?
    before_action :emergency_message
    respond_to :html, :json

    def edit
      respond_with @em
    end

    def update
      respond_to do |format|
        if @em.update_attributes(params[:emergency_message])
          message = 'Emergency message was successfully updated.'
          format.html { redirect_to edit_admin_emergency_message_path(@em), notice: message }
          format.json { head :no_content }
        else
          render_error_response(format, template: :edit, model: @em)
        end
      end
    end

    private

    def emergency_message
      @em ||= EmergencyMessage.find(params[:id])
    end
  end
end
