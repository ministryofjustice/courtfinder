# == Schema Information
#
# Table name: emergency_messages
#
#  id                    :integer not null, primary key
#  show                  :boolean not null default: false
#  message               :text
#

class EmergencyMessage < ActiveRecord::Base
  before_create :only_one_record_allowed


  attr_accessible :show, :message

  validates :show, inclusion: [true, false]

  private
    def only_one_record_allowed
      errors.add(:base, "You can create only one emergency message") if EmergencyMessage.count > 1
    end

end
