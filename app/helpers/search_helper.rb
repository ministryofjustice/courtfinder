module SearchHelper

  def family_court_search_found(search, area_of_law)
    "#{'Court'.pluralize(search.results.size)} dealing with applications involving #{area_of_law.name.downcase} for <strong>#{search.query}</strong>".html_safe
  end

  def area_of_law_groups
    grouped_data = AreaOfLawGroup.with_areas_of_law.includes(:areas_of_law).all
    other = AreaOfLawGroup.new(name: 'Other')
    other.areas_of_law = AreaOfLaw.where(group_id: nil).all
    grouped_data << other
    grouped_data
  end

end