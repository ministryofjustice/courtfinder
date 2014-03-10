require "spec_helper"

describe CourtCouncilLink do
  it { should belong_to :court }
  it { should belong_to :council }
  it { should belong_to :area_of_law }
end
