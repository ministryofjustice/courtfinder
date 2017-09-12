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
    let(:court) { create(:court) }
    let(:postcode_code) { 'ab101ab' }
    subject { PostcodeCourt.new(court: court, postcode: postcode_code) }

    before {
      OfficialPostcode.create(
        postcode: 'AB10 1AB',
        sector: 'AB10 1',
        district: 'AB10',
        area: 'AB'
      )
    }

    it 'forces the postcode to uppercase and correct format' do
      subject.save!
      expect(subject.reload.postcode).to eq('AB10 1AB')
    end

    context 'validates' do
      context 'postcode format' do
        let(:postcode_code) { 'yo165r' }
        it { expect(subject).not_to be_valid }
      end

      context 'existence of postcode' do
        let(:postcode_code) { 'AB10 1AC' }
        it { expect(subject).not_to be_valid }
      end

      context 'existence of sector' do
        let(:postcode_code) { 'AB10 1' }
        it { expect(subject).to be_valid }
      end

      context 'existence of district' do
        let(:postcode_code) { 'AB10' }
        it { expect(subject).to be_valid }
      end

      context 'existence of area' do
        let(:postcode_code) { 'AB' }
        it { expect(subject).to be_valid }
      end
    end
  end
end
