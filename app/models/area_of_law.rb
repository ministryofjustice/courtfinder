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

  module Name
    ADOPTION           = 'Adoption'
    BANKRUPTCY         = 'Bankruptcy'
    CHILDREN           = 'Children'
    DIVORCE            = 'Divorce'
    HOUSING_POSSESSION = 'Housing possession'
    MONEY_CLAIMS       = 'Money claims'
  end

  class << self
    {
      adoption:           Name::ADOPTION,
      bankruptcy:         Name::BANKRUPTCY,
      children:           Name::CHILDREN,
      divorce:            Name::DIVORCE,
      housing_possession: Name::HOUSING_POSSESSION,
      money_claims:       Name::MONEY_CLAIMS
    }.each do |method_name, area_of_law_name|
      define_method method_name do
        find_by_name! area_of_law_name
      end
    end
  end

  attr_accessible :name, :old_id, :slug, :type_possession,
    :type_bankruptcy, :type_money_claims, :type_children, :type_adoption,
    :type_divorce, :group_id, :old_ids_split, :action
  has_many :remits
  has_many :courts, through: :remits
  belongs_to :group, class_name: 'AreaOfLawGroup'
  has_and_belongs_to_many :external_links

  validates :name, presence: true

  default_scope -> { order('areas_of_law.name') }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]

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
