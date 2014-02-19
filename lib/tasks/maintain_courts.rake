namespace :maintenance do
  desc "Delete PostcodeCourt records with nil court_ids, created because of an incorrectly defined model association"
  task :clean_postcode_courts => :environment do
    puts "Deleting PostcodeCourt records with nil court_ids"
    PostcodeCourt.where("court_id IS NULL").destroy_all
  end
end
