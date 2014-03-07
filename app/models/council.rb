class Council < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name
  validates :name, uniqueness: true
  has_many :local_authorities
  has_many :courts, through: :local_authorities

  scope :by_name, -> { order('LOWER(name)') }
  scope :search, ->(query){ where('LOWER(name) like ?', "#{query.downcase}%").limit(10) }
end
