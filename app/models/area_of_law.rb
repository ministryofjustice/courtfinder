require 'cgi'
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
#  external_link     :string           limit: 2048
#  external_link_desc :string           limit: 255
#

class AreaOfLaw < ActiveRecord::Base

  module Name
    ADOPTION           = 'Adoption'
    BANKRUPTCY         = 'Bankruptcy'
    CHILDREN           = 'Children'
    DIVORCE            = 'Divorce'
    HOUSING_POSSESSION = 'Housing possession'
    MONEY_CLAIMS       = 'Money claims'
    CIVIL_PARTNERSHIP  = 'Civil partnership'
  end

  class << self
    {
      adoption:           Name::ADOPTION,
      bankruptcy:         Name::BANKRUPTCY,
      children:           Name::CHILDREN,
      divorce:            Name::DIVORCE,
      housing_possession: Name::HOUSING_POSSESSION,
      money_claims:       Name::MONEY_CLAIMS,
      civil_partnership:  Name::CIVIL_PARTNERSHIP
    }.each do |method_name, area_of_law_name|
      define_method method_name do
        find_by_name! area_of_law_name
      end
    end

    def family_group
      [AreaOfLaw::Name::CHILDREN,
       AreaOfLaw::Name::DIVORCE,
       AreaOfLaw::Name::ADOPTION,
       AreaOfLaw::Name::CIVIL_PARTNERSHIP]
    end

    def civil_group
      [AreaOfLaw::Name::MONEY_CLAIMS,
       AreaOfLaw::Name::HOUSING_POSSESSION,
       AreaOfLaw::Name::BANKRUPTCY]
    end
  end

  attr_accessible :name, :old_id, :slug, :type_possession, :type_bankruptcy,
    :type_money_claims, :type_children, :type_adoption, :type_divorce,
    :group_id, :external_link, :external_link_desc

  has_many :remits
  has_many :courts, through: :remits
  belongs_to :group, class_name: 'AreaOfLawGroup'
  has_and_belongs_to_many :external_links

  validates :name, presence: true

  default_scope -> { order('areas_of_law.name') }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]

  include Rails.application.routes.url_helpers

  scope :search, (lambda do |search|
    where('LOWER(name) like ?', "%#{search.downcase}%").
      order('name ASC')
  end)
  scope :has_courts, -> { includes(:courts).where('courts.id IS NOT NULL') }

  def path
    area_of_law_path(self)
  end

  def as_json(options = {})
    super({ only: ['name'], methods: ['path'] }.merge(options))
  end

  def empty?
    courts.count.zero?
  end

  def external_link
    link = super()
    CGI.unescape(link) unless link.nil?
  end

  def external_link=(link)
    link = CGI.escape(link) unless link.nil?
    super(link)
  end

end
