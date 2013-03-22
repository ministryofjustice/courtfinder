class Area < ActiveRecord::Base
  belongs_to :region
  has_many :courts
  attr_accessible :name, :region_id
end
