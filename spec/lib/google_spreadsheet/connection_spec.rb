require 'spec_helper'

describe Connection do

	let(:mock_client){ double('oauth2 client') }
	let(:mock_access_token){ double('oauth2 access token', token: 'old token', refresh!: mock_refreshed_token) }
	let(:mock_refreshed_token){ double('refreshed oauth2 token', token: 'refreshed token', refresh!: 'doubly-refreshed token') }

	describe "a new connection" do
		it "has no client" do
			expect( Connection.new.send(:instance_variable_get, "@client") ).to be_nil
		end
	end

	describe "open!" do
		let(:mock_client){ double('oauth2 client') }
		before{
			OAuth2::Client.stub(:new).and_return(mock_client)
		}

		it "creates a new OAuth2::Client with the right parameters" do
			OAuth2::Client.should_receive(:new).with(
				ENV['CLIENT_ID'], ENV['CLIENT_SECRET'],
        site: "https://accounts.google.com",
        token_url: "/o/oauth2/token",
        authorize_url: "/o/oauth2/auth"
			).and_return(mock_client)
			subject.open!
		end

		it "assigns the new client to @client" do
			subject.open!
			expect( subject.send(:instance_variable_get, '@client') ).to eq(mock_client)
		end
	end

	describe "refresh_token!" do
		context "when @auth_token is nil" do
			before{
				subject.send(:instance_variable_set, "@auth_token", nil)
				subject.send(:instance_variable_set, "@client", mock_client)
				OAuth2::AccessToken.stub(:from_hash).and_return(mock_access_token)
			}

			it "creates an OAuth2::AccessToken from_hash with the right arguments" do
				OAuth2::AccessToken.should_receive(:from_hash).with(mock_client,
					{:refresh_token => ENV['REFRESH_TOKEN'], :expires_at => ENV['EXPIRES_AT']}
				).and_return(mock_access_token)
				subject.refresh_token!
			end

			it "refreshes the token" do
				mock_access_token.should_receive(:refresh!).and_return(mock_refreshed_token)
				subject.refresh_token!
			end

			it "assigns the refreshed token to @auth_token" do
				subject.refresh_token!
				expect(subject.send(:instance_variable_get, '@auth_token')).to eq(mock_refreshed_token)
			end
		end
	end

	describe "open?" do
		context "when there is a client" do
			before{
				subject.send(:instance_variable_set, "@client", mock_client)
			}
			it "is true" do
				expect(subject.open?).to be_truthy
			end
		end
		context "when there is no client" do
			before{
				subject.send(:instance_variable_set, "@client", nil)
			}
			it "is false" do
				expect(subject.open?).to be_falsey
			end
		end		
	end

	describe "get_drive_session!" do
		before{
			subject.send(:instance_variable_set, '@auth_token', mock_access_token)
		}
		context "when connection is open" do
			before{ 
				subject.stub(open?: true) 
			}

			it "does not call open!" do
				subject.should_not_receive(:open!)
				subject.get_drive_session!
			end
		end
		context "when connection is not open" do
			before{ subject.stub(open?: false) }

			it "calls open!" do
				subject.should_receive(:open!)
				subject.get_drive_session!
			end
		end

		it "refreshes the access token" do
			subject.should_receive(:refresh_token!)
			allow_vcr_connection_to_google
			subject.get_drive_session!
		end

		it "logs into GoogleDrive via oauth with the refreshed token" do
			GoogleDrive.should_receive(:login_with_oauth).with('refreshed token')
			subject.get_drive_session!
		end
	end
end




def allow_vcr_connection_to_google
	VCR.configure do |c|
    c.ignore_request do |request|
       URI(request.uri).host == 'www.googleapis.com'
    end
	end
end
