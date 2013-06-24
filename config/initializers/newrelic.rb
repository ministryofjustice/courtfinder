::NewRelic::Agent.manual_start(license_key: ENV['NEWRELIC_LICENSE_KEY'],
                               app_name: "Court Finder (#{ENV['APP_PLATFORM']})")
if defined? ::Unicorn
  ::NewRelic::Agent.after_fork(:force_reconnect => true)
end
