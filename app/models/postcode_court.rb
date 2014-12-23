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

class PostcodeCourt < ActiveRecord::Base
  attr_accessible :postcode, :court

  belongs_to :court

  validates :postcode, :court, presence: true
  validates :postcode, format: /[A-Za-z0-9]/, uniqueness: true

  before_save :force_upcase_postcode


  def force_upcase_postcode
    self.postcode = postcode.try(:upcase)
  end

end
