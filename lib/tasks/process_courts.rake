namespace :process do

  desc "Create links between courts and court types"
  task :court_types => :environment do

    Court.all.each do |court|

      court_type = CourtType.find_by_old_id(court.old_court_type_id)

      # Make an array of court types
      if court_type.old_ids_split.present?
        court_types = court_type.old_ids_split.split(',')
      else
        court_types = [court_type.old_id]
      end

      court_types.each do |old_id|
        
        type = CourtType.find_by_old_id(old_id)

        court_type = CourtTypesCourt.new
        court_type.court_id = court.id
        court_type.court_type_id = type.id

        court_type.save!
        puts "Added court type #{type.name} for #{court.name}"
      end

    end

  end

end