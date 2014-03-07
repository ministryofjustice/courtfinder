require "spec_helper"

describe LocalAuthority do
  it { should belong_to :court }
  it { should belong_to :council }
  it { should respond_to :area_of_law }
end
