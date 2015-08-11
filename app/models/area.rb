# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  region_id  :integer
#  old_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Area < ActiveRecord::Base
  belongs_to :region
  has_many :courts
  attr_accessible :name, :region_id, :old_id

  default_scope { order(:name) }
end
