# == Schema Information
#
# Table name: court_types_courts
#
#  id            :integer          not null, primary key
#  court_id      :integer
#  court_type_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CourtTypesCourt < ActiveRecord::Base
  belongs_to :court
  belongs_to :court_type
  attr_accessible :court_id, :court_type_id
  has_paper_trail meta: {ip: :ip}
end
