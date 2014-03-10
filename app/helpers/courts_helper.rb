module CourtsHelper
  def print_view
    /leaflets/i =~ request.env['PATH_INFO']
  end

  def display_court_numbers(court, longform = false)
    court_numbers = []
    if court.court_number.present?
      court_numbers << (longform ? "Court/tribunal no. #{court.court_number}" : "##{court.court_number}")
    end

    if court.cci_code.present? && court.cci_code != court.court_number
      court_numbers << (longform ? "County Court Index #{court.cci_code}" : "CCI #{court.cci_code}")
    end

    court_numbers = court_numbers.join(', ')
    court_numbers = "(#{court_numbers})" if (!longform && court_numbers.present?)
    court_numbers
  end

  def family_areas_of_law(&block)
    AreaOfLaw.where(name: ['Children', 'Divorce', 'Adoption']).each do |area|
      block.call area.name, area.id
    end
  end
  
end
