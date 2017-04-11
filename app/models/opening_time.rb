# == Schema Information
#
# Table name: opening_times
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  court_id        :integer
#  opening_type_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sort            :integer
#

class OpeningTime < ActiveRecord::Base
  belongs_to :court
  belongs_to :opening_type
  attr_accessible :name, :sort, :court_id, :opening_type_id

  has_paper_trail ignore: [:created_at, :updated_at], meta: { ip: :ip }

  default_scope { order(:sort) }
end
