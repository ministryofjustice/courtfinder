class Council < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  
  has_many :court_council_links
  has_many :courts, through: :court_council_links

  scope :by_name, -> { order('LOWER(name)') }
  scope :search, ->(query){ where('LOWER(name) like ?', "#{query.downcase}%").limit(10) }

  scope :unassigned_for_area_of_law, ->(area_of_law) {
  	joins("left outer join court_council_links on councils.id = court_council_links.council_id and court_council_links.area_of_law_id = #{area_of_law.respond_to?(:id) ? area_of_law.id : area_of_law}").
  	where('council_id is NULL')
  }

end
