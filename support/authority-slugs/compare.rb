require 'csv'
require 'json'
require 'colorize'

@authorities = JSON.parse( File.read('authorities.json') )

@successes = 0
@failures = 0

CSV.foreach('licensify_slugs.csv') do |(slug,snac)|
  print "Checking #{slug} -> #{snac}...\n    "

  case
  when @authorities[slug].nil?
    print "No slug found".colorize(:red)
    @failures += 1
  when @authorities[slug]['ons'] != snac
    print "Snac mismatch! #{@authorities[slug]['ons']}".colorize(:red)
    @failures += 1
  when @authorities[slug]['ons'] == snac
    print "Snac matched".colorize(:green)
    @successes += 1
  end

  print "\n"
end

puts "\n"
puts "#{@successes} successes, #{@failures} failures"
