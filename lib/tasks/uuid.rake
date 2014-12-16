namespace :import do

  desc 'add a uuid to every record without one'
  task :uuids => :environment do
    courts = Court.where(:uuid => nil)
    puts ">>>> Adding UUIDs to #{courts.size} records."
    courts.each { |c| c.save }
  end
end