class PostcodeCourt < ActiveRecord::Base
  belongs_to :court
  attr_accessible :postcode
  validates_presence_of :postcode, :court
  validates_uniqueness_of :postcode
  validates :postcode, :format => /[A-Za-z0-9]/
end
