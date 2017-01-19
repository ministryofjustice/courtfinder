require 'pry'
require "rubygems"
require "google_drive"

class Connection

  def initialize
    @client = nil
  end

  def open!
    @client = OAuth2::Client.new(
        ENV['CLIENT_ID'], ENV['CLIENT_SECRET'],
        site: "https://accounts.google.com",
        token_url: "/o/oauth2/token",
        authorize_url: "/o/oauth2/auth"
      )
  end

  def open?
    !@client.nil?
  end

  def refresh_token!
    @auth_token ||= OAuth2::AccessToken.from_hash(@client,
                                               {:refresh_token => ENV['REFRESH_TOKEN'], :expires_at => ENV['EXPIRES_AT']})
    @auth_token = @auth_token.refresh!
  end

  def get_drive_session!
    Rails.logger.info "Using timesheet titled: #{ENV['SPREADSHEET_TIMESHEET_TITLE']}"
    open! unless open?
    refresh_token!
    GoogleDrive.login_with_oauth(@auth_token.token)
  end

end
