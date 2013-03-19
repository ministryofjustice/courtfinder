class ContactType < ActiveRecord::Base
  has_many :contacts
  attr_accessible :name, :old_id
end
