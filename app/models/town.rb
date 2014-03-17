class Town < ActiveRecord::Base
  attr_accessible :name, :county_id

  belongs_to :county
  
  default_scope order('LOWER(name)') # ignore case when sorting
end
