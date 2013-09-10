namespace :process do

  desc "Create links between courts and court types"  
  task :court_types => :environment do
    combined_court_types = [
      {:old_id => 2, :name => "Combined  Crown and County Court", :old_ids_split => "3,4"},
      {:old_id => 17, :name => "Crown and County Court", :old_ids_split => "3,4"},
      {:old_id => 19, :name => "Family Proceedings Court, County Court, High Court", :old_ids_split => "3,5,16"},
      {:old_id => 20, :name => "Family Proceedings Court, County Court", :old_ids_split => "3,16"},
      {:old_id => 22, :name => "County and Magistrates' Court", :old_ids_split => "3,6"},
      {:old_id => 23, :name => "County Court and the Crown Court sitting at Warrington", :old_ids_split => "3,4"},
      {:old_id => 25, :name => "County Court and District Registry", :old_ids_split => "3"},
      {:old_id => 26, :name => "Combined Crown, County and Magistrate's Court", :old_ids_split => "3,4,6"}
    ]
    puts "Deleting existing CourtTypesCourt records"
    CourtTypesCourt.destroy_all
    Court.all.each do |court|
      if court.old_court_type_id && (court_type = CourtType.find_by_old_id(court.old_court_type_id))
        # Make an array of court types
        if court_type.old_ids_split.present?
          court_types = court_type.old_ids_split.split(',')
        else
          court_types = [court_type.old_id]
        end
      else          
        combined_court_types.each do |cct|
          if court.old_court_type_id == cct[:old_id]
            court_types = cct[:old_ids_split].split(',')
          end
        end                    
      end

      if court_types
        court_types.each do |old_id|            
          type = CourtType.find_by_old_id(old_id)
          court_type_court = CourtTypesCourt.create!(:court_id => court.id, :court_type_id => type.id)
          puts "Added court type #{type.name} for #{court.name}"
        end
      end

      if court.name.downcase.include? "tribunal"
        type = CourtType.find_by_name("Tribunal")
        court_type_court = CourtTypesCourt.create!(:court_id => court.id, :court_type_id => type.id)
        puts "Added court type #{type.name} for #{court.name}"        
      end
    end
  end
end