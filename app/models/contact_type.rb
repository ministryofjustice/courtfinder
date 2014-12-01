# == Schema Information
#
# Table name: contact_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  old_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactType < ActiveRecord::Base
  has_many :contacts
  attr_accessible :name, :old_id

  default_scope { order(:name) }
end
