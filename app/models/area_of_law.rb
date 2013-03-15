class AreaOfLaw < ActiveRecord::Base
  attr_accessible :name, :old_id, :slug
  has_many :courts_areas_of_law
  has_many :courts, :through => :courts_areas_of_law

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  # Text search
  def self.search(search)
    where('LOWER(name) like ?', "%#{search.downcase}%").order('name ASC')
  end
end
