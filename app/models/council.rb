class Council < ActiveRecord::Base
  belongs_to :court
  attr_accessible :name
  validates_presence_of :name
end
