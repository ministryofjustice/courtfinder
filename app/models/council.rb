class Council < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name
  validates :name, uniqueness: true
  has_many :local_authorities
  has_many :courts, through: :local_authorities
end
