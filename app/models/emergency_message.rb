# == Schema Information
#
# Table name: emergency_messages
#
#  id                    :integer not null, primary key
#  show                  :boolean not null default: false
#  message               :text
#

class EmergencyMessage < ActiveRecord::Base

  attr_accessible :show, :message

  validates :show, inclusion: [true, false]
end
