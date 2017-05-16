module CourtsHelper
  def print_view
    /leaflets/i =~ request.env['PATH_INFO']
  end

  def display_court_numbers(court, longform = false)
    court_numbers = []

    if court.court_number.present?
      court_numbers << court_number(court, longform)
    end

    if court.cci_code.present? && court.cci_code != court.court_number
      court_numbers << cci_code(court, longform)
    end

    court_numbers = court_numbers.join(', ')
    court_numbers = "(#{court_numbers})" if !longform && court_numbers.present?
    court_numbers
  end

  def family_areas_of_law(&_block)
    AreaOfLaw.where(name: area_of_law_list).each do |area|
      yield area.name, area.id
    end
  end

  def towns_with_county_where_duplicates_exist
    towns = Town.with_county_name.with_duplicate_count.select('towns.id, towns.name')
    towns.map { |town| TownDisambiguator.new(town) }
  end

  private

  def court_number(court, longform)
    return "##{court.court_number}" unless longform
    "Court/tribunal no. #{court.court_number}"
  end

  def cci_code(court, longform)
    return "CCI #{court.cci_code}" unless longform
    "County Court Index #{court.cci_code}"
  end

  def area_of_law_list
    [AreaOfLaw::Name::CHILDREN, AreaOfLaw::Name::DIVORCE,
     AreaOfLaw::Name::ADOPTION, AreaOfLaw::Name::CIVIL_PARTNERSHIP]
  end
end
