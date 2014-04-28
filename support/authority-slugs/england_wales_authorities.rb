require 'json'

filename = 'authorities.json'
authorities = JSON.parse( IO.read(filename) )

filename_output =

File.open('england_wales_authorities.csv', "w" ) do |f|
  f.puts "Councils"
  authorities.each_pair do |k, v|
    f.puts v["name"] if v["country"] == "E" || v["country"] == "W"
  end
end


