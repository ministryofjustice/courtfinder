class AreaOfLaw < ActiveRecord::Base
  attr_accessible :name, :old_id, :slug, :type_possession, :type_bankruptcy, :type_money_claims, :type_children, :type_adoption, :type_divorce, :group_id
  has_many :courts_areas_of_law
  has_many :courts, through: :courts_areas_of_law
  has_many :court_council_links
  belongs_to :group, class_name: 'AreaOfLawGroup'

  validates :name, presence: true

  default_scope order: 'areas_of_law.name'

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  include Rails.application.routes.url_helpers

  scope :search, -> (search){ where('LOWER(name) like ?', "%#{search.downcase}%").order('name ASC') }
  scope :has_courts, -> { includes(:courts).where('courts.id IS NOT NULL') }

  def path
    area_of_law_path(self)
  end

  def as_json(options={})
    super({ only: ['name'], methods: ['path'] }.merge(options))
  end

  def empty?
    courts.count.zero?
  end

end
