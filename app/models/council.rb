class Council < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name
  validates :name, uniqueness: true
  has_many :court_council_links
  has_many :courts, through: :court_council_links
end
