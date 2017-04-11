# == Schema Information
#
# Table name: local_authorities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LocalAuthority < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true

  has_many :jurisdictions
  has_many :remits, through: :jurisdictions
  has_many :courts, through: :remits

  scope :by_name, -> { order('LOWER(name)') }
  scope :search, ->(query) { where('LOWER(name) like ?', "#{query.downcase}%").limit(10) }

  scope :unassigned_for_area_of_law, (lambda do |area_of_law|
    joins("LEFT OUTER JOIN (jurisdictions INNER JOIN remits ON
      jurisdictions.remit_id = remits.id) ON local_authorities.id = jurisdictions.local_authority_id
      AND remits.area_of_law_id = #{area_of_law.respond_to?(:id) ? area_of_law.id : area_of_law}").
      where('remits.id IS NULL')
  end)

end
