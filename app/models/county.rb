# == Schema Information
#
# Table name: counties
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :integer
#

class County < ActiveRecord::Base
  belongs_to :country
  has_many :towns
  attr_accessible :name, :country_id

  default_scope { order('LOWER(name)') } # ignore case when sorting
end
