class PostcodeCourt < ActiveRecord::Base
  belongs_to :court
  attr_accessible :court_name, :court_number, :postcode
end
