class Contact < ActiveRecord::Base
  belongs_to :court
  belongs_to :contact_type
  attr_accessible :in_leaflet, :name, :sort, :telephone, :contact_type_id

  default_scope :order => :sort
end
