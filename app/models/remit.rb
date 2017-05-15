# == Schema Information
#
# Table name: remits
#
#  id             :integer          not null, primary key
#  court_id       :integer
#  area_of_law_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Remit < ActiveRecord::Base
  belongs_to :court
  belongs_to :area_of_law
  has_many :jurisdictions
  has_many :local_authorities, through: :jurisdictions
  attr_accessible :court_id, :area_of_law_id
  has_paper_trail ignore: %i[created_at updated_at], meta: { ip: :ip }
end
