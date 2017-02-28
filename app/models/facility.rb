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
#  image_file        :string(255)
#

class Facility < ActiveRecord::Base
  has_many :court_facilities
  attr_accessible :image, :name, :image_description, :image_file
  validates :image_file, presence: true
  validate :image_dimensions

  default_scope { order('LOWER(name)') } # ignore case when sorting

  mount_uploader :image_file, FacilityImageUploader

  private

  def image_dimensions
    return if self.image_file.blank?
    if self.image_file.width != 50 || self.image_file.height != 50
      errors.add(:image_file, "Image dimensions has to be 50x50px.")
    end
  end
end
