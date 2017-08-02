# == Schema Information
#
# Table name: postcode_courts
#
#  id           :integer          not null, primary key
#  postcode     :string(255)
#  court_number :integer
#  court_name   :string(255)
#  court_id     :integer
#
require 'postcode_validator'

class PostcodeCourt < ActiveRecord::Base
  attr_accessible :postcode, :court, :court_id

  belongs_to :court

  validates :postcode, :court, presence: true
  validates :postcode, postcode: true, if: ->(f) { f.postcode.present? }
  validates :postcode, uniqueness: { scope: :court_id }

  before_save :force_upcase_postcode

  def force_upcase_postcode
    self.postcode = UKPostcode.parse(postcode.try(:upcase)).to_s
  end
end
