require 'carrierwave/orm/activerecord'

# Fog.credentials = {
#   aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] || 'bogus',
#   aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || 'bogus',
#   region: 'eu-west-1'
# }

# CarrierWave.configure do |config|
#   config.fog_credentials = { provider: 'AWS' }
#   config.fog_directory = ENV['APP_S3_BUCKET']
# end


CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV['S3_BUCKET'].to_s.split('.')[0]
  config.aws_acl    = :public_read
# Can't see where this is defined for fog - does fog work it out from the bucket name?
#  config.asset_host = 'http://example.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.fog_credentials = {
      :provider         => 'AWS',
      :use_iam_profile  => true,
      :region           => 'eu-west-1'
    }

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:            'eu-west-1'
  }
end