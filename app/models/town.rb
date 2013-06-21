class Town < ActiveRecord::Base
  belongs_to :county
  attr_accessible :name, :county_id
  
  default_scope :order => 'LOWER(name)' # ignore case when sorting
end
