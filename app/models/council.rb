class Council < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  
  has_many :court_council_links
  has_many :courts, through: :court_council_links

  scope :by_name, -> { order('LOWER(name)') }
  scope :search, ->(query){ where('LOWER(name) like ?', "#{query.downcase}%").limit(10) }


end
