class Country < ActiveRecord::Base
  has_many :counties
  attr_accessible :name
end
