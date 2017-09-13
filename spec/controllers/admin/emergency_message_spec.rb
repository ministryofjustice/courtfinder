require 'spec_helper'

describe Admin::EmergencyMessagesController do
  let(:message) { create(:emergency_message, message: "Test message", show: false) }
  let(:user) { create(:user, name: 'hello', admin: true, email: 'lol@biz.info') }

  before :each do
    sign_in user
    EmergencyMessage.destroy_all
  end

  it "displays the emergency message screen" do
    get :edit, id: message.id
    response.should render_template('admin/emergency_messages/edit')
    response.should be_success
  end

  describe "#update" do
    let(:params) { { id: message.id, message: { name: 'Emergency message', show: true } } }

    context "that works" do
      it "does the update" do
        patch :update, params
      end
    end

    context "a html request" do
      it "redirects to the edit path" do
        patch :update, params
        response.should redirect_to(edit_admin_emergency_message_path(message.reload))
      end
    end
    context "a json request" do
      before { params[:format] = :json }

      it "responds with no content" do
        patch :update, params
        expect(response.status).to eq(204)
      end
    end
  end
end
