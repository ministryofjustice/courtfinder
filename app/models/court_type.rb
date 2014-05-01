class CourtType < ActiveRecord::Base
  attr_accessible :name, :old_id, :slug
  has_many :court_types_courts
  has_many :courts, :through => :court_types_courts

  has_paper_trail meta: {ip: :ip, network: :network}

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  include Rails.application.routes.url_helpers

  # Text search
  def self.search(search)
    where('LOWER(name) like ?', "%#{search.downcase}%").order('name ASC')
  end

  def as_json(options={})
    if options[:min]
      {
        :name => name,
        :path => court_type_path(self)
      }
    else
      {
        :created_at => created_at,
        :id => id,
        :name => name,
        :updated_at => updated_at,
        :path => court_type_path(self),
        :courts => courts.visible.map { |court|
          {
            :name => court.name,
            :path => court_path(court)
          }
        }
      }
    end
  end
end
