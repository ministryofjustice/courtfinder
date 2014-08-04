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

class CourtCouncilLink < ActiveRecord::Base
  attr_accessible :name, :court_id, :council_id, :area_of_law_id, :court, :council, :area_of_law
  belongs_to :court
  belongs_to :council
  belongs_to :area_of_law

  scope :by_name, -> { includes(:court).order('LOWER(courts.name)') }
end
