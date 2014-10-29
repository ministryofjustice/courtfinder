require 'spec_helper'

describe Jurisdiction do
  describe 'associations' do
    it { is_expected.to belong_to :remit }
    it { is_expected.to belong_to :local_authority }
  end
end
