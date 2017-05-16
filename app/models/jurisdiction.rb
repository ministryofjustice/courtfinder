# == Schema Information
#
# Table name: jurisdictions
#
#  id                 :integer          not null, primary key
#  remit_id           :integer          not null
#  local_authority_id :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Jurisdiction < ActiveRecord::Base
  belongs_to :remit
  belongs_to :local_authority
  has_paper_trail ignore: %i[created_at updated_at], meta: { ip: :ip }
end
