class Email < ActiveRecord::Base
  belongs_to :court
  attr_accessible :address, :description, :sort

  default_scope :order => :sort

  def address
    self[:address].downcase if self[:address].present?
  end
end
