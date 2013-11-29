class PostcodeCourt < ActiveRecord::Base
  belongs_to :court
  attr_accessible :postcode
  validates_presence_of :postcode
end
