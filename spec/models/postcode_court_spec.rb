# == Schema Information
#
# Table name: postcode_courts
#
#  id           :integer          not null, primary key
#  postcode     :string(255)
#  court_number :integer
#  court_name   :string(255)
#  court_id     :integer
#

require 'spec_helper'

describe PostcodeCourt do
  describe 'being saved' do
    context 'with a lower-case postcode' do
      let(:court){ create(:court) }
      subject{PostcodeCourt.new(court: court, postcode: 'yo165rb')}

      it 'forces the postcode to uppercase' do
        subject.save!
        expect(subject.reload.postcode).to eq('YO165RB')
      end
    end
  end
end
