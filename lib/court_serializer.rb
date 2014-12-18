class CourtSerializer

  def initialize(court_id)
    @court = Court.find(court_id)
  end


  # def serialize
  #   {
  #     'name'          => @court.name,
  #     'slug'          => @court.slug,
  #     'updated_at'    => @court.entity_updated_at,
  #     'update_type'   => 'major',
  #     'locale'        => 
  #     'closed'        => 
  #     'alert'         => 
  #     'lat'           => 
  #     'lon'           => 
  #     'court_number'  => 
  #     'DX'            => 
  #     'areas_of_law'  => 
  #     'facilities'    => 
  #     'parking'       => 
  #     'opening_times' => 
  #     'addresses'     => 
  #     'contacts'      => 
  #     'emails'        => 
  #   }





  # end
  


end
