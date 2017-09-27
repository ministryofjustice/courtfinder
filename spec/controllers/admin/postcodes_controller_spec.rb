require 'spec_helper'

describe Admin::PostcodesController do
  let(:user) { create(:user, admin: true) }
  let(:court) { create(:court) }
  let(:postcode_court) { create(:postcode_court, court: court) }
  let(:postcode_court2) { build(:postcode_court, court: court, postcode: 'N1234') }

  before :each do
    sign_in user
  end

  describe 'PUT' do
    let(:court2) { create :court }

    context 'update' do
      it "moving to postcode_court" do
        c_params = {
          postcode_courts: [postcode_court.id]
        }
        put :update, id: court.id, court: c_params, move_to: { court: court2.id }
        expect(response).to render_template('admin/postcodes/_move')
      end

      it "postcodes to move not present" do
        expect(PostcodeCourt).not_to receive(:where)
        put :update, id: court.id, court: { postcode_courts: [] }
      end

      it "warning if postcodes to move not present" do
        put :update, id: court.id, court: { postcode_courts: [] }
        expect(flash['move_info']).to eql('No postcodes selected.')
      end

      it "no valid postcodes moved" do
        allow(PostcodeCourt).to receive(:where).with('court_id = ? and id in (?)', 0, [123]).and_return [postcode_court2]
        put :update, id: court.id, court: { postcode_courts: ['123'] }, move_to: { court: court.id }
        expect(flash['move_info']).to eql('0 postcode(s) moved successfully. 1 postcode(s) not moved because are not valid.')
      end

      it "1 valid postcode moved and 1 invalid not moved" do
        allow(PostcodeCourt).to receive(:where).with('court_id = ? and id in (?)', 0, [123, postcode_court.id]).and_return [postcode_court2, postcode_court]
        put :update, id: court.id, court: { postcode_courts: ['123', postcode_court.id] }, move_to: { court: court.id }
        expect(flash['move_info']).to eql('1 postcode(s) moved successfully. 1 postcode(s) not moved because are not valid.')
      end
    end
  end
end
