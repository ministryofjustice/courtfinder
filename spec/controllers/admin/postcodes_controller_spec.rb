require 'spec_helper'

describe Admin::PostcodesController do
  let(:user) { create(:user, admin: true) }
  let(:court) { create(:court) }
  let(:postcode_court) { create(:postcode_court, court: court) }

  before :each do
    sign_in user
  end

  describe 'PUT' do
    let(:court2) { create :court }

    context 'update' do
      it "change name of the town" do
        c_params = {
          postcode_courts: [postcode_court.id]
        }
        put :update, id: court.id, court: c_params, move_to: { court: court2.id }
        expect(response).to render_template('admin/postcodes/_move')
      end

      it "change name of the town" do
        expect(PostcodeCourt).not_to receive(:where)
        put :update, id: court.id, court: { postcode_courts: [] }
      end

      it "change name of the town" do
        put :update, id: court.id, court: { postcode_courts: [] }
        expect(flash['move_info']).to eql('No postcodes selected.')
      end
    end
  end
end