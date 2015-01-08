# == Schema Information
#
# Table name: court_facilities
#
#  id          :integer          not null, primary key
#  description :text
#  court_id    :integer
#  facility_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort        :integer
#

class CourtFacility < ActiveRecord::Base

  include Concerns::Court::GovUkPushable
  
  belongs_to :court
  belongs_to :facility
  attr_accessible :description, :facility_id, :sort
  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip}

  default_scope { order(:sort) }
end
