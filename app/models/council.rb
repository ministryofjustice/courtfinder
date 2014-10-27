# == Schema Information
#
# Table name: councils
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Council < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  
  has_many :court_council_links
  has_many :courts, through: :court_council_links
  has_many :jurisdictions

  scope :by_name, -> { order('LOWER(name)') }
  scope :search, ->(query){ where('LOWER(name) like ?', "#{query.downcase}%").limit(10) }

  scope :unassigned_for_area_of_law, ->(area_of_law) {
    joins("LEFT OUTER JOIN court_council_links ON councils.id = court_council_links.council_id AND court_council_links.area_of_law_id = #{area_of_law.respond_to?(:id) ? area_of_law.id : area_of_law}").
    where('court_council_links.id IS NULL')
  }

end
