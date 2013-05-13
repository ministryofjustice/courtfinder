class OpeningTime < ActiveRecord::Base
  belongs_to :court
  belongs_to :opening_type
  attr_accessible :name, :sort, :court_id, :opening_type_id
end
