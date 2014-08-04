# == Schema Information
#
# Table name: towns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  county_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :integer
#

class Town < ActiveRecord::Base
  attr_accessible :name, :county_id

  belongs_to :county
  
  default_scope order('LOWER(name)') # ignore case when sorting
end
