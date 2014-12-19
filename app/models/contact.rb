# == Schema Information
#
# Table name: contacts
#
#  id              :integer          not null, primary key
#  telephone       :string(255)
#  court_id        :integer
#  contact_type_id :integer
#  in_leaflet      :boolean
#  sort            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Contact < ActiveRecord::Base

  include Concerns::Court::GovUkPushable

  belongs_to :court
  belongs_to :contact_type
  attr_accessible :in_leaflet, :name, :sort, :telephone, :contact_type_id

  validates :telephone, presence:true, contact: true
  # validates :telephone, presence: true

  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip}

  default_scope :order => :sort
  scope :with_telephones, -> { where("contact_type_id != ?", ContactType.find_by_name('DX')) }
  scope :with_dx_numbers, -> { where("contact_type_id = ?", ContactType.find_by_name('DX')) }

  def contact_type_name
    self.contact_type.name.blank? ? "another service" : self.contact_type.name
  end
end
