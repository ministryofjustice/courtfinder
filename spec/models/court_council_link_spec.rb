require "spec_helper"

describe CourtCouncilLink do
  it { should belong_to :court }
  it { should belong_to :council }
  it { should respond_to :type }
end
