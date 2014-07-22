module ParkingHelper
  def parking_text_for(location_and_cost)
    case location_and_cost
    when 'outside-paid'
      'There is external parking and it is paid.'
    when 'outside-free'
      'There is external parking and it is free.'
    when 'inside-free'
      'The court has free parking.'
    when 'inside-paid'
      'The court has paid parking.'
    end
  end
end
