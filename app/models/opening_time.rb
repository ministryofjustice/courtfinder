class OpeningTime < ActiveRecord::Base
  belongs_to :court
  belongs_to :opening_type
  attr_accessible :name, :court_id, :opening_type_id
end
