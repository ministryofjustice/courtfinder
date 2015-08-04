# == Schema Information
#
# Table name: facilities
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  image             :string(255)
#  old_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_description :string(255)
#

class Facility < ActiveRecord::Base
  has_many :court_facilities
  attr_accessible :image, :name, :image_description,
    :old_id

  default_scope { order('LOWER(name)') } # ignore case when sorting
end
