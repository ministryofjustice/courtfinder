require 'spec_helper'

describe AreaOfLawGroup do
  it {should respond_to(:name) }
  it {should validate_presence_of(:name) }
  it {should have_many(:areas_of_law) }

end
