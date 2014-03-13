class PostcodeCourt < ActiveRecord::Base
  attr_accessible :postcode

  belongs_to :court

  validates :postcode, :court, presence: true
  validates :postcode, format: /[A-Za-z0-9]/, uniqueness: true
end
