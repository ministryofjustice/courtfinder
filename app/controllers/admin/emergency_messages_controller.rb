class Admin::EmergencyMessagesController < Admin::ApplicationController
  before_action :authorised?

  # GET /courts/1/edit
  def edit
    @em = EmergencyMessage.find(params[:id])
  end

  def update
    @em = EmergencyMessage.find(params[:id])

    respond_to do |format|
      if @em.update_attributes(params[:emergency_message])
        format.html { redirect_to edit_admin_emergency_message_path(@em), notice: 'Emergency message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @em.errors, status: :unprocessable_entity }
      end
    end
  end
end
