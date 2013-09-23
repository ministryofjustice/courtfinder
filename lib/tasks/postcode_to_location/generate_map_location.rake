require_relative 'location'
require_relative 'location_generator'

namespace :import do

  desc "Generetes longitude and latitude data from postal code."
  task :map_location => :environment do |t, args|
    locations = Location::Location.new
    map_location_generator = Location::LocationGenerator.new(locations)
    map_location_generator.process(Court.all)

    puts "The total number of courts in the system is: #{Court.all.size}"
    puts "Success for:"
    puts "The script generated map locations for #{map_location_generator.modified_courts.size} courts."
    print_court_list map_location_generator.modified_courts
    puts "\nFailure for:"
    puts "1. The number of courts with no postal code are: #{map_location_generator.ignored_courts.size} "
    print_court_list map_location_generator.ignored_courts
    puts "2. The number of courts with a known postal code are: #{map_location_generator.not_found_court_postcode.size}"
    print_court_list map_location_generator.not_found_court_postcode
    puts "Finished."
  end

  def print_court_list(list)
    puts "These courts were:  #{list.join(', ')}" unless list.empty?
  end
end
