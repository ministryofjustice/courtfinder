# == Schema Information
#
# Table name: external_links
#
#  id             :integer          not null, primary key
#  text           :string(255)
#  url            :string(255)
#  always_visible :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ExternalLink < ActiveRecord::Base
  attr_accessible :text, :url, :always_visible
  has_and_belongs_to_many :court_types
  has_and_belongs_to_many :areas_of_law

  scope :visible, -> { where(always_visible: true) }
end
