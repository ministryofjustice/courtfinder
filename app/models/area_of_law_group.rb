# == Schema Information
#
# Table name: area_of_law_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AreaOfLawGroup < ActiveRecord::Base
  attr_accessible :name

  has_many :areas_of_law, ->{ order('areas_of_law.name') }, class_name: 'AreaOfLaw', foreign_key: 'group_id'

  validates :name, presence: true

  scope :with_areas_of_law, -> { includes(:areas_of_law).where('areas_of_law.id is not null')}

  delegate :to_s, to: :name
end
