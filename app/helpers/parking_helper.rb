module ParkingHelper
  def parking_text_for(location_and_cost)
    if location_and_cost == 'parking_onsite_none'
      @no_onsite_parking = true
      return nil
    end
    return t('parking_none') if location_and_cost == 'parking_offsite_none' && @no_onsite_parking
    t(location_and_cost)
  end
end
