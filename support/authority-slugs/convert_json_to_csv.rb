require 'json'
require 'awesome_print'

filename = 'authorities.json'
ap authorities = JSON.parse( IO.read(filename) )

# authorities.sort_by!{ |k,v| v['name'] }

filename_output = 'authorities.csv'

File.open( filename_output, "w" ) do |f|
  authorities.each_pair do |k, v|
    f.puts v["name"]
  end
end


