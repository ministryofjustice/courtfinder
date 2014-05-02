class AreaOfLaw < ActiveRecord::Base
  attr_accessible :name, :old_id, :slug, :type_possession, :type_bankruptcy, :type_money_claims, :type_children, :type_adoption, :type_divorce
  has_many :courts_areas_of_law
  has_many :courts, :through => :courts_areas_of_law
  has_many :court_council_links

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

  def self.has_courts_grouped
    areas = includes(:courts).where('courts.id IS NOT NULL')
    group_areas_of_law(areas)
  end

  def empty?
    courts.count.zero?
  end

  private

    def self.group_areas_of_law(areas)
      groups = YAML.load_file("#{Bundler.root}/config/by_areas_of_law.yml")
      groups.inject({}) do |h, (k,v)|
        if k == 'top-level'
          h[k] = v.map{|area| areas.select {|a| a.name == area}.first}
        else
          h[k] = v.map{|area| areas.select {|a| a.name == area}.first.try(:name)}
        end
        h
      end
    end
end
