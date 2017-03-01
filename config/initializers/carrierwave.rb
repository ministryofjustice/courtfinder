CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                                           # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'] || '',                           # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || '',                           # required
    region:                'eu-west-1'                                      # optional, defaults to nil
  }

  config.fog_directory  = ENV['APP_S3_BUCKET']                         # required
  config.fog_public     = true                                             # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }  # optional, defaults to {}
  config.storage = (ENV['UPLOADER_STORAGE_TYPE']) ? ENV['UPLOADER_STORAGE_TYPE'].to_sym : :file
end
