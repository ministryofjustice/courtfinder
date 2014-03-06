class Council < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  
  has_and_belongs_to_many :courts

  scope :by_name, -> { order('LOWER(name)') }
end
