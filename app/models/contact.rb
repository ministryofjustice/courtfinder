class Contact < ActiveRecord::Base
  belongs_to :court
  belongs_to :contact_type
  attr_accessible :in_leaflet, :name, :sort, :telephone, :contact_type_id

  validates :telephone, presence:true, contact: true

  has_paper_trail :ignore => [:created_at, :updated_at]

  default_scope :order => :sort

  def contact_type_name
    self.contact_type.name.blank? ? "another service" : self.contact_type.name
  end
end
