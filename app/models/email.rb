class Email < ActiveRecord::Base
  belongs_to :court
  belongs_to :contact_type
  attr_accessible :address, :sort, :contact_type_id

  has_paper_trail :ignore => [:created_at, :updated_at]

  default_scope :order => :sort

  def address
    self[:address].downcase if self[:address].present?
  end
end
