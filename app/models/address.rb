# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  address_line_1  :string(255)
#  address_line_2  :string(255)
#  address_line_3  :string(255)
#  address_line_4  :string(255)
#  postcode        :string(255)
#  dx              :string(255)
#  town_id         :integer
#  address_type_id :integer
#  court_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_primary      :boolean
#

class Address < ActiveRecord::Base
  belongs_to :town
  belongs_to :address_type
  belongs_to :court
  attr_accessible :address_line_1, :address_line_2, :address_line_3,
    :address_line_4, :dx, :name, :postcode, :town_id, :address_type_id, :is_primary, :town
  validates_presence_of :address_line_1, :town

  has_paper_trail ignore: [:created_at, :updated_at], meta: { ip: :ip }

  scope :visiting, ->() { where(address_type_id: AddressType.find_by_name("Visiting").try(:id)) }
  scope :postal, ->() { where(address_type_id: AddressType.find_by_name("Postal").try(:id)) }

  def lines
    [
      address_line_1,
      address_line_2,
      address_line_3,
      address_line_4
    ].compact
  end

  # Output address_lines fields of an address separated by comma or specified delimiter
  def address_lines(glue = ',')
    lines.join glue
  end

  # Output full address separated by comma or specified delimiter
  def full(glue = ',')
    full_address = lines
    full_address += [town.name, town.county.name] if town.present?
    full_address.push postcode

    # Remove empty lines and join by parameter
    full_address.compact.join glue
  end

  def self.primary
    where('is_primary is true').first
  end
end
