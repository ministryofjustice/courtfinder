# == Schema Information
#
# Table name: courts_areas_of_law
#
#  id             :integer          not null, primary key
#  court_id       :integer
#  area_of_law_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CourtsAreasOfLaw < ActiveRecord::Base
  belongs_to :court
  belongs_to :area_of_law
  attr_accessible :court_id, :area_of_law_id
  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip}
end
