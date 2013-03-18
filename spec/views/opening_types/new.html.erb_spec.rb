require 'spec_helper'

describe "opening_types/new" do
  before(:each) do
    assign(:opening_type, stub_model(OpeningType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new opening_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", opening_types_path, "post" do
      assert_select "input#opening_type_name[name=?]", "opening_type[name]"
    end
  end
end
