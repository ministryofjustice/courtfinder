class Region < ActiveRecord::Base
  has_many :areas
  attr_accessible :name
end
