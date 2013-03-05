class AddressType < ActiveRecord::Base
  has_many :addresses
  attr_accessible :name
end
