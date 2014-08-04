# == Schema Information
#
# Table name: court_council_links
#
#  id             :integer          not null, primary key
#  court_id       :integer
#  council_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  area_of_law_id :integer
#

require "spec_helper"

describe CourtCouncilLink do
  it { should belong_to :court }
  it { should belong_to :council }
  it { should belong_to :area_of_law }
end
