class OpeningType < ActiveRecord::Base
  has_many :opening_times
  attr_accessible :name
end
