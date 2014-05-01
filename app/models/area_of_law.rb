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
    grouped_areas = {
      'top-level' => [
        areas.select {|a| a.name == 'High court'  }[0],
        areas.select {|a| a.name == 'Immigration' }[0],
        areas.select {|a| a.name == 'Probate'     }[0]
      ],
      "Crime" => [
        areas.select {|a| a.name == 'Crime'             }[0].name,
        areas.select {|a| a.name == 'Domestic violence' }[0].name,
        areas.select {|a| a.name == 'Forced marriage'   }[0].name
      ],
      "Family" => [
        areas.select {|a| a.name == 'Adoption'          }[0].name,
        areas.select {|a| a.name == 'Children'          }[0].name,
        areas.select {|a| a.name == 'Civil partnership' }[0].name,
        areas.select {|a| a.name == 'Divorce'           }[0].name
      ],
      "Money and Property" => [
        areas.select {|a| a.name == 'Bankruptcy'        }[0].name,
        areas.select {|a| a.name == 'Money claims'      }[0].name,
        areas.select {|a| a.name == 'Repossession'      }[0].name
      ],
      "Work and Benefit" => [
        areas.select {|a| a.name == 'Employment'        }[0].name,
        areas.select {|a| a.name == 'Social security'   }[0].name
      ]
    }

    grouped_areas
  end

  def empty?
    courts.count.zero?
  end
end
