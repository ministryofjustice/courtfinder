class AreaOfLaw < ActiveRecord::Base
  attr_accessible :name, :old_id, :slug
  has_many :courts_areas_of_law
  has_many :courts, :through => :courts_areas_of_law

  default_scope :order => 'areas_of_law.name'

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  include Rails.application.routes.url_helpers

  # Text search
  def self.search(search)
    where('LOWER(name) like ?', "%#{search.downcase}%").order('name ASC')
  end

  def as_json(options={})
    {
      name: name,
      path: area_of_law_path(self)
    }
  end

  def self.has_courts
    includes(:courts).where('courts.id IS NOT NULL')
  end

  def empty?
    courts.count.zero?
  end
end
