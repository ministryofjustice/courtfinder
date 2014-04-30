class Address < ActiveRecord::Base
  belongs_to :town
  belongs_to :address_type
  belongs_to :court
  attr_accessible :address_line_1, :address_line_2, :address_line_3, :address_line_4, :dx, :name, :postcode, :town_id, :address_type_id, :is_primary, :town
  validates_presence_of :address_line_1, :town

  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip, location: :location}

  scope :visiting, ->() { where(:address_type_id => AddressType.find_by_name("Visiting").try(:id)) }
  scope :postal, ->() { where(:address_type_id => AddressType.find_by_name("Postal").try(:id)) }

  # Output address_lines fields of an address separated by comma or specified delimiter
  def address_lines(glue=',')
    lines = [
      address_line_1,
      address_line_2,
      address_line_3,
      address_line_4
    ]

    # Remove empty lines and join by parameter
    lines.select{|i|i.present?}.join glue
  end

  # Output full address separated by comma or specified delimiter
  def full(glue=',')
    lines = address_lines(glue).split(glue)

    if town.present?
      lines.push town.name, town.county.name
    end

    lines.push postcode

    # Remove empty lines and join by parameter
    lines.select{|i|i.present?}.join glue
  end

  def self.primary
    where('is_primary is true').first
  end
end
