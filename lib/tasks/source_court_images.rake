namespace :source do

  desc "Get court images from existing website and store against relevant court"
  task :court_images => :environment do
    counter = 0
    Court.find_each do |court|
      begin
        puts "Attempting to source court image for #{court.name}"

        court.fetch_image_file
        counter += 1 if court.save!
      rescue
        puts $!
      end
    end

    puts ">>> #{counter} of #{Court.count} court images added"
  end
end
