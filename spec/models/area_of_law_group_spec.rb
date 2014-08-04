# == Schema Information
#
# Table name: area_of_law_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe AreaOfLawGroup do
  it {should respond_to(:name) }
  it {should validate_presence_of(:name) }
  it {should have_many(:areas_of_law) }

end
