class GovUkPusher

  # perform push to Gov UK
  # options:
  #   - :action   - :create, :delete, :update
  #   - :court_id - id of court to be edited
  def initialize(options)
    @court = Court.find options[:court_id]
    @action = options[:action]
    @serializer = CourtSerializer.new(@court.id)
  end


  def push
    @serializer.serialize
    push_to_gov_uk unless @serializer.md5 == @court.gov_uk_md5
  end


  private

  def push_to_gov_uk
    client = GovUkApiClient.new(@action, @serializer.json)
    client.push
    if client.success?
      @court.gov_uk_md5 = @serializer.md5
      @court.gov_uk_updated_at = Time.now
      @court.public_url = client.public_url
      @court.save!
    else
      raise "Unable to push to gov.uk:  #{client.error_message}"
    end
  end
  

end





