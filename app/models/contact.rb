class Contact < ActiveRecord::Base
  belongs_to :court
  belongs_to :contact_type
  attr_accessible :in_leaflet, :name, :sort, :telephone, :contact_type_id

  validates :telephone, presence:true, contact: true

  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip}

  default_scope :order => :sort
  scope :with_telephones, -> { where("contact_type_id != ?", ContactType.find_by_name('DX')) }
  scope :with_dx_numbers, -> { where("contact_type_id = ?", ContactType.find_by_name('DX')) }

  def contact_type_name
    self.contact_type.name.blank? ? "another service" : self.contact_type.name
  end
end
