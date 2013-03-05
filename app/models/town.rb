class Town < ActiveRecord::Base
  belongs_to :county
  attr_accessible :name, :county_id
end
