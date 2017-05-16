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
    if image_file.blank?
      errors.add(:image_file, image_validation_messages[:blank])
    elsif !image_file.file.extension.casecmp('png').zero?
      errors.add(:image_file, image_validation_messages[:extension])
    elsif image_file.path.include?('/tmp/') && image_file.width != 50 && image_file.height != 50
      errors.add(:image_file, image_validation_messages[:dimension])
    end
  end

  def image_validation_messages
    {
      blank: I18n.t('activerecord.errors.models.facility.attributes.image_file_blank'),
      extension: I18n.t('activerecord.errors.models.facility.attributes.image_file_extension'),
      dimension: I18n.t('activerecord.errors.models.facility.attributes.image_file_dimension')
    }
  end

  def store_image_file_path
    return if image_file.blank? || image_file_path == image_file.path
    update(image_file_path: image_file.path)
  end
end
