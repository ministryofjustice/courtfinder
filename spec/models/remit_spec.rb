require 'spec_helper'

describe Remit do
  describe 'associations' do
    it { is_expected.to have_many :jurisdictions }
  end
end
