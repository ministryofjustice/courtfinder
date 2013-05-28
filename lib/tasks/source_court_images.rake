namespace :source do

  desc "Get court images from existing website and store against relevant court"
  task :court_images => :environment do

    counter = 0

    courts = Court.all

    courts.each do |court|

      puts "Attempting to source court image for #{court.name}"

      court.fetch_image_file
      counter += 1 if court.save!

    end

    puts ">>> #{counter} of #{courts.length} court images added"

  end

end