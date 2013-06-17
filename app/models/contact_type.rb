class ContactType < ActiveRecord::Base
  has_many :contacts
  attr_accessible :name, :old_id

  default_scope :order => :name
end
