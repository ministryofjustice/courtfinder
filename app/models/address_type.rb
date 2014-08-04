# == Schema Information
#
# Table name: address_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AddressType < ActiveRecord::Base
  has_many :addresses
  attr_accessible :name
end
