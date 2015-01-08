require "spec_helper"

describe Address do

  describe 'gov uk pushable' do

    it 'should register a gov uk update job on update' do
      court = create(:court, :name => "London Court")
      address = Address.create( {address_line_1: 'Room 101', town: Town.create!, court: court}, without_protection: true)
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      address.address_line_2 = 'MOJ'
      address.save
    end

    it 'should register a gov uk update job on create' do
      court = create(:court, :name => "London Court")
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      address = Address.create( {address_line_1: 'Room 101', town: Town.create!, court: court}, without_protection: true)
    end

    it 'should register a gov uk update job on destroy' do
      court = create(:court, :name => "London Court")
      address = Address.create( {address_line_1: 'Room 101', town: Town.create!, court: court}, without_protection: true)
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      address.destroy
    end

  end

	subject { Address.new(address_line_1: 'address line 1', address_line_2: 'address line 2', postcode: 'TS12 3AB') }

	describe "#lines" do
		before{subject.address_line_1 = 'address line 1'}
		
		it "returns an array" do
			expect(subject.lines).to be_a(Array)
		end

		it "includes address_line_1" do
			expect(subject.lines).to include(subject.address_line_1)
		end

		context "when address_line_2 is present" do
			before{ subject.address_line_2 = 'address line 2' }
			
			it "includes address_line_2" do
				expect(subject.lines).to include(subject.address_line_2)
			end
		end
		context "when address_line_2 is not present" do
			before{ subject.address_line_2 = nil }

			it "does not include address_line_2" do
				expect(subject.lines).to_not include(subject.address_line_2)
			end
		end

		context "when address_line_3 is present" do
			before{ subject.address_line_3 = 'address line 3' }
			
			it "includes address_line_3" do
				expect(subject.lines).to include(subject.address_line_3)
			end
		end
		context "when address_line_3 is not present" do
			before{ subject.address_line_3 = nil }

			it "does not include address_line_3" do
				expect(subject.lines).to_not include(subject.address_line_3)
			end
		end

		context "when address_line_4 is present" do
			before{ subject.address_line_4 = 'address line 4' }
			
			it "includes address_line_4" do
				expect(subject.lines).to include(subject.address_line_4)
			end
		end
		context "when address_line_4 is not present" do
			before{ subject.address_line_4 = nil }

			it "does not include address_line_4" do
				expect(subject.lines).to_not include(subject.address_line_4)
			end
		end
	end

	describe '#address_lines' do
		it "joins lines with the given glue" do
			expect( subject.address_lines(' | ') ).to eq('address line 1 | address line 2')
		end
	end

	describe "#full" do
		it "starts with all present lines, joined with the glue" do
			expect(subject.full('|')).to start_with('address line 1|address line 2')
		end

		context "when a town is present" do
			let(:town){ Town.new(name: 'Testington') }
			let(:county){ County.new(name: 'Testshire') }

			before{ 
				subject.town = town 
				subject.town.send(:county=, county)
			}

			it "includes the name of the town and county" do
				expect(subject.full('|')).to include('Testington|Testshire')
			end
		end

		it "includes the postcode" do
			expect(subject.full('|')).to include('TS12 3AB')
		end

		describe "any blank element" do
			before{ 
				subject.address_line_2 = nil
			}
			it "gets removed" do
				expect(subject.full('|')).to_not match( /\|\s*\|/ )
			end
		end
	end

	describe ".primary" do
		let(:town){ Town.create!(name: 'Testington') }
		
		context "when several primary addresses exist" do
			let!(:primary_1){ Address.create!(address_line_1: 'address 1', town: town, is_primary: true) }
			let!(:primary_2){ Address.create!(address_line_1: 'address 2', town: town, is_primary: true) }
	
			it "returns the first only" do
				expect(Address.primary).to eq(primary_1)
			end
		end
		context "when non-primary addresses exist" do
			let!(:non_primary_1){ Address.create!(address_line_1: 'address 1', town: town, is_primary: false) }
			let!(:primary_1){ Address.create!(address_line_1: 'address 2', town: town, is_primary: true) }
	
			it "returns the first primary address only" do
				expect(Address.primary).to eq(primary_1)
			end
		end
	end
end