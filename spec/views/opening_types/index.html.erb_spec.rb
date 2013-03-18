require 'spec_helper'

describe "opening_types/index" do
  before(:each) do
    assign(:opening_types, [
      stub_model(OpeningType,
        :name => "Name"
      ),
      stub_model(OpeningType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of opening_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
