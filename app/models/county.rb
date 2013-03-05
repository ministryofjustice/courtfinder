class County < ActiveRecord::Base
  belongs_to :country
  has_many :towns
  attr_accessible :name, :country_id
end
