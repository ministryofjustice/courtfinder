class AreaOfLawGroup < ActiveRecord::Base
  attr_accessible :name

  has_many :areas_of_law, class_name: 'AreaOfLaw', foreign_key: 'group_id'

  validates :name, presence: true

  scope :with_areas_of_law, -> { includes(:areas_of_law).where('areas_of_law.id is not null')}

  delegate :to_s, to: :name
end
