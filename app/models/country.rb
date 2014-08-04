# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :integer
#

class Country < ActiveRecord::Base
  has_many :counties
  attr_accessible :name
end
