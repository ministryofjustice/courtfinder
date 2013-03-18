require 'spec_helper'

describe "opening_types/show" do
  before(:each) do
    @opening_type = assign(:opening_type, stub_model(OpeningType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
