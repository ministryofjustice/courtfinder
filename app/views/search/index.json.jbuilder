json.array! @results.fetch(:courts) do |court|
  json.set! "@id", court_path(court)
  json.name court.name if court.name?
end
