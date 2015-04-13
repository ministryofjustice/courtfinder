class PopulateGssCodesFromImport < ActiveRecord::Migration
  def change
    data = File.read(Rails.root.join('db', 'data', 'local_authorities.csv')) 
    csv = CSV.parse(data, :headers => true)
    csv.each_with_index do |row,i|
      parsed = {id: row[0], name: row[1], gss_code: row[2]}
      puts "(#{i}/#{csv.size}) - updating gss code on #{parsed[:name]} to #{parsed[:gss_code]}"
      la = LocalAuthority.find_or_create_by(name: parsed[:name])
      puts "=> la = #{la.inspect}"
      if la.gss_code != parsed[:gss_code]
        la.update_column(:gss_code, parsed[:gss_code])
        puts "=> updated"
      else
        puts "=> nothing to do here"
      end
    end
    
  end
end
