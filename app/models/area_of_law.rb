# == Schema Information
#
# Table name: areas_of_law
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  old_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  old_ids_split     :string(255)
#  action            :string(255)
#  sort              :integer
#  slug              :string(255)
#  type_possession   :boolean          default(FALSE)
#  type_bankruptcy   :boolean          default(FALSE)
#  type_money_claims :boolean          default(FALSE)
#  type_children     :boolean          default(FALSE)
#  type_divorce      :boolean          default(FALSE)
#  type_adoption     :boolean          default(FALSE)
#  group_id          :integer
#

class AreaOfLaw < ActiveRecord::Base

  attr_accessible :name, :old_id, :slug, :type_possession, :type_bankruptcy, :type_money_claims, :type_children, :type_adoption, :type_divorce, :group_id
  has_many :courts_areas_of_law
  has_many :courts, through: :courts_areas_of_law
  has_many :court_council_links
  belongs_to :group, class_name: 'AreaOfLawGroup'
  has_and_belongs_to_many :external_links

  validates :name, presence: true

  default_scope -> { order('areas_of_law.name') }

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
