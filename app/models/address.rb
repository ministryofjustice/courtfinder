class Address < ActiveRecord::Base
  belongs_to :town
  belongs_to :address_type
  belongs_to :court
  attr_accessible :address_line_1, :address_line_2, :address_line_3, :address_line_4, :dx, :name, :postcode, :town_id, :address_type_id
  validates_presence_of :address_line_1, :town

  # Output address_lines fields of an address separated by comma or specified delimiter
  def addressLines(glue=',')
    lines = [
      address_line_1,
      address_line_2,
      address_line_3,
      address_line_4
    ]

    # Remove empty lines and join by parameter
    lines.select{|i|i.present?}.map{|i|i}.join glue
  end

  # Output full address separated by comma or specified delimiter
  def full(glue=',')
    lines = [
      address_line_1,
      address_line_2,
      address_line_3,
      address_line_4
    ]

    if town.present?
      lines.push town.name, town.county.name
    end

    lines.push postcode
    
    # Remove empty lines and join by parameter
    lines.select{|i|i.present?}.map{|i|i}.join glue
  end
end
