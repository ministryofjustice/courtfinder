class Admin::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def purge_cache(string_or_regex)
    unless Rails.env.development?
      client = Varnish::Client.new('127.0.0.1', 80, request.host)
      case string_or_regex
      when String
        client.ban(string_or_regex)
      when Regexp
        client.purge(string_or_regex.to_s)
      end
    end
  end

  def purge_all_pages
    purge_cache(/.*/)
  end
end
