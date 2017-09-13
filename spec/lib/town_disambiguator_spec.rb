require 'spec_helper'

describe TownDisambiguator do
  let(:town) { Town.new(name: 'Upper Peover') }
  subject { TownDisambiguator.new(town) }

  describe "unambiguous_name" do
    context "when it can_disambiguate?" do
      before { subject.stub(can_disambiguate?: true) }

      context "and the town has duplicates" do
        before { town.stub(duplicates: 1, county_name: 'East Yorkshire') }

        it "appends the county_name in brackets to the town name" do
          expect(subject.unambiguous_name).to eq("Upper Peover (East Yorkshire)")
        end
      end

      context "and the town has no duplicates" do
        before { town.stub(duplicates: 0, county_name: 'East Yorkshire') }

        it "returns the town name" do
          expect(subject.unambiguous_name).to eq("Upper Peover")
        end
      end
    end

    context "when it can't disambiguate" do
      before { subject.stub(can_disambiguate?: false) }
      it "returns the town name" do
        expect(subject.unambiguous_name).to eq("Upper Peover")
      end
    end
  end

  describe "can_disambiguate?" do
    context "when town responds to :duplicates" do
      before { town.stub(duplicates: 1) }

      context "when town responds to :county_name" do
        before { town.stub(county_name: 1) }

        it "returns true" do
          expect(subject.can_disambiguate?).to be_truthy
        end
      end

      context "when town doesn't respond to :county_name" do
        it "returns false" do
          expect(subject.can_disambiguate?).to be_falsey
        end
      end
    end

    context "when town doesn't respond to :duplicates" do
      it "returns false" do
        expect(subject.can_disambiguate?).to be_falsey
      end
    end
  end
end
