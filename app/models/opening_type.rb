# == Schema Information
#
# Table name: opening_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :integer
#

class OpeningType < ActiveRecord::Base
  has_many :opening_times
  attr_accessible :name, :old_id
end
