# == Schema Information
#
# Table name: court_types
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  old_description :string(255)
#  old_id          :integer
#  old_ids_split   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string(255)
#

class CourtType < ActiveRecord::Base
  attr_accessible :name, :old_id, :slug
  has_many :court_types_courts
  has_many :courts, through: :court_types_courts
  has_and_belongs_to_many :external_links

  has_paper_trail meta: { ip: :ip }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]

  include Rails.application.routes.url_helpers

  # Text search
  def self.search(search)
    where('LOWER(name) like ?', "%#{search.downcase}%").order('name ASC')
  end

  def as_json(options = {})
    if options[:min]
      min_json
    else
      full_json
    end
  end

  private

  def min_json
    {
      name: name,
      path: court_type_path(self)
    }
  end

  def full_json
    {
      created_at: created_at,
      id: id,
      name: name,
      updated_at: updated_at,
      path: court_type_path(self),
      courts: visible_courts_json
    }
  end

  def visible_courts_json
    courts.visible.map do |court|
      {
        name: court.name,
        path: court_path(court)
      }
    end
  end
end
