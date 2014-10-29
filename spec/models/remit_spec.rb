require 'spec_helper'

describe Remit do
  describe 'associations' do
    it { is_expected.to have_many :jurisdictions }
    it { is_expected.to have_many(:local_authorities).through(:jurisdictions) }
  end
end
