require 'spec_helper'

describe CourtsHelper do
  describe "Court numbers display helper" do
    before do 
      @court1 = FactoryGirl.create(:court, :name => "London Court")
      @court2 = FactoryGirl.create(:court, :name => "London Court", :court_number => 2434)
      @court3 = FactoryGirl.create(:court, :name => "London Court", :cci_code => 980)
      @court4 = FactoryGirl.create(:court, :name => "London Court", :court_number => 2434, :cci_code => 980)
      @court5 = FactoryGirl.create(:court, :name => "London Court", :court_number => 899, :cci_code => 899)
    end

    context "when a court has neither court_number nor cci_code" do
      it "displays an empty string for short form" do
        helper.display_court_numbers(@court1).should == ''
      end

      it "displays an empty string for long form" do
        helper.display_court_numbers(@court1, true).should == ''
      end
    end

    context "when court has only court_number and no cci_code" do
      it "displays just the court_number for short form" do
        helper.display_court_numbers(@court2).should == '(#2434)'
      end

      it "displays just the court_number for long form" do
        helper.display_court_numbers(@court2, true).should == 'Court/tribunal no. 2434'
      end
    end

    context "when court has only cci_code and no court_number" do
      it "displays just the cci_code for short form" do
        helper.display_court_numbers(@court3).should == '(CCI 980)'
      end

      it "displays just the cci_code for long form" do
        helper.display_court_numbers(@court3, true).should == 'County Court Index 980'
      end
    end

    context "when court has court_number and cci_code" do
      it "it displays both the court_number and cci_code for short form" do
        helper.display_court_numbers(@court4).should == '(#2434, CCI 980)'
      end
      it "displays both the court_number and cci_code for long form" do
        helper.display_court_numbers(@court4, true).should == 'Court/tribunal no. 2434, County Court Index 980'
      end
    end

    context "when cci_code exists but is the same as the court_number" do
      it "displays just the court_number for short form" do
        helper.display_court_numbers(@court5).should == '(#899)'
      end
      it "displays just the court_number for long form" do
        helper.display_court_numbers(@court5, true).should == 'Court/tribunal no. 899'
      end
    end
  end
end
