module ParkingHelper
  def parking_text_for(parking_type, paid)
    case parking_type
    when 'outside'
      case paid
      when true
        'There is external parking and it is paid.'
      when false
        'There is external parking and it is free.'
      end
    when 'inside'
      case paid
      when true
        'The court has paid parking.'
      when false
        'The court has free parking.'
      end
    end
  end
end
