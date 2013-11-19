require 'spec_helper'

describe AddressesHelper do
  it "doesn't blow up when the town is nil" do
    helper.format_address(Address.new)
  end
end
