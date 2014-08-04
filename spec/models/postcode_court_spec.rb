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

require 'spec_helper'

describe PostcodeCourt do
  pending "add some examples to (or delete) #{__FILE__}"
end
