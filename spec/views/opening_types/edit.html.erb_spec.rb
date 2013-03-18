require 'spec_helper'

describe "opening_types/edit" do
  before(:each) do
    @opening_type = assign(:opening_type, stub_model(OpeningType,
      :name => "MyString"
    ))
  end

  it "renders the edit opening_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", opening_type_path(@opening_type), "post" do
      assert_select "input#opening_type_name[name=?]", "opening_type[name]"
    end
  end
end
