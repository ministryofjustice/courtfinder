# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  old_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#

class Region < ActiveRecord::Base
  has_many :areas
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]
end
