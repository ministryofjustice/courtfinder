require 'pry'
require "rubygems"
require "google_drive"

puts "Using timesheet titled: #{ENV['SPREADSHEET_TIMESHEET_TITLE']}"

module Connection

  def self.setup
    @client = OAuth2::Client.new(
        ENV['CLIENT_ID'], ENV['CLIENT_SECRET'],
        :site => "https://accounts.google.com",
        :token_url => "/o/oauth2/token",
        :authorize_url => "/o/oauth2/auth")
  end

  def self.token
    @auth_token ||= OAuth2::AccessToken.from_hash(@client,
                                               {:refresh_token => ENV['REFRESH_TOKEN'], :expires_at => ENV['EXPIRES_AT']})
    @auth_token = @auth_token.refresh!
  end

  def self.get_drive_session
    setup
    token
    GoogleDrive.login_with_oauth(@auth_token.token)
  end

end
