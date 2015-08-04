# == Schema Information
#
# Table name: emails
#
#  id              :integer          not null, primary key
#  address         :string(255)
#  court_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sort            :integer
#  contact_type_id :integer
#

require 'email_validator'

class Email < ActiveRecord::Base
  belongs_to :court
  belongs_to :contact_type
  attr_accessible :address, :sort, :contact_type_id, :court_id
  before_save :strip_whitespace

  has_paper_trail ignore: [:created_at, :updated_at], meta: {ip: :ip}
  validates_presence_of :address
  validates :address, email: true, if: ->(f) { f.address.present? }

  default_scope { order(:sort) }

  def address
    self[:address].strip.downcase if self[:address].present?
  end

  def strip_whitespace
    self[:address].strip!
  end

  def contact_type_name
    self.try(:contact_type).try(:name).blank? ? "another service" : self.contact_type.name
  end
end
