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
  attr_accessible :image, :name, :image_description, :image_file, :image_file_path
  validate :image_file_validations

  default_scope { order('LOWER(name)') } # ignore case when sorting

  mount_uploader :image_file, FacilityImageUploader
  after_save :store_image_file_path

  private

  def image_file_validations
    if self.image_file.blank?
      errors.add(:image_file, I18n.t('activerecord.errors.models.facility.attributes.image_file_blank'))
    elsif self.image_file.file.extension.downcase != 'png'
      errors.add(:image_file, I18n.t('activerecord.errors.models.facility.attributes.image_file_extension'))
    elsif self.image_file.width != 50 && self.image_file.height != 50
      errors.add(:image_file, I18n.t('activerecord.errors.models.facility.attributes.image_file_dimension'))
    end
  end

  def store_image_file_path
    return if self.image_file.blank? || self.image_file_path == self.image_file.path
    self.update(image_file_path: self.image_file.path)
  end
end
