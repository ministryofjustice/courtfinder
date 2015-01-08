require 'spec_helper'

describe IpLocation do
	let(:ip){ '123.234.012.345' }
	let(:parsed_json){ ['my', 'parsed', 'json'] }
	let(:location){ 
		{
			'irrelevant_key_1' => 'irrelevant value 1',
			'country_name' => 'country_name value',
			'region_name' => 'region_name value',
			'city' => 'city value'
		}
	}

	describe "find" do
		before{
			subject.stub(:lookup_ip).and_return(location)
			subject.stub(:interesting_location_values).and_return(location)
			subject.stub(:format).and_return('formatted result')
		}
		it "looks up the ip" do
			subject.should_receive(:lookup_ip).with(ip).and_return(location)
			subject.find(ip)
		end

		it "gets the interesting_location_values" do
			subject.should_receive(:interesting_location_values).with(location).and_return(location)
			subject.find(ip)
		end

		it "formats the result" do
			subject.should_receive(:format).with(location).and_return('formatted result')
			subject.find(ip)
		end
 	end

 	describe "interesting_location_values" do
 		context "given a hash with many keys" do
 			describe "the value of the country_name key" do
 				it 'is included' do
 					expect(subject.send(:interesting_location_values, location)).to include('country_name value')
 				end
 			end

 			describe "the value of the region_name key" do
 				it 'is included' do
 					expect(subject.send(:interesting_location_values, location)).to include('region_name value')
 				end
 			end

 			describe "the value of the city key" do
 				it 'is included' do
 					expect(subject.send(:interesting_location_values, location)).to include('city value')
 				end
 			end

 			describe "a key that's not country_name, region_name or city" do
 				it "is not included" do
 					expect( subject.send(:interesting_location_values, location)).to_not include( 'irrelevant value 1')
 				end
 			end
 		end
 	end

	describe "lookup_ip" do
		before{
			RestClient.stub(:get).and_return('Rest response')
			JSON.stub(:parse).and_return( parsed_json )
		}

		it "makes the url" do
			subject.should_receive(:make_url).with(ip).and_return('http://my.constructed/url')
			subject.send(:lookup_ip, ip)
		end

		it "makes a rest call to the made url" do
			RestClient.should_receive(:get).and_return('Rest response')
			subject.send(:lookup_ip, ip)
		end

		it "returns the rest response parsed as JSON" do
			JSON.should_receive(:parse).with('Rest response').and_return(parsed_json)
			subject.send(:lookup_ip, ip)
		end
	end

	describe "make_url" do
		it "returns 'http://freegeoip.net/json/' plus the given ip" do
			expect(subject.make_url(ip)).to eq("http://freegeoip.net/json/#{ip}")
		end
	end

	describe "format" do
		context "first element is 'Reserved'" do
			let(:params){ ['Reserved', 'Donald', 'Duck'] }

			it "returns 'LOCALHOST'" do
				expect( subject.format( params ) ).to eq('LOCALHOST')
			end
		end

		context "first element is not 'Reserved'" do
			let(:params){ ['NotReserved'] }

			context "and there is only one element" do
				it "returns the first element" do
					expect( subject.format(params) ).to eq('NotReserved')
				end
			end
			context "and there are several elements" do
				before{ params << 'SecondElement' }
				
				it "returns all elements joined with '->'" do
					expect( subject.format(params) ).to eq('NotReserved->SecondElement')
				end
			end
		end
	end
end