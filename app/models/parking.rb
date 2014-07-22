class Parking < ActiveRecord::Base
  attr_accessible :location_and_cost
  has_and_belongs_to_many :courts

  scope :onsite, where("location_and_cost LIKE '%onsite%'")
  scope :offsite, where("location_and_cost LIKE '%offsite%'")

  def label_text
    I18n.t(location_and_cost.match(/parking_(.+)/)[1])
  end
end
