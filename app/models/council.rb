class Council < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  has_many :local_authorities
  has_many :courts, through: :local_authorities
end
