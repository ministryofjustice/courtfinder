class Parking < ActiveRecord::Base
  attr_accessible :location_and_cost
  has_and_belongs_to_many :courts

  def label_text
    I18n.t(location_and_cost.match(/parking_(.+)/)[1])
  end
end
