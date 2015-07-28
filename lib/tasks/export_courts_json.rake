namespace :export do
  desc 'Export courts.json to S3 bucket'
  task courts: :environment do
    CourtsJsonExporter.new.export!
  end
end
