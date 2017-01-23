Raven.configure do |config|
  config.dsn = ENV.fetch("RAVEN_DSN", "") 
  config.environments = %w[staging production]
end

