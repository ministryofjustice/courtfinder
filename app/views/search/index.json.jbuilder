json.array! @results do |court|
  json.set! "@id", court_path(court)
  json.name court.name if court.name?
end


