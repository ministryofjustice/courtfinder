class ForceUpcaseOfPostcodeCourts < ActiveRecord::Migration
  def change
    lcase_postcodes = PostcodeCourt.where("postcode = LOWER(postcode)")
    lcase_postcodes.each_with_index do |pc, i|
      puts "(#{i}/#{lcase_postcodes.count}) - upcasing postcode_court #{pc.id} (#{pc.postcode})"
      pc.update_column( :postcode, pc.postcode.upcase )
    end 
  end
end
