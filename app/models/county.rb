class County < ActiveRecord::Base
  belongs_to :country
  has_many :towns
  attr_accessible :name, :country_id

  default_scope :order => 'LOWER(name)' # ignore case when sorting
end
