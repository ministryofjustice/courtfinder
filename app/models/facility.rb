class Facility < ActiveRecord::Base
  has_many :court_facilities
  attr_accessible :image, :name, :image_description

  default_scope :order => 'LOWER(name)' # ignore case when sorting

  def relates_to_disabled_access?
    ['Disabled access', 'Disabled toilet', 'Guide dogs'].include? name
  end
end
