class Town < ActiveRecord::Base
  belongs_to :county
  attr_accessible :name
end
